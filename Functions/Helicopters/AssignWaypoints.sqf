
params ["_aircraft", "_target", "_debug"];

if (_debug) then {
	diag_log 'Loach: Search pattern started';
};

/*
	First, updating the stations to indicate that this aircraft
	is taking a new station
*/
_side = _aircraft getVariable ["initSide", side _aircraft];
[_side, "AIRSTATIONS", [_aircraft, _target]] call FS_fnc_UpdateSideVariable;

_distance = 100;
_distance_step = 0;
_waypoints = 2;
_group = group _aircraft;
_group allowFleeing 1;
_quit_cone = 0;

_dir = [(getDir _aircraft) + ([_aircraft, _target] call BIS_fnc_relativeDirTo)] call FS_fnc_DirectionWrapper; 
_next_dir = 0;
_pos = [];

for[{_i = 0},{_i <= _waypoints},{_i = _i + 1}] do 
{
	_next_dir = [_dir + _i * 360/_waypoints] call FS_fnc_DirectionWrapper;
	_pos = _target getPos [_distance, _next_dir];
	_distance = _distance + _distance_step;
	
	_NewWP = _group addWaypoint [_pos, 0];
	_NewWP setWaypointType "MOVE";
	_NewWP setWaypointSpeed "NORMAL";	
	_NewWP setWaypointBehaviour "AWARE";	
	_NewWP setWaypointCombatMode "RED";	
	_NewWP setWaypointCompletionRadius 100;
	_NewWP setWaypointStatements ["true", "vehicle this setVariable ['reached_the_area', true]; deleteWaypoint [group this, currentWaypoint (group this)]"];
	
};

/* Fake waypoint to force AI not to drop speed */
_pos = _pos getPos [_distance, [_dir + 360/_waypoints] call FS_fnc_DirectionWrapper];

_NewWP = _group addWaypoint [_pos, 0];
_NewWP setWaypointSpeed "NORMAL";	
_NewWP setWaypointBehaviour "AWARE";	
_NewWP setWaypointCombatMode "RED";
_NewWP setWaypointCompletionRadius 100;
_NewWP setWaypointStatements ["true", "deleteWaypoint [group this, currentWaypoint (group this)]"];
