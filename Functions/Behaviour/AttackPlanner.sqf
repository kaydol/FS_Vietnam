
#include "..\..\definitions.h"

#define DEF_THREAT_INFANTRY 0
#define DEF_THREAT_VEHICLES 1
#define DEF_THREAT_BUILDINGS 2

params ["_cluster", "_unitsToHideFrom", "_sufficientClusterShift", "_distanceToSpawn", "_gookSensesRadius", "_classes", "_spawnedObjectsInitCode", "_groupsCount", "_groupSize", "_areaModules", "_assignedCurator", ["_debug", false, [true]]];

_classes params ["_infantryClasses", "_buildingClasses", "_vehicleClasses"];
_cluster params ["_clusterCenter", "_clusterUnits", "_queue"];

private _coordinates = [_queue] call FS_fnc_QueueGetData;

private _trend = _coordinates # 0 vectorDiff _coordinates # (count _coordinates - 1);
private _trendDir = _coordinates # (count _coordinates - 1) getDir _coordinates # 0;

private _target = [];
private _angleMin = 0;
private _angleMax = 360;

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
	
	if (_goodPositionFound) exitWith 
	{
		if ( _target isEqualTo [] ) then {
			_target = _result getDir _clusterCenter; // Passing the heading to look at to the FSM
		};
		
		private _handle = 0 spawn {};
		private _possibleThreats = [DEF_THREAT_INFANTRY, DEF_THREAT_VEHICLES, DEF_THREAT_BUILDINGS];
		
		/* Spawn buildings and vehicles only in ambushes so that the players will be likely to stumble on them */
		
		// Remove buildings from the possible threats if it's not an ambush or if there are no building classes given 
		if (!_isAmbush || _buildingClasses isEqualTo []) then {
			_possibleThreats = _possibleThreats select { _x != DEF_THREAT_BUILDINGS };
		};
		// Remove vehicles from the possible threats if it's not an ambush or if there are no vehicle classes given 
		if (!_isAmbush || _vehicleClasses isEqualTo []) then {
			_possibleThreats = _possibleThreats select { _x != DEF_THREAT_VEHICLES };
		};
		
		
		private _validCurator = false;
		//-- If _assignedCurator is given as a string, try to get the global variable out of it 
		if (_assignedCurator isEqualType "" && !(_assignedCurator isEqualTo "")) then {
			_assignedCurator = missionNameSpace getVariable [_assignedCurator, objNull];
		};
		if (_assignedCurator isEqualType objNull && alive _assignedCurator) then {
			_validCurator = true;
		};
		
		
		switch (selectRandom _possibleThreats) do 
		{
			case DEF_THREAT_INFANTRY: {
				//-- Spawn infantry
				_handle = [
					_result, 
					if (_isAmbush) then {[]} else {_target}, 
					_gookSensesRadius, 
					_groupSize, 
					_groupsCount, 
					_infantryClasses, 
					_spawnedObjectsInitCode, 
					_assignedCurator, 
					_debug
				] spawn FS_fnc_SpawnGooks;
				
				if ( _debug ) then {
					private _marker = [_result, "mil_dot", "ColorRed", ["An attack from here!", "Ambush here!"] select _isAmbush] call FS_fnc_CreateDebugMarker;
					[[_marker], 10] spawn FS_fnc_FadeDebugMarkers;
				};
			};
			
			case DEF_THREAT_VEHICLES: {
				//-- Spawn vehicles 
				private _created = [selectRandom _vehicleClasses, _result, DEF_GOOK_MANAGER_VEHICLES_BEST_PLACES, 1, _unitsToHideFrom, _debug] call FS_fnc_TrySpawnObjectBestPlaces;
				if !(_created isEqualTo []) then {
					private _markers = [];
					_created apply 
					{
						// Make vehicle look at target 
						// Twin spider holes have incorrect forward orientation
						if (toLowerANSI typeOf _x in ["vn_o_vc_spiderhole_03", "vn_o_nva_spiderhole_03"]) then {
							_x setDir ((_result getDir _clusterCenter)-90); 
						} else {
							_x setDir (_result getDir _clusterCenter); 
						};
						_x setPos getPos _x;
						[_x, createGroup EAST] call BIS_fnc_spawnCrew;
						_x spawn _spawnedObjectsInitCode;
						if (_validCurator) then {
							_assignedCurator addCuratorEditableObjects [[_x], true];
						};
						
						if (_debug) then {
							private _marker = _x call BIS_fnc_boundingBoxMarker;
							if !(_marker isEqualTo "") then {
								_marker setMarkerColor "ColorRed";
								_markers pushBack _marker;
							};
							systemChat format ["(%1) Vehicle %2 spawned", time, typeOf _x];
						};
						true
					};
					if ( _debug ) then {
						[_markers, 100] spawn FS_fnc_FadeDebugMarkers;
					};
				} else {
					if ( _debug ) then {
						systemChat format ["(%1) Failed to find a place to spawn any vehicles", time];
					};
				};
			};
			
			case DEF_THREAT_BUILDINGS: {
				//-- Spawn buildings
				private _created = [selectRandom _buildingClasses, _result, DEF_GOOK_MANAGER_BUILDINGS_BEST_PLACES, 1, _unitsToHideFrom, _debug] call FS_fnc_TrySpawnObjectBestPlaces;
				if !(_created isEqualTo []) then {
					private _markers = [];
					_created apply 
					{
						_x setDir random 360;
						[_x, _assignedCurator] spawn FS_fnc_OccupyTree;
						_x spawn _spawnedObjectsInitCode;
						if (_debug) then {
							private _marker = _x call BIS_fnc_boundingBoxMarker;
							if !(_marker isEqualTo "") then {
								_marker setMarkerColor "ColorRed";
								_marker setMarkerText (typeOf _x);
								_markers pushBack _marker;
							};
							systemChat format ["(%1) Building %2 spawned", time, typeOf _x];
						};
						true
					};
					if ( _debug ) then {
						[_markers, 100] spawn FS_fnc_FadeDebugMarkers;
					};
				} else {
					if ( _debug ) then {
						systemChat format ["(%1) Failed to find a place to spawn any buildings", time];
					};
				};
			};
			case default {};
		};
		
		waitUntil { sleep 2; scriptDone _handle };
	};
};