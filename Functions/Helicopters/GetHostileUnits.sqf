
params ["_aircraft", "_assessmentRate"];

/*
Absolutely Wallhack-erish
_enemies = effectiveCommander _aircraft targets [True, 0, [], 300];
_enemies select { _x isKindOf "LAND" }
*/

_side = _aircraft getVariable ["initSide", side _aircraft];

_targets = effectiveCommander _aircraft targetsQuery [objNull, sideUnknown, "", [], 120];
_enemies = [];

{
	_x params ["_accuracy", "_target", "_targetSide", "_targetType", "_targetPosition", "_targetAge"];
	_isEnemy = (side _target == sideUnknown) || [_side, _targetSide] call BIS_fnc_sideIsEnemy;
	
	if ( _isEnemy && _target isKindOf "Land" ) then {
		_enemies pushBack _targetPosition;
	};
}
forEach _targets;

_enemies

