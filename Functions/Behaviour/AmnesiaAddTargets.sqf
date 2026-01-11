
#include "..\..\definitions.h"
#include "AmnesiaFrameworkDefinitions.h"

params ["_targets"];

{
	private _thisTarget = _x;
	
	private _uniqueId = missionNameSpace getVariable [DEF_AMNESIA_FRAMEWORK_UNIQUE_ID_VAR, 0];
	missionNameSpace setVariable [DEF_AMNESIA_FRAMEWORK_UNIQUE_ID_VAR, _uniqueId + 1];

	[DEF_AMNESIA_FRAMEWORK_TARGETS_TO_FORGET, _uniqueId, _thisTarget] call _fnc_set;

} forEach _targets;
