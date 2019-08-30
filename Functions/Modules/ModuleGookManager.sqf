/* ----------------------------------------------------------------------------
Function: FS_GookManager_Module

Description:
	This module spawns gooks around players, sets up ambushes, generally making
	the jungle "alive". 
	
	Watch out, they're in the trees! And plains. And, possibly, rivers.
	
Parameters:
    _module - The module logic.
	
Returns:
    Nothing.

Author:
    kaydol
---------------------------------------------------------------------------- */

#define VAR_NAME "AMBUSH_PLANNER_CLUSTERS"
#define SUFFICIENT_CLUSTER_SHIFT (_assessmentRate * 0.5)
#define MAX_CLUSTER_SHIFT_PER_ASSESSMENT (_assessmentRate * 6)
#define DEBUG_ARROWS_COUNT _scope

params ["_logic"];

_spawnCondition = _logic getVariable "SpawnCondition";
_assessmentRate = _logic getVariable "Sleep";
_ailimit = _logic getVariable "AILimit";
_groupSize = _logic getVariable "GroupSize";
_groupSizeVar = _logic getVariable "GroupSizeVar";
_groupsCount = _logic getVariable "GroupsCount";
_groupsCountVar = _logic getVariable "GroupsCountVar";
_debug = _logic getVariable "Debug";
_spawnDistance = _logic getVariable "SpawnDistance";

/*
_fsm = _logic getVariable "fsm";
if (isNil{ _fsm }) then 
{
	_fsm = [_logic, _spawnProbability, _sleep, _ailimit, _groupSize, _groupsCount, _debug] execFSM "\FS_Vietnam\FSM\GookManager.fsm";
	_logic setVariable ["fsm", _fsm];
};
*/
// Use to stop spawning new Gooks
//_fsm setFSMVariable ["_moduleActive", false];

private _scope = 3; 
private _previousClusterization = [];

/*
	Inserts a new queue containing the center of the cluster into the cluster
	Parameters:
		_this select 0: cluster in format [_clusterPos, _clusterElems]
		_this select 1: size of the queue
*/
private _fnc_InsertNewQueue = {
	params ["_cluster", "_scope"];
	private _queue = [_scope] call FS_fnc_QueueCreate; // Each cluster will store a queue of its previous positions
	[_queue, _cluster # 0] call FS_fnc_QueuePush; // Storing the first position into a queue
	_cluster pushBack _queue; // Storing the queue to the cluster 
};

while { true } do {

	sleep _assessmentRate;
	
	private _allPlayers = call BIS_fnc_listPlayers;
	_allPlayers = _allPlayers select { side _x != EAST }; // Filter out Gook players
	_allPlayers = [_allPlayers] call FS_fnc_FilterObjects; // Filter out players who use Arsenal Room
	
	// 1. Get old clusterization
	private _oldClusters = _previousClusterization;
	
	// 2. Get new clusterization
	private _newClusters = [_allPlayers, 35] call FS_fnc_AgglomerativeClustering; 
	
	// 3. Find best matches
	private _bestPairs = [];
	for [{_i = count _oldClusters - 1},{_i >= 0},{_i = _i - 1}] do { 
		_bestPairs set [_i, [-1, 0]]; 
	};
	
	{
		_x params ["_old_clusterCenter", "_old_clusterElements"];
		private _old_index = _forEachIndex;
		
		{
			_x params ["_new_clusterCenter", "_new_clusterElements"];
			
			private _new_index = _forEachIndex;
			private _matches = count ( _old_clusterElements arrayIntersect _new_clusterElements );
			
			if (( _bestPairs # _old_index ) # 1 < _matches && _old_clusterCenter distance2D _new_clusterCenter < MAX_CLUSTER_SHIFT_PER_ASSESSMENT ) then {
				( _bestPairs # _old_index ) set [0, _new_index];
				( _bestPairs # _old_index ) set [1, _matches];
			};
		
		} forEach _newClusters;
	} forEach _oldClusters;
	
	// 4. Filter out matches based on distance travelled and the rule of majority
	for [{_indexInOldClusters = 0},{_indexInOldClusters < count _oldClusters},{_indexInOldClusters = _indexInOldClusters + 1}] do 
	{
		private _proposedMatch = _bestPairs # _indexInOldClusters; // [index of the match in _newClusters, match count]
		_proposedMatch params ["_indexInNewClusters", "_matchCount"];
		
		/* 
			The rule of majority:
				Only a cluster that have inherited more than a half of the men of the parent cluster is considered its child
				The cluster that inherited < 50% of people is considered new 
		*/
		private _menInOldCluster = count (( _oldClusters # _indexInOldClusters ) # 1 );
		private _majorityStartsAt = ceil ( _menInOldCluster / 2 ); // use _majorityStartsAt = 0 for simply choosing the match with most common elements
		
		if ( _indexInNewClusters >= 0 && _matchCount >= _majorityStartsAt ) then 
		{
			/* All criteria fullfilled, this must be the same cluster */
			
			private _prev = _oldClusters # _indexInOldClusters;
			private _next = _newClusters # _indexInNewClusters;
			
			// The previous and the current positions of this cluster [_clusterCenter, _elems, _queue]
			private _startPos = _prev # 0;
			private _endPos = _next # 0;
			
			// Draw arrows
			if ( _debug ) then {
				private _arrow = [_startPos, _endPos, [1,1,0,1], [3,1/7,3]] call BIS_fnc_drawArrow;
				[_arrow, _assessmentRate * DEBUG_ARROWS_COUNT] spawn {
					sleep ( _this # 1 );
					_this # 0 call BIS_fnc_drawArrow;
				};
			};
			
			// If there was no queue stored in the cluster, create it and add current cluster's position to the queue
			if ( count _prev == 2 ) then {
				[_prev, _scope] call _fnc_InsertNewQueue;
			};
			
			// Copy the movements queue from the prev and add new position to it
			private _queue = _prev # 2;
			[_queue, _endPos, _scope] call FS_fnc_QueuePush;
			_next set [2, _queue];
			
			// Now we can analyze the movement of this cluster to predict it's route (newest positions are stored on the left of the queue)
			private _coordinates = [_queue] call FS_fnc_QueueGetData;
			if ( count _coordinates == _scope ) then 
			{
				/* Enough time passed to understand whether the group is moving somewhere or not */
				private _timeToSpawnGooks = ( call compile _spawnCondition ) && ({side _x == EAST && alive _x} count allUnits) <= _ailimit;
				if ( _timeToSpawnGooks ) then 
				{
					/* ☭ FINALLY! IT'S TIME TO OVERTHROW CAPITALISM, COMRADES ☭ (﻿ ͡° ͜ʖ ͡°) ☭
									   
									   ----/*~\              O      ----/*~\
										(~~    ~~~)    __---=/\>     (~~    ~~~)
															  /\/
															  \
							|   ,		   \
							| O /   	  	'\ O        	 O
							|--\    	   	  \_\ 	   __---=/\>
							  / \   	 	    /\/    		  /\/ 
							  \  \  	  	    \      		  \
					*/
					_groupSize = _groupSize + round random _groupSizeVar;
					_groupsCount = _groupsCount + round random _groupsCountVar;
					
					[_next, _allPlayers, SUFFICIENT_CLUSTER_SHIFT, _spawnDistance, _groupsCount, _groupSize, _debug] spawn FS_fnc_AttackPlanner;
				};
			};
			
		} 
		else {
			// Insert new queue to the clusters that didn't match the criteria
			private _clusterThatDidntPassCriteria = _newClusters # _indexInNewClusters;
			[_clusterThatDidntPassCriteria, _scope] call _fnc_InsertNewQueue;
			
		};
	};
	
	// 5. Save new clusterization
	_previousClusterization = _newClusters;
	
};