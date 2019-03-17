
params ["_group"];

/* The whole group is dead... Dear God, may them rest in peace */
if ({alive _x} count units _group <= 0) exitWith { }; 

/*
	Select a leader or a random alive unit and then 
	use his position as a center when looking for best places 
*/



_leader = leader _group;
if ( isNull _leader ) then { _leader = selectRandom (units _group select {alive _x}) };


_expr = "(forest + 2*trees) * (1-houses) * (1-sea)"; // 3 is the maximum for this expr
_places = selectBestPlaces [position _leader, 250, _expr, 1, 1];
_group move (_places # 0) # 0;

