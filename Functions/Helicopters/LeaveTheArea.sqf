
_this spawn
{
	params ["_aircraft", ["_debug", false]];

	_group = group _aircraft;

	_pos = _aircraft getPos [500, getDir _aircraft];

	// Set reached_the_area to False to indicate leaving the scouting area
	_aircraft setVariable ["reached_the_area", false];

	[_group, currentWaypoint _group] setWaypointPosition [getPosASL ((units _group) select 0), -1];
	sleep 0.1; // Delay added as per recommendation from https://community.bistudio.com/wiki/deleteWaypoint
	{ deleteWaypoint _x } forEachReversed waypoints _group;

	_NewWP = _group addWaypoint [_pos, 0, 1];
	_NewWP setWaypointType "MOVE";
	_NewWP setWaypointSpeed "NORMAL";	
	_NewWP setWaypointBehaviour "AWARE";	
	_NewWP setWaypointCombatMode "RED";	
	_NewWP setWaypointCompletionRadius 50;

	// When the aircraft reaches the waypoint, reached_the_area will be set to True again
	_NewWP setWaypointStatements ["true", "vehicle this setVariable ['reached_the_area', true, true]; deleteWaypoint [group this, currentWaypoint (group this)]"];

};