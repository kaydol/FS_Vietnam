
#include "..\..\definitions.h"

params ["_cluster", "_unitsToHideFrom", "_sufficientClusterShift", "_distanceToSpawn", "_groupsCount", "_groupSize", "_areaModules", ["_debug", false, [true]]];

_cluster params ["_clusterCenter", "_clusterUnits", "_queue"];

private _coordinates = [_queue] call FS_fnc_QueueGetData;

private _trend = _coordinates # 0 vectorDiff _coordinates # (count _coordinates - 1);
private _trendDir = _coordinates # (count _coordinates - 1) getDir _coordinates # 0;

private _target = [];
private _angleMin = 0;
private _angleMax = 360;
private _proposedClasses = [];

_distanceToSpawn params ["_spawnDistanceMoving", "_spawnDistanceStationary"];

// Select action based on whether the cluster has been moving or not
private _distanceTravelled = vectorMagnitude _trend;
private _isAmbush = _distanceTravelled > _sufficientClusterShift;

if ( _isAmbush ) then 
{
	/* If the cluster has been moving... */ 
	// Getting a hidden position along the direction of movement 
	_angleMin = abs( ( _trendDir - DEF_GOOK_MANAGER_AMBUSH_CONE_ANGLE / 2 ) % 360 );
	_angleMax = abs( ( _trendDir + DEF_GOOK_MANAGER_AMBUSH_CONE_ANGLE / 2 ) % 360 );
	_distanceToSpawn = _spawnDistanceMoving;
	
	_proposedClasses = DEF_GOOK_MANAGER_AMBUSH_PROPOSED_CLASSES;
}
else {
	/* The cluster has been standing still for some time... */
	_target = _clusterCenter;
	_distanceToSpawn = _spawnDistanceStationary;
};

_areaModules = _areaModules apply { [position _x, _x getVariable "Radius"] };

//-- Keep trying to find good position until maximum amount of attempts is reached 
for "_i" from 1 to 10 do 
{
	private _result = [_unitsToHideFrom, _clusterCenter, _distanceToSpawn, [_angleMin, _angleMax], 10, _debug] call FS_fnc_GetHiddenPos2;
	private _goodPositionFound = false;
	
	// If hidden position found
	if !( _result isEqualTo [] ) then 
	{
		_goodPositionFound = count (_areaModules select { _result distance2D _x # 0 < _x # 1 }) == 0;
		
		if (!_goodPositionFound) then {
			// The proposed coordinates fall into forbidden spawn areas
			if ( _debug ) then {
				private _marker = [_result, "mil_dot", "ColorWhite", "Spawn blocked by safe area"] call FS_fnc_CreateDebugMarker;
				[[_marker], 10] spawn FS_fnc_FadeDebugMarkers;
			};
		};
	};
	
	if (_goodPositionFound) exitWith {
		if ( _target isEqualTo [] ) then {
			_target = _result getDir _clusterCenter; // Passing the heading to look at to the FSM
		};
		
		if ( _debug ) then {
			private _marker = [_result, "mil_dot", "ColorRed", ["An attack from here!", "Ambush here!"] select _isAmbush] call FS_fnc_CreateDebugMarker;
			[[_marker], 10] spawn FS_fnc_FadeDebugMarkers;
		};
		
		private _handler = [_result, _target, _groupSize, _groupsCount, _proposedClasses, _debug] spawn FS_fnc_SpawnGooks;
		waitUntil { sleep 2; scriptDone _handler };
	};
};