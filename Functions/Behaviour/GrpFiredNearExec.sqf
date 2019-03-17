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