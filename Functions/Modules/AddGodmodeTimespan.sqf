
/*
	This is a function to be used in pair with the Godmode Synchronizer Module.
	
	Refer to the module function for more info.
	
	Author: kaydol 
*/

#include "GodmodeSynchronizerDefinitions.h"

private _fnc_set = {
	
	params ["_varname", "_key", "_dataToStore", ["_insertOnly", false]];

	if (isNil{ missionNameSpace getVariable _varname }) then {
		missionNameSpace setVariable [_varname, createHashMap];
	};

	private _hashMap = missionNameSpace getVariable _varname;

	_hashMap set [_key, _dataToStore, _insertOnly];
};


params ["_affectedObject", "_godmodeLength", ["_debug", false]];

private _uniqueId = missionNameSpace getVariable [DEF_GODMODE_COUNTER, 0];
missionNameSpace setVariable [DEF_GODMODE_COUNTER, _uniqueId + 1];

[DEF_GODMODE_TIMESPANS, _uniqueId, [_affectedObject, time + _godmodeLength]] call _fnc_set;

if (_debug) then 
{
	if (clientOwner != owner _affectedObject) then 
	{
		diag_log format ["(ModuleGodModeSynchronizer @ %1) ERROR: Received call to give godmode to %2, but its owner is %3!", clientOwner, _affectedObject, owner _affectedObject];
	}
	else 
	{
		diag_log format ["(ModuleGodModeSynchronizer @ %1) Received call to give godmode to %2", clientOwner, _affectedObject];
	};
};

if ((allMissionObjects "Logic") findIf { typeOf _x == "FS_GodmodeSynchronizer_Module" } < 0) then {
	["Godmode Synchronizer Module is required for this to work properly"] call BIS_fnc_error;
	diag_log format ["(ModuleGodModeSynchronizer @ %1) ERROR: Godmode Synchronizer Module is required for this to work properly", clientOwner];
};


