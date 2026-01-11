
#include "..\..\definitions.h"
#include "AmnesiaFrameworkDefinitions.h"

params ["_localUnitOrGroup"];

private _group = grpNull;

if !(_localUnitOrGroup isEqualType grpNull) then {
	_group = group _localUnitOrGroup;
} else {
	_group = _localUnitOrGroup;
};

if (_group isEqualTo grpNull) exitWith {
	//-- function was called on an empty vehicle when the group wasn't created yet
	//-- wait until the group is not null (vehicle has units in it) 
	_this spawn {
		params ["_localUnitOrGroup"];
		//systemChat "Waiting for group to not be null";
		waitUntil { sleep 1; group _localUnitOrGroup != grpNull };
		_localUnitOrGroup spawn FS_fnc_AmnesiaAddLocalGroup;
		//systemChat "Group is now not null";
	};
};

private _uniqueId = missionNameSpace getVariable [DEF_AMNESIA_FRAMEWORK_UNIQUE_ID_VAR, 0];
missionNameSpace setVariable [DEF_AMNESIA_FRAMEWORK_UNIQUE_ID_VAR, _uniqueId + 1];

[DEF_AMNESIA_FRAMEWORK_LOCAL_GROUPS, _uniqueId, _group] call _fnc_set;

