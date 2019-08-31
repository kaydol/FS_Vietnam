/*
	This module can remove dead bodies, placed traps, and even alive enemies
*/

#define TRAPS_REMOVAL_DISTANCE 300 

params ["_module"];

_removeDead = _module getVariable "removeDead";
_removeTraps = _module getVariable "removeTraps";
_trapsThreshold = _module getVariable "trapsThreshold";
_removeGooks = _module getVariable "removeGooks";

while { true } do 
{
	//----------------------//
	// 	Remove dead bodies	//
	//----------------------//
	
	if ( _removeDead ) then
	{
		{
			if !(isNull _x) then 
			{
				_body = _x;
				_allPlayers = call BIS_fnc_listPlayers;
				_distances = _allPlayers apply { _x distance _body };
				
				/* Do not remove bodies that are too close to the players */
				if ( selectMin _distances > 10 ) then {
					deleteVehicle _body;
				};
				
				sleep (1 + random 2);
			};
		} forEach AllDead;
	};
	
	
	if ( isNil { FS_AllGookTraps }) then {
		FS_AllGookTraps = [];
	};
	_gookTraps = FS_AllGookTraps;
	
	//------------------------------------------------------//
	// 	First remove traps that are too far from players	//
	//------------------------------------------------------//
	
	if ( _removeTraps ) then {
		{
			_x params ["_mine", "_posAGL", "_orientation"];
			
			if !(isNull _mine) then
			{
				_allPlayers = call BIS_fnc_listPlayers;
				_distances = _allPlayers apply { _x distance _mine };
				
				/* Do not remove mines that are too close to the players */
				if ( selectMin _distances > TRAPS_REMOVAL_DISTANCE ) then {
					deleteVehicle _mine;
					_gookTraps set [_forEachIndex, objNull];
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
			
			if !(isNull _mine) then 
			{
				deleteVehicle _mine;
				_gookTraps set [_i, objNull]; 
				
				sleep (1 + random 2);
			};
		};
		
		_gookTraps resize _trapsThreshold;
	};
	
	_gookTraps = _gookTraps arrayIntersect _gookTraps; // to get rid of objNulls
	publicVariable "FS_AllGookTraps";
	
	//--------------------------//
	// 	Remove strayed Gooks	//
	//--------------------------//
	
	if ( _removeGooks > 0 ) then {
		{
			if ( side _x == EAST && count units _x > 0 ) then 
			{
				_grp = _x;
				_allPlayers = call BIS_fnc_listPlayers;
				_center2D = [units _grp] call FS_fnc_CalculateCenter2D;
				_distToPlayers = selectMin ( _allPlayers apply { _x distance2D _center2D } );
				
				// Try to delete Gooks that are too far away
				if ( _distToPlayers > _removeGooks ) then 
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
						{
							if ( vehicle _x == _x ) then {
								deleteVehicle _x;
							} else {
								_x remoteExec ["deleteVehicleCrew", vehicle _x]; // delete unit where its vehicle is local
							};
						}
						forEach units _grp;
						_grp remoteExec ["deleteGroup", _grp]; // delete group where it's local
					};
				};
				
				sleep (1 + random 2);
			};
		} 
		forEach AllGroups;
	};
	
	
	sleep 60;
};

