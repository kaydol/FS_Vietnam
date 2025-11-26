
params ["_aircraft", "_assessmentRate"];

/*
Absolutely Wallhack-erish
_enemies = effectiveCommander _aircraft targets [True, 0, [], 300];
_enemies select { _x isKindOf "LAND" }
*/

private _side = _aircraft getVariable ["initSide", side _aircraft];

private _targets = effectiveCommander _aircraft targetsQuery [objNull, sideUnknown, "", [], 120];
private _enemies = [];
private _positions = [];

{
	_x params ["_accuracy", "_target", "_targetSide", "_targetType", "_targetPosition", "_targetAge"];
	_isEnemy = (side _target == sideUnknown) || [_side, _targetSide] call BIS_fnc_sideIsEnemy;
	
	if ( _isEnemy && _target isKindOf "Land" && !(isObjectHidden _target) ) then {
		_enemies pushBack _target;
		_positions pushBack _targetPosition;
	};
}
forEach _targets;

[_enemies, _positions]

