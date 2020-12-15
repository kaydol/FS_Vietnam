/* ----------------------------------------------------------------------------
Function: FS_fnc_ModuleAirCommand

Description:
	Right now all this really does is running behaviour scripts on the synced helicopters.
	I may or may not expand this module with additional features if I decide to *go deeper*.
	
Synced objects:
    "AIR":	Only sync helicopters, not planes. Can sync many.

Parameters:
    _module - The module with helicopters synced to it. 
	
Returns:
    Nothing.

Author:
    kaydol
---------------------------------------------------------------------------- */

if !(isServer || isDedicated) exitWith {};

params ["_module"];

_assessmentRate = _module getVariable "assessmentRate";
_artilleryThreshold = _module getVariable "artilleryThreshold";
_artilleryCD = _module getVariable "artilleryCooldown";
_napalmThreshold = _module getVariable "napalmThreshold";
_napalmCD = _module getVariable "napalmCooldown";
_ambientRadio = _module getVariable "AmbientRadio";
_debug = _module getVariable "debug";

// Used in FS_fnc_AssignFireTask
SUPPORT_MINDISTANCE_ARTILLERY = _module getVariable "artilleryMinDist"; 
SUPPORT_MINDISTANCE_NAPALM = _module getVariable "napalmMinDist";

// For some reason when using synchronizedObjectsAdd [heli] mid mission, 
// it only syncs it's effective commander, and I need it to sync the actual vehicle  
// So here I sync in 2 steps, first I gather the vehicles of all synced objects, and then
// I do the actual thing on the gathered vehicles

// Step 1. Gather aircrafts of all synced objects
_synced = synchronizedObjects _module; 
_aircrafts = [];
{
	if ( typeOf _x isKindOf "Air" || vehicle _x isKindOf "Air" ) then 
	{ 
		_aircrafts pushBackUnique vehicle _x;
	};
}
forEach _synced;

// Step 2. Run scripts on synced aircrafts
{
	[_x, _assessmentRate, [_artilleryThreshold, _artilleryCD, _napalmThreshold, _napalmCD], objNull, _debug] execFSM "\FS_Vietnam\FSM\Loach.fsm"; 
		
		if ( _ambientRadio ) then {
			[_x, "West", 1] spawn FS_fnc_UnsungRadioPlayback;
		};	
}
forEach _aircrafts;





