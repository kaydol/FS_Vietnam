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
_ailimit = _logic getVariable "ailimit";
_groupSize = _logic getVariable "groupSize";
_groupsCount = _logic getVariable "groupsCount";
_debug = _logic getVariable "debug";

_fsm = _logic getVariable "fsm";
if (isNil{ _fsm }) then 
{
	_fsm = [_logic, _spawnProbability, _sleep, _ailimit, _groupSize, _groupsCount, _debug] execFSM "\FS_Vietnam\FSM\GookManager.fsm";
	_logic setVariable ["fsm", _fsm];
};

// Use to stop spawning new Gooks
//_fsm setFSMVariable ["_moduleActive", false];
