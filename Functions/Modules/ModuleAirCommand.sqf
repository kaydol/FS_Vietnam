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
_debug = _module getVariable "debug";

// Used in FS_fnc_AssignFireTask
SUPPORT_MINDISTANCE_ARTILLERY = _module getVariable "artilleryMinDist"; 
SUPPORT_MINDISTANCE_NAPALM = _module getVariable "napalmMinDist";

_synced = synchronizedObjects _module; 

{
	if ( typeOf _x isKindOf "Air" ) then { 
		[_x, _assessmentRate, [_artilleryThreshold, _artilleryCD, _napalmThreshold, _napalmCD], objNull, _debug] execFSM "\FS_Vietnam\FSM\Loach.fsm"; 
	};
}
forEach _synced;
