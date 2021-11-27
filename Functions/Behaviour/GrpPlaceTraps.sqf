
#include "..\..\definitions.h"

params ["_group"];

/* The whole group is dead... Dear God, may them rest in peace */
if ({alive _x} count units _group <= 0) exitWith { }; 

/* 
	First, see if the group has any traps 
*/

_tripwires = getArray (configFile >> "CfgWeapons" >> "Put" >> DEF_PUT_MUZZLE_WIREMINE >> "magazines");
_punjis = getArray (configFile >> "CfgWeapons" >> "Put" >> DEF_PUT_MUZZLE_PUNJI >> "magazines");
_traps = _tripwires + _punjis;

_hasTraps = {
	params ["_unit", "_traps"];
	count ( magazines _unit arrayIntersect _traps ) > 0
};

_sappers = units _group select { [_x, _traps] call _hasTraps && !isPlayer _x }; // Exclude players from sappers who receive orders
if ( _sappers isEqualTo [] ) exitWith { /* No explosives */ };

/*
	Now, select a leader or a random alive unit and then 
	use his position as a center when looking for best places 
*/

_leader = leader _group;
if ( isNull _leader ) then { _leader = selectRandom (units _group select {alive _x}) };
_places = selectBestPlaces [position _leader, 50, "(forest + 2*trees) * (1-houses) * (1-sea)", 1, 20];


// Hold position
{ doStop _x } forEach units _group;

// Order sappers to place mines
while { count _places > 0 && count _sappers > 0 } do 
{
	// Assign tasks to sappers
	{
		if ( count _places == 0 ) exitWith { };
		
		_pop = ( _places # (count _places - 1) ) # 0;
		_places resize (count _places - 1);
		
		[_x, _pop] spawn 
		{
			params ["_sap", "_dest"];
			
			[_sap] doMove _dest;

			waitUntil { moveToCompleted _sap || moveToFailed _sap };
			
			if ( moveToCompleted _sap ) then {
				_sap call FS_fnc_PlaceTrap;
			};
		};
	} 
	forEach _sappers;
	
	waitUntil { sleep 0.5; [_sappers] call FS_fnc_UnitsReady };
	
	// Remove sappers who don't have any traps left
	{
		if !([_x, _traps] call _hasTraps) then {
			_sappers set [_forEachIndex, objNull];
		};
	} forEach _sappers;
	_sappers = _sappers arrayIntersect _sappers;
};


// Resume formation
if !( isNull leader _group ) then {
	{ _x doFollow leader _group } forEach units _group;
};

