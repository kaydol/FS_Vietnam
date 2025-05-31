
params ["_aircraft", "_target", "_debug"];

/*
	First, updating the stations to indicate that this aircraft
	is taking a new station
*/
private _side = _aircraft getVariable ["initSide", side _aircraft];
[_side, "AIRSTATIONS", [_aircraft, _target]] call FS_fnc_UpdateSideVariable;

private _distance = 200;
private _distance_step = 0;
private _waypoints = 2;
private _group = group _aircraft;

private _dir = [(getDir _aircraft) + ([_aircraft, _target] call BIS_fnc_relativeDirTo)] call FS_fnc_DirectionWrapper; 
private _next_dir = 0;
private _pos = [];

{ deleteWaypoint _x } forEachReversed waypoints _group;

for[{_i = 0},{_i <= _waypoints},{_i = _i + 1}] do 
{
	_next_dir = [_dir + _i * 360/_waypoints] call FS_fnc_DirectionWrapper;
	_pos = _target getPos [_distance, _next_dir];
	_distance = _distance + _distance_step;
	
	private _NewWP = _group addWaypoint [_pos, 0];
	_NewWP setWaypointType "MOVE";
	_NewWP setWaypointSpeed "NORMAL";	
	_NewWP setWaypointBehaviour "AWARE";	
	_NewWP setWaypointCombatMode "RED";	
	_NewWP setWaypointCompletionRadius 200;
	_NewWP setWaypointStatements ["true", "vehicle this setVariable ['reached_the_area', true]; deleteWaypoint [group this, currentWaypoint (group this)]"];
	
};

/* Fake waypoint to force AI to not drop speed */
_pos = _pos getPos [_distance, [_dir + 360/_waypoints] call FS_fnc_DirectionWrapper];

private _NewWP = _group addWaypoint [_pos, 0];
_NewWP setWaypointSpeed "NORMAL";	
_NewWP setWaypointBehaviour "AWARE";	
_NewWP setWaypointCombatMode "RED";
_NewWP setWaypointCompletionRadius 150;
_NewWP setWaypointStatements ["true", "deleteWaypoint [group this, currentWaypoint (group this)]"];
