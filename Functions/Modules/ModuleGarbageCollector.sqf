/*
	This module can remove dead bodies, placed traps, and even alive enemies
*/

#include "..\..\definitions.h"

#define DEF_DEBUG_MARKER_COLOR "colorGreen"
#define DEF_DEBUG_MARKER_TYPE "mil_dot"


params ["_module"];

private _sidesToRemove = _module getVariable "SidesToRemove";
if (_sidesToRemove isEqualType "") then {
	_sidesToRemove = call compile _sidesToRemove;
};

private _removeDead = _module getVariable "removeDead";
private _trapsRemovalDistance = _module getVariable "trapsRemovalDistance";
private _trapsThreshold = _module getVariable "trapsThreshold";
private _gookRemovalDistance = _module getVariable "removalDistance";
private _removePreplacedUnits = _module getVariable "removePreplaced";
private _debug = _module getVariable "Debug";


{
	if (_removePreplacedUnits) then {
		//-- Do not remove groups that have playable units in them 
		private _grpHasPlayableUnits = !((units _x arrayIntersect (playableUnits + switchableUnits)) isEqualTo []);
		if ( _hasPlayableUnits ) then {
			_x setVariable [DEF_GC_EXCLUDE_GROUP_VAR, true, true];
		};
	} 
	else
	{
		//-- Do not remove all preplaced groups 
		_x setVariable [DEF_GC_EXCLUDE_GROUP_VAR, true, true];
	};
} forEach AllGroups;

//-- This is not used in any way right now 
//{
//	private _vehicle = _x;
//	_vehicle setVariable [DEF_GC_EXCLUDE_VAR, true, true];
//	{ _x setVariable [DEF_GC_EXCLUDE_VAR, true, true]; } forEach crew _vehicle;
//} forEach vehicles;



while { true } do 
{
	//----------------------//
	// 	Remove dead bodies	//
	//----------------------//
	
	if ( _removeDead >= 0 ) then
	{
		private _counter = 0;
		
		{
			if !(isNull _x) then 
			{
				private _body = _x;
				if !(_body getVariable [DEF_GC_EXCLUDE_VAR, false]) then 
				{
					if (_debug) then 
					{
						private _marker = [[getPos _body select 0, getPos _body select 1], DEF_DEBUG_MARKER_TYPE, DEF_DEBUG_MARKER_COLOR, format ["Deleted %1", typeOf _body]] call FS_fnc_CreateDebugMarker;
						[[_marker], 10, 6] spawn FS_fnc_FadeDebugMarkers; // gradually increase transparency
					};
				
					private _allPlayers = call BIS_fnc_listPlayers;
					private _distances = _allPlayers apply { _x distance _body };
					
					// Do not remove shot down helicopters
					if (_body isKindOf "AIR") exitWith {};
					
					/* Do not remove bodies that are too close to the players */
					if ( selectMin _distances > _removeDead ) then {
						deleteVehicle _body;
						_counter = _counter + 1;
					};
					
					sleep (1 + random 2);
				};
			};
		} 
		forEach AllDead;
		
		if (_debug && _counter > 0) then {
			systemChat format ["(%2) Removed %1 dead entities", _counter, time];
		};
	};
	
	
	if ( isNil { FS_AllGookTraps }) then {
		FS_AllGookTraps = [];
	};
	private _gookTraps = FS_AllGookTraps + (allSimpleObjects [] select {str _x find 'punji' > 0});
	
	//------------------------------------------------------//
	// 	First remove traps that are too far from players	//
	//------------------------------------------------------//
	private _removedTrapsCounter = 0;
	if ( _trapsRemovalDistance >= 0 ) then {
		{
			_x params ["_mine", "_posAGL", "_orientation"];
			
			if !(isNull _mine) then
			{
				private _allPlayers = call BIS_fnc_listPlayers;
				private _distances = _allPlayers apply { _x distance _mine };
				
				/* Do not remove mines that are too close to the players */
				if ( selectMin _distances > _trapsRemovalDistance ) then {
				
					if (_debug) then 
					{
						private _marker = [[getPos _mine select 0, getPos _mine select 1], DEF_DEBUG_MARKER_TYPE, DEF_DEBUG_MARKER_COLOR, format ["Deleted %1", typeOf _mine]] call FS_fnc_CreateDebugMarker;
						[[_marker], 10, 6] spawn FS_fnc_FadeDebugMarkers; // gradually increase transparency
					};
				
					deleteVehicle _mine;
					_gookTraps set [_forEachIndex, objNull];
					_removedTrapsCounter = _removedTrapsCounter + 1;
				};
				
				sleep (1 + random 2);
			};
		}
		forEach _gookTraps;
	};
	
	//------------------------------------------//
	// 	Now remove traps that exceed threshold	//
	//------------------------------------------//
	
	if ( _trapsThreshold >= 0 && count _gookTraps > _trapsThreshold ) then 
	{
		/*
			Why shuffle: I have a very strong feeling that shuffling and then removing mines 
			that didn't fit in _trapsThreshold is much faster than calculating distances from
			all mines to all players and then removing the furthermost ones.
		*/
		_gookTraps = _gookTraps call BIS_fnc_arrayShuffle; 
		
		private _i = 0;
		for [{_i = _trapsThreshold},{ _i < count _gookTraps },{ _i = _i + 1}] do 
		{
			(_gookTraps # _i) params ["_mine", "_posAGL", "_orientation"];
			
			if !(_mine isEqualTo objNull) then 
			{
				if (_debug) then 
				{
					private _marker = [[getPos _mine select 0, getPos _mine select 1], DEF_DEBUG_MARKER_TYPE, DEF_DEBUG_MARKER_COLOR, format ["Deleted %1", typeOf _mine]] call FS_fnc_CreateDebugMarker;
					[[_marker], 10, 6] spawn FS_fnc_FadeDebugMarkers; // gradually increase transparency
				};
				
				deleteVehicle _mine;
				_gookTraps set [_i, objNull]; 
				_removedTrapsCounter = _removedTrapsCounter + 1;
				sleep (1 + random 2);
			};
		};
		
		_gookTraps resize _trapsThreshold;
	};	
	if (_debug && _removedTrapsCounter > 0) then {
		systemChat format ["(%2) Removed %1 traps", _removedTrapsCounter, time];
	};
	
	FS_AllGookTraps = _gookTraps select { !(_x isEqualTo objNull) }; // to get rid of objNulls 
	publicVariable "FS_AllGookTraps";
	
	//--------------------------//
	// 	Remove strayed Gooks	//
	//--------------------------//
	
	if ( _gookRemovalDistance >= 0 ) then 
	{
		private _counter = 0;
		
		{
			if ( side _x in _sidesToRemove && !((units _x) isEqualTo []) && !(_x getVariable [DEF_GC_EXCLUDE_GROUP_VAR, false]) ) then 
			{
				private _grp = _x;
				// Find distance between the closest player and the calculated center point of the group
				private _allPlayers = call BIS_fnc_listPlayers;
				if !(_allPlayers isEqualTo []) then 
				{
					private _center2D = [units _grp] call FS_fnc_CalculateCenter2D;
					private _distToPlayers = selectMin ( _allPlayers apply { _x distance2D _center2D } );
					
					// Try to delete entire groups whose distance is beyond _gookRemovalDistance threshold
					if ( _distToPlayers > _gookRemovalDistance ) then 
					{
						private _unitPositions = units _grp apply { getPosASL _x };
						private _eyePositions = _allPlayers apply { eyePos _x };
						
						private _canSee = False;
						
						for [{_i = 0},{_i<count _eyePositions},{_i=_i+1}] do {
							for [{_j = 0},{_j<count _unitPositions},{_j=_j+1}] do {
								_canSee = [objNull, "VIEW"] checkVisibility [_eyePositions # _i , _unitPositions # _j] > 0.3 ;
								if ( _canSee ) exitWith {};
							};
							if ( _canSee ) exitWith {};
						};
						
						// Players don't have a direct LOS with any of the group members
						if !( _canSee ) then 
						{
							if (_debug) then {
								systemChat format ["(%2) Deleting a whole group of %1", count units _grp, time];
							};
							
							//-- First, collect all vehicles occupied by group
							private _occupiedVehicles = [];
							{
								if ( !(isNull _x) && vehicle _x != _x ) then {
									_occupiedVehicles pushBackUnique vehicle _x;
								};
							}
							forEach units _grp;
							
							//-- Then delete vehicle crews where they are local 
							{
								_counter = _counter + count (crew (vehicle _x));
								(vehicle _x) remoteExec ["deleteVehicleCrew", vehicle _x]; 
							} forEach _occupiedVehicles;
							
							//-- Give time to propagate changes
							sleep 1; 
							
							{
								if (_debug) then 
								{
									private _marker = [[getPos _x select 0, getPos _x select 1], DEF_DEBUG_MARKER_TYPE, DEF_DEBUG_MARKER_COLOR, format ["Deleted %1", typeOf _x]] call FS_fnc_CreateDebugMarker;
									[[_marker], 10, 6] spawn FS_fnc_FadeDebugMarkers; // gradually increase transparency
								};
							
								systemChat format ["(%1) Deleting vehicle %2", time, typeOf _x];
								deleteVehicle _x;
							} forEach _occupiedVehicles;
							
							//-- Delete whoever is left in the group 
							{
								if !(isNull _x) then {
								
									if (_debug) then 
									{
										private _marker = [[getPos _x select 0, getPos _x select 1], DEF_DEBUG_MARKER_TYPE, DEF_DEBUG_MARKER_COLOR, format ["Deleted %1", typeOf _x]] call FS_fnc_CreateDebugMarker;
										[[_marker], 10, 6] spawn FS_fnc_FadeDebugMarkers; // gradually increase transparency
									};
								
									deleteVehicle _x;
									_counter = _counter + 1;
								};
							}
							forEach units _grp;
							
							//-- Delete group where it's local
							_grp remoteExec ["deleteGroup", _grp]; 
						};
					};
				};
				sleep (1 + random 2);
			};
		}
		forEach AllGroups;
		
		if (_debug && _counter > 0) then {
			systemChat format ["(%2) Removed %1 entities", _counter, time];
		};
	};
	
	sleep 30;
};

