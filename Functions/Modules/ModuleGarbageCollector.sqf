/*
	This module can remove dead bodies, placed traps, and even alive enemies
*/

params ["_module"];

private _removeDead = _module getVariable "removeDead";
private _trapsRemovalDistance = _module getVariable "trapsRemovalDistance";
private _trapsThreshold = _module getVariable "trapsThreshold";
private _gookRemovalDistance = _module getVariable "gookRemovalDistance";
private _removePreplacedUnits = _module getVariable "removePreplaced";
private _debug = _module getVariable "Debug";

if (!_removePreplacedUnits) then {
	{
		if (side _x == EAST && count (units _x arrayIntersect (playableUnits + switchableUnits)) == 0 ) then {
			_x setVariable ["ExcludeGroupFromGarbageCollector", true, true];
		};
	} forEach AllGroups;
	{
		private _vehicle = _x;
		_vehicle setVariable ["ExcludeFromGarbageCollector", true, true];
		{ _x setVariable ["ExcludeFromGarbageCollector", true, true]; } forEach crew _vehicle;
	} forEach vehicles;
};


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
				_body = _x;
				if !(_body getVariable ["ExcludeFromGarbageCollector", false]) then 
				{
					_allPlayers = call BIS_fnc_listPlayers;
					_distances = _allPlayers apply { _x distance _body };
					
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
			systemChat format ["Removed %1 dead bodies", _counter];
		};
	};
	
	
	if ( isNil { FS_AllGookTraps }) then {
		FS_AllGookTraps = [];
	};
	_gookTraps = FS_AllGookTraps + (allSimpleObjects [] select {str _x find 'punji' > 0});
	
	//------------------------------------------------------//
	// 	First remove traps that are too far from players	//
	//------------------------------------------------------//
	private _removedTrapsCounter = 0;
	if ( _trapsRemovalDistance >= 0 ) then {
		{
			_x params ["_mine", "_posAGL", "_orientation"];
			
			if !(isNull _mine) then
			{
				_allPlayers = call BIS_fnc_listPlayers;
				_distances = _allPlayers apply { _x distance _mine };
				
				/* Do not remove mines that are too close to the players */
				if ( selectMin _distances > _trapsRemovalDistance ) then {
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
	
		for [{_i = _trapsThreshold},{ _i < count _gookTraps },{ _i = _i + 1}] do 
		{
			(_gookTraps # _i) params ["_mine", "_posAGL", "_orientation"];
			
			if !(_mine isEqualTo objNull) then 
			{
				deleteVehicle _mine;
				_gookTraps set [_i, objNull]; 
				_removedTrapsCounter = _removedTrapsCounter + 1;
				sleep (1 + random 2);
			};
		};
		
		_gookTraps resize _trapsThreshold;
	};	
	if (_debug && _removedTrapsCounter > 0) then {
		systemChat format ["Removed %1 traps", _counter];
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
			if ( side _x == EAST && count units _x > 0 && !(_x getVariable ["ExcludeGroupFromGarbageCollector", false]) ) then 
			{
				_grp = _x;
				// Find distance between the closest player and the calculated center point of the group
				_allPlayers = call BIS_fnc_listPlayers;
				if !(_allPlayers isEqualTo []) then 
				{
					_center2D = [units _grp] call FS_fnc_CalculateCenter2D;
					_distToPlayers = selectMin ( _allPlayers apply { _x distance2D _center2D } );
					
					// Try to delete entire groups whose distance is beyond _gookRemovalDistance threshold
					if ( _distToPlayers > _gookRemovalDistance ) then 
					{
						_unitPositions = units _grp apply { getPosASL _x };
						_eyePositions = _allPlayers apply { eyePos _x };
						
						_canSee = False;
						
						for [{_i = 0},{_i<count _eyePositions},{_i=_i+1}] do {
							for [{_j = 0},{_j<count _unitPositions},{_j=_j+1}] do {
								_canSee = [objNull, "VIEW"] checkVisibility [_eyePositions # _i , _unitPositions # _j] > 0.3 ;
								if ( _canSee ) exitWith {};
							};
							if ( _canSee ) exitWith {};
						};
						
						// Players don't have a direct LOS with any of the group members
						if !( _canSee ) then {
							if (_debug) then {
								systemChat format ["Deleting a whole group of %1", count units _grp];
							};
							_occupiedVehicles = [];
							{
								if ( vehicle _x == _x ) then {
									// Deleting soldiers on foot
									deleteVehicle _x;
									_counter = _counter + 1;
								} else {
									// Deleting soldiers in vehicles + their vehicles
									_occupiedVehicles pushBackUnique vehicle _x;
									_x remoteExec ["deleteVehicleCrew", vehicle _x]; // delete unit where its vehicle is local
								};
							}
							forEach units _grp;
							{
								deleteVehicle _x;
								_counter = _counter + 1;
							} forEach _occupiedVehicles;
							_grp remoteExec ["deleteGroup", _grp]; // delete group where it's local
						};
					};
				};
				sleep (1 + random 2);
			};
		}
		forEach AllGroups;
		
		if (_debug && _counter > 0) then {
			systemChat format ["Removed %1 strayed Gooks", _counter];
		};
	};
	
	sleep 30;
};

