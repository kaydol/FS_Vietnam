
#define DEF_CUSTOM_WP_NAME "Grab them by the belt!"

params ["_group", "_target", "_debug"];

private _pos = [0,0,0];

if ( _target isEqualTypeParams [0,0,0] ) then {
	_pos = _target;
} else {
	_pos = getPos _target;
};

//_group move _pos;

_group setBehaviourStrong "AWARE";
_group setFormation "LINE";
/*
	"BLUE" : Never fire, keep formation
	"GREEN" : Hold fire, keep formation
	"WHITE" : Hold fire, engage at will/loose formation
	"YELLOW" : Fire at will, keep formation
	"RED" : Fire at will, engage at will/loose formation
*/
_group setCombatMode "GREEN";
/*
	"UNCHANGED" (unchanged)
	"LIMITED" (half speed)
	"NORMAL" (full speed, maintain formation)
	"FULL" (do not wait for any other units in formation)
*/
_group setSpeedMode "FULL";

private _waypoints = waypoints _group;

private _oldWpId = _waypoints findIf {waypointName _x == DEF_CUSTOM_WP_NAME};

if (_oldWpId >= 0) then {
	private _wp = _waypoints select _oldWpId;
	_wp setWPPos _pos;
}
else 
{
	private _wp = _group addWaypoint [_pos, 20, count _waypoints, DEF_CUSTOM_WP_NAME];
	_wp setWaypointType "MOVE";
	
	//_wp setWaypointStatements ["true", "deleteWaypoint [group this, currentWaypoint group this]"];
};

