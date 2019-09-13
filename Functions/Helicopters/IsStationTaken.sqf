
params ["_side", "_pos", ["_precision", 50], ["_verbose", false]];

/*
	Checks whether given side has an airstation in a 
	circle with radius _precision and center at _pos 
*/

private _airstations = [];
call compile format ["
	if ( isNil { %1_AIRSTATIONS } ) then { %1_AIRSTATIONS = [] }; 
	_airstations = %1_AIRSTATIONS;
", _side];

private _stationTaken = False;
private _key = -1;

{
	if ( _x # 1 distance2D _pos < _precision ) exitWith { 
		_stationTaken = True; 
		_key = _x # 0; 
	};
}
forEach _airstations;

if ( _verbose ) exitWith { [_stationTaken, _key] };

_stationTaken 