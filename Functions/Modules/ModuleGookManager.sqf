/* ----------------------------------------------------------------------------
Function: FS_GookManager_Module

Description:
	This module spawns gooks around players, sets up ambushes, generally making
	the jungle "alive". Watch out. They're in the trees.
	
Parameters:
    _module - The module logic.
	
Returns:
    Nothing.

Author:
    kaydol
---------------------------------------------------------------------------- */

params ["_logic"];

_spawnProbability = _logic getVariable "spawnProbability";
_sleep = _logic getVariable "sleep";

_fsm = _logic getVariable "fsm";
if (isNil{ _fsm }) then 
{
	_fsm = [_logic, _spawnProbability, _sleep] execFSM "\FS_Vietnam\FSM\GookManager.fsm";
	_logic setVariable ["fsm", _fsm];
};

_logic setVariable ["moduleActive", true];

// Use to stop spawning new Gooks
//_logic setVariable ["moduleActive", false];
