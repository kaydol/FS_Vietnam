
#include "..\..\definitions.h"
#include "AmnesiaFrameworkDefinitions.h"

private _keys = [DEF_AMNESIA_FRAMEWORK_LOCAL_GROUPS] call _fnc_getKeys;

private _localGroups = [];

{
	([DEF_AMNESIA_FRAMEWORK_LOCAL_GROUPS, _x] call _fnc_get) params ["_localGrp"];
	
	if !(local _localGrp) then {
		[DEF_AMNESIA_FRAMEWORK_LOCAL_GROUPS, _x] call _fnc_removeKey;
	} else {
		_localGroups pushBackUnique _localGrp;
	};
}
foreach _keys;

_localGroups


