/*
	This function assigns a FiredNear to a random alive unit
	When the unit dies, the EH is reassigned to someone else
	If the whole group is dead, the function cleans everything and stops
*/

params ["_group", ["_debug", false]];


private _fnc_firedNear = {

	/*
		This code is supposed to force gooks to reveal themselves 
		if they're sneaking on in Stealth mode and then start
		receiving fire (or somebody near them fires their weapon)
	*/

	params ["_unit", "_firer", "_distance", "_weapon", "_muzzle", "_mode", "_ammo", "_gunner"];

	if ( [side _firer, side _unit] call BIS_fnc_SideIsFriendly ) exitWith {
		/* Do not pay attention to friendly fire */
	};

	if ( _distance < 200 ) then {
		_grp = group _unit;
		_grp setVariable ["FiredNearTime", time];
	};

};



private _ehID = -1;

while {{alive _x} count units _group > 0} do 
{
	private _pickNext = selectRandom (( units _group ) select {alive _x} );
	
	_ehID = _pickNext addEventHandler ["FiredNear", _fnc_firedNear];
	
	waitUntil { sleep 10; !alive _pickNext };
	
	if ( !isNull _pickNext ) then {
		_pickNext removeEventHandler ["FiredNear", _ehID];
	};
	
};

