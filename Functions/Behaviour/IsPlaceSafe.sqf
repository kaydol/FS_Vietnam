
params ["_group"];

/* The whole group is dead... Dear God, may them rest in peace */
if ({alive _x} count units _group <= 0) exitWith { False }; 

_leader = leader _group;
if ( isNull _leader ) then { _leader = selectRandom (units _group select {alive _x}) };


_expr = "(forest + 2*trees) * (1-houses) * (1-sea)"; // 3 is the maximum for this expr
_current = (selectBestPlaces [position _leader, 10, _expr, 0.1, 1]) # 0;
if ( _current # 1 >= 3 ) exitWith 
{ 
	True
};

False 