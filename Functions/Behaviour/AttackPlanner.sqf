
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
				private _marker = createMarkerLocal [str(round random(1000000)), _result];
				_marker setMarkerTypeLocal "mil_dot";
				_marker setMarkerColor "ColorWhite";
				_marker setMarkerText "Spawn blocked by safe area";
				_marker spawn {
					// gradually increase transparency
					private _lifetime = 10;
					for [{_j = 0},{_j < _lifetime},{_j = _j + _lifetime / 10}] do {
						sleep (_lifetime / 10);
						_this setMarkerAlphaLocal linearConversion [0, _lifetime, _j, 1, 0];
					};
					deleteMarker _this;
				};
			};
		};
	};
	
	if (_goodPositionFound) exitWith {
		if ( _target isEqualTo [] ) then {
			_target = _result getDir _clusterCenter; // Passing the heading to look at to the FSM
		};
		
		if ( _debug ) then {
			private _marker = createMarkerLocal [str(round random(1000000)), _result];
			_marker setMarkerTypeLocal "mil_dot";
			_marker setMarkerColor "ColorRed";
			_marker setMarkerText (["An attack from here!", "Ambush here!"] select _isAmbush);
			_marker spawn {
				// gradually increase transparency
				_lifetime = 10;
				for [{_i = 0},{_i < _lifetime},{_i = _i + _lifetime / 10}] do {
					sleep (_lifetime / 10);
					_this setMarkerAlphaLocal linearConversion [0, _lifetime, _i, 1, 0];
				};
				deleteMarker _this;
			};
		};
		
		private _handler = [_result, _target, _groupSize, _groupsCount, _proposedClasses, _debug] spawn FS_fnc_SpawnGooks;
		waitUntil { sleep 2; scriptDone _handler };
	};
};