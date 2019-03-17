
params ["_side", "_pos", ["_precision", 50]];

/*
	Checks whether given side has an airstation in a 
	circle with radius _precision and center at _pos 
*/

_airstations = [];
call compile format ["
	if ( isNil { %1_AIRSTATIONS } ) then { %1_AIRSTATIONS = [] }; 
	_airstations = %1_AIRSTATIONS;
", _side];

_hasStation = False;

{
	if ( _x # 1 distance _pos < _precision ) exitWith { _hasStation = True; };
}
forEach _airstations;

_hasStation 