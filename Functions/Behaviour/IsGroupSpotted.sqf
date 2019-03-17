
params ["_group"];

/* The whole group is dead... Dear God, may them rest in peace */
if ({alive _x} count units _group <= 0) exitWith { True }; 

_firedNearTime = _group getVariable ["FiredNearTime", 0];
if ( _firedNearTime isEqualTo 0 ) exitWith { False };
if ( time - _firedNearTime < 10 ) exitWith { True };

_ourSide = side _group; 
_otherSides = [EAST, WEST, INDEPENDENT] - [_ourSide];
_enemies = _otherSides select { [_x, _ourSide] call BIS_fnc_sideIsEnemy };

_knowledges = [];
{
	_enemySide = _x;
	_sideKnowledge = selectMax ( units _group apply { _enemySide knowsAbout _x } );
	_knowledges pushBack _sideKnowledge;
}
forEach _otherSides;

_maxKnowledge = selectMax _knowledges;

_maxKnowledge >= 2

