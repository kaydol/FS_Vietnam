/* ----------------------------------------------------------------------------
Function: FS_fnc_ModuleAirCommand

Description:
	Right now all this really does is running behaviour scripts on the synced helicopters.
	I may or may not expand this module with additional features if I decide to *go deeper*.
	
Synced objects:
    Helicopters:	Only sync helicopters, not planes. Can sync many.
	Triggers:		(OPTIONAL) You can activate the module with triggers.

Parameters:
    _module - The module with helicopters synced to it. 
	
Returns:
    Nothing.

Author:
    kaydol
---------------------------------------------------------------------------- */

if !(isServer) exitWith {};

params ["_module", ["_units", []], ["_activated", false]];

if !(_activated) exitWith {};

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
	private _fsmInProgress = false;
	
	if (!isNil{_x getVariable "AirCommandFSMHandle"}) then {
		_fsmInProgress = !completedFSM (_x getVariable "AirCommandFSMHandle");
	};
	
	if !(_fsmInProgress) then 
	{
		private _fsmHandle = [_x, _assessmentRate, [_artilleryThreshold, _artilleryCD, _napalmThreshold, _napalmCD], objNull, _debug] execFSM "\FS_Vietnam\FSM\Loach.fsm";
		
		_x setVariable ["AirCommandFSMHandle", _fsmHandle, true];
	};
}
forEach _aircrafts;





