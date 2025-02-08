
params ["_group", ["_debug", false]];

/* The whole group is dead... Dear God, may them rest in peace */
if ({alive _x} count units _group <= 0) exitWith { True }; 

private _firedNearTime = _group getVariable ["FiredNearTime", 0];
if ( _firedNearTime isEqualTo 0 ) exitWith { False };
if ( time - _firedNearTime < 10 ) exitWith { True };

private _ourSide = side _group; 
private _otherSides = [EAST, WEST, INDEPENDENT] - [_ourSide];
private _enemies = _otherSides select { [_x, _ourSide] call BIS_fnc_sideIsEnemy };

private _knowledges = [];
{
	private _enemySide = _x;
	private _sideKnowledge = selectMax ( units _group apply { _enemySide knowsAbout _x } );
	_knowledges pushBack _sideKnowledge;
}
forEach _otherSides;

private _maxKnowledge = selectMax _knowledges;

_maxKnowledge >= 2

