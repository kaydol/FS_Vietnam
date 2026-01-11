
#include "..\..\definitions.h"
#include "AmnesiaFrameworkDefinitions.h"

private _keys = [DEF_AMNESIA_FRAMEWORK_TARGETS_TO_FORGET] call _fnc_getKeys;

private _targets = [];

{
	([DEF_AMNESIA_FRAMEWORK_TARGETS_TO_FORGET, _x] call _fnc_get) params ["_target"];
	
	if !(alive _target) then {
		[DEF_AMNESIA_FRAMEWORK_TARGETS_TO_FORGET, _x] call _fnc_removeKey;
	} else {
		_targets pushBackUnique _target;
	};
}
foreach _keys;

_targets

