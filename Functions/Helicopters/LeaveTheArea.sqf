
params ["_aircraft", ["_debug", false]];

_group = group _aircraft;

_pos = _aircraft getPos [500, getDir _aircraft];

// Set reached_the_area to False to indicate leaving the scouting area
_aircraft setVariable ["reached_the_area", false];

_NewWP = _group addWaypoint [_pos, 0, 1];
_NewWP setWaypointType "MOVE";
_NewWP setWaypointSpeed "NORMAL";	
_NewWP setWaypointBehaviour "AWARE";	
_NewWP setWaypointCombatMode "RED";	
_NewWP setWaypointCompletionRadius 50;

// When the aircraft reaches the waypoint, reached_the_area will be set to True again
_NewWP setWaypointStatements ["true", "vehicle this setVariable ['reached_the_area', True]; deleteWaypoint [group this, currentWaypoint (group this)]"];


//while { count waypoints _group > 2 } do {
//	deleteWaypoint [_group, 1];
//};
if ( _debug ) then {
	diag_log "Scout is leaving the area now";
};