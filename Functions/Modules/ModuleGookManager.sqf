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

#include "..\..\definitions.h"

#define VAR_NAME "AMBUSH_PLANNER_CLUSTERS"
#define SUFFICIENT_CLUSTER_SHIFT (_assessmentRate * 2)
#define MAX_CLUSTER_SHIFT_PER_ASSESSMENT (_assessmentRate * 7)
#define DEBUG_ARROWS_COUNT _scope

#define DEF_INFANTRY_PRESET_TANOA 1
#define DEF_INFANTRY_PRESET_SOG 2
#define DEF_INFANTRY_PRESET_IMS 3
#define DEF_INFANTRY_PRESET_CUSTOM 4

params ["_logic"];

private _spawnCondition = _logic getVariable "SpawnCondition";
if !(_spawnCondition isEqualType "") then { _spawnCondition = str _spawnCondition; };

private _assessmentRate = _logic getVariable "Sleep";
private _fnc_getAILimit = { params ["_logic"]; _logic getVariable "AILimit" };
private _groupSize = _logic getVariable "GroupSize";
private _groupSizeVar = _logic getVariable "GroupSizeVar";
private _groupsCount = _logic getVariable "GroupsCount";
private _groupsCountVar = _logic getVariable "GroupsCountVar";
private _spawnDistanceMoving = _logic getVariable "SpawnDistanceMoving";
private _spawnDistanceStationary = _logic getVariable "SpawnDistanceStationary";
private _gookSensesRadius = _logic getVariable "GookSensesRadius";
private _areaModules = synchronizedObjects _logic select { typeOf _x == "FS_GookArea_Module" };
private _assignedCurator = _logic getVariable "AssignedCurator";
private _debug = _logic getVariable "Debug";
private _revealTrapsToSides = _logic getVariable "RevealTrapsToSides";
if (_revealTrapsToSides isEqualType "") then { _revealTrapsToSides = call compile _revealTrapsToSides; };

private _sniperTreeClasses = _logic getVariable "SniperTreeClasses";
if (_sniperTreeClasses isEqualType "") then { _sniperTreeClasses = call compile _sniperTreeClasses; };
private _vehicleClasses = _logic getVariable "VehicleClasses";
if (_vehicleClasses isEqualType "") then { _vehicleClasses = call compile _vehicleClasses; };
private _infantryClassesPreset = _logic getVariable "InfantryClassesPreset";


private _infantryClasses = [];


switch _infantryClassesPreset do {
	case DEF_INFANTRY_PRESET_TANOA: { 
		_infantryClasses = ["O_T_Soldier_F"];
	};
	case DEF_INFANTRY_PRESET_SOG: { 
		{
			if (isClass (ConfigFile >> "CfgPatches" >> _x)) then {
				private _units = ((getArray( ConfigFile >> "CfgPatches" >> _x >> "units")) apply {toLowerANSI _x}) select {_x find "vn_o_men_" >= 0};
				if !( _units isEqualTo [] ) then { _infantryClasses pushBack _units };
			};
		}
		forEach ["characters_f_vietnam_c"]; // can add more CfgPatches here
		
		_infantryClasses = flatten _infantryClasses;
	};
	case DEF_INFANTRY_PRESET_IMS: {
		_infantryClasses = [ "O_soldier_Melee_Hybrid" ];
	};
	case DEF_INFANTRY_PRESET_CUSTOM: { 
		private _customInfantryClasses = _logic getVariable "CustomInfantryClasses";
		if (_customInfantryClasses isEqualType "") then { _customInfantryClasses = call compile _customInfantryClasses; };
		_infantryClasses = _customInfantryClasses;
		
		if (count _infantryClasses == 0) then {
			"Custom Infantry classes array is empty, no infantry will be spawned by Gook Manager" call BIS_fnc_error
		};
	};
	default {};
};

private _spawnedObjectsInitCode = _logic getVariable "SpawnedObjectsInitCode";
if (_spawnedObjectsInitCode isEqualType "") then { _spawnedObjectsInitCode = compile _spawnedObjectsInitCode; };


//------------------------------------------------------------------------------------


private _garbageCollector = allMissionObjects "FS_GarbageCollector_Module";
if (count _garbageCollector > 0) then {
	_garbageCollector = _garbageCollector # 0;
	private _trapsRemovalDistance = _garbageCollector getVariable "trapsRemovalDistance";
	private _gookRemovalDistance = _garbageCollector getVariable "removalDistance";
	private _spawnDistance = _spawnDistanceMoving max _spawnDistanceStationary;
	if (_gookRemovalDistance - 50 < _spawnDistance) then {
		[format ["Decrease Garbage Collector Removal Distance (%1) or decrease Gook Manager Spawn Distance (%2)", _gookRemovalDistance, _spawnDistance]] call BIS_fnc_error;
	};
};


private _scope = 4; // how many times we assess the movements before judging about a trend. Defines the length of the queue 
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

if (_revealTrapsToSides isEqualType []) then {
	[_revealTrapsToSides] spawn 
	{
		params ["_sides"];
		if (count _sides <= 0) exitWith {};
		while { true } do {
			sleep 5;
			if !(isNil{FS_AllGookTraps}) then {
				{ 
					private _mine = _x;
					_sides apply { _x revealMine _mine };
				} forEach FS_AllGookTraps;
			};
		};
	};
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
				Only a cluster that has inherited more than a half of the men of the parent cluster is considered its child
				The cluster that inherited < 50% of people is considered new 
		*/
		private _menInOldCluster = count (( _oldClusters # _indexInOldClusters ) # 1 );
		private _majorityStartsAt = ceil ( _menInOldCluster / 2 ); // use _majorityStartsAt = 0 for simply choosing the match with most common elements
		if ( _indexInNewClusters >= 0 ) then {
			if ( _matchCount >= _majorityStartsAt ) then 
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
				if ( count _coordinates == _scope ) then // Enough time passed to understand whether the group is moving somewhere or not
				{
					private _existingUnitsCount = ({side _x == EAST && alive _x && !isObjectHidden _x && isNil{_x getVariable DEF_SNIPER_FSM_HANDLE} } count allUnits);

					if ( ( call compile _spawnCondition ) && _existingUnitsCount < (_logic call _fnc_getAILimit) ) then 
					{
						if (_debug) then {
							systemChat format ["(%1) Condition to spawn Gooks passed, looking for a place...", time];
						};
						
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
						
						private _handle = [
								_next, 
								_allPlayers, 
								SUFFICIENT_CLUSTER_SHIFT, 
								[_spawnDistanceMoving, _spawnDistanceStationary],
								_gookSensesRadius, 
								[_infantryClasses, _sniperTreeClasses, _vehicleClasses],
								_spawnedObjectsInitCode,								
								_groupsCount + round random _groupsCountVar, 
								_groupSize + round random _groupSizeVar, 
								_areaModules,
								_assignedCurator,
								_debug
							] spawn FS_fnc_AttackPlanner;
						
						WaitUntil { scriptDone _handle }; 
					}
					else 
					{
						if (_debug) then 
						{
							if (_existingUnitsCount >= (_logic call _fnc_getAILimit)) then {
								private _attributeName = getText(configFile >> "CfgVehicles" >> typeOf _logic >> "Attributes" >> "AILimit" >> "displayName" );
								systemChat format ["(%1) Gooks could not be spawned because '%2' is reached (%3).", time, _attributeName, _existingUnitsCount];
							} else {
								systemChat format ["(%1) Gooks could not be spawned because 'Condition to spawn' returned False.", time];
							};
						};
					};
				};
				
			} 
			else {
				// Insert new queue to the clusters that didn't match the criteria
				private _clusterThatDidntPassCriteria = _newClusters # _indexInNewClusters;
				[_clusterThatDidntPassCriteria, _scope] call _fnc_InsertNewQueue;
				
			};
		};
	};
	
	// 5. Save new clusterization
	_previousClusterization = _newClusters;
	
};