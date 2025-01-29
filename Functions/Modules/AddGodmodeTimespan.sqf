
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


params ["_affectedObject", "_godmodeLength"];

// Idk if diag_frameNo is good enough of a key to eliminate the possibility of collisions. Probably not.
[DEF_GODMODE_TIMESPANS, diag_frameNo, [_affectedObject, time + _godmodeLength]] call _fnc_set;

if ((allMissionObjects "Logic") findIf { typeOf _x == "FS_GodmodeSynchronizer_Module" } < 0) then {
	["Godmode Synchronizer Module is required for this to work properly"] call BIS_fnc_error;
};


