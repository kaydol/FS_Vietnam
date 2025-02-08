
/*
	Selects a random alive group member and returns 
	a position of the most dangerous enemy, if any. 
	Returns [] if no known enemies.
	Ignores flying units with kindOf "AIR".
*/

params ["_group", ["_radius", 300], ["_debug", false]];

/* The whole group is dead... Dear God, may them rest in peace */
if ({alive _x} count units _group <= 0) exitWith { [] }; 

private _rndAlive = selectRandom ( units _group select { alive _x } );

private _targets = _rndAlive nearTargets _radius;
_targets = _targets select { _x # 1 isKindOf "Land" && _x # 5 < 20 && [_x # 2, side _group] call BIS_fnc_SideIsEnemy };

private _maxCost = 0;
private _id = -1;
{
	if ( _x # 3 > _maxCost ) then {
		_maxCost = _x # 3;
		_id = _forEachIndex;
	};
} 
forEach _targets;

if ( _targets isEqualTo [] ) exitWith { 
	[] 
};

( _targets # _id ) # 0
