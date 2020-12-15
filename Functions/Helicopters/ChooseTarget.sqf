params ["_aircraft", "_prevTarget", "_debug"];

if !(local _aircraft) exitWith {
	_this remoteExec ["FS_fnc_ChooseTarget", _aircraft];
};
// Now we can guarantee the aircraft is a local unit

/*
	First, updating the stations to indicate that this aircraft
	has finished working on its station and seeks a new target
*/
_side = _aircraft getVariable ["initSide", side _aircraft];
[_side, "AIRSTATIONS", _aircraft] call FS_fnc_UpdateSideVariable;


/*  
	Trying to get variable from a snapshot;
	If this data was calculated recently, we will use the old value 
	(snapshot) instead of doing another calculation-heavy clustering.
	
	If it wasn't, the function will calculate, update and return a new snapshot
*/

_friendlyUnits = [_side, "FRIENDLY_UNITS", 30, [_aircraft], "FS_fnc_GetFriendlyUnits"] call FS_fnc_SnapshotWrapper;

if ( _friendlyUnits isEqualTo [] ) exitWith { 
	/* There are no friendly groups, the group of the aircraft is alone */ 
	objNull 
};

_friendlyClusters = [_side, "FRIENDLY_CLUSTERS", 30, [_friendlyUnits, 100, [], _debug], "FS_fnc_Clusterize"] call FS_fnc_SnapshotWrapper;
_friendlyClusters params ["_clusters_centers", "_cluster_sizes", "_membership"];

if (count _membership != count _friendlyUnits) then {
	// clusterization we pulled from snapshot was done for a different amount of friendly units
	// updating both snapshots with new values
	if (_debug) then {
		diag_log "ChooseTarget.sqf: Snapshots for FRIENDLY_UNITS, FRIENDLY_CLUSTERS are out of sync. Recalculating";
	};
	_friendlyUnits = [_side, "FRIENDLY_UNITS", 0, [_aircraft], "FS_fnc_GetFriendlyUnits"] call FS_fnc_SnapshotWrapper;
	_friendlyClusters = [_side, "FRIENDLY_CLUSTERS", 0, [_friendlyUnits, 100, [], _debug], "FS_fnc_Clusterize"] call FS_fnc_SnapshotWrapper;
	_clusters_centers = _friendlyClusters # 0; 
	_cluster_sizes = _friendlyClusters # 1; 
	_membership = _friendlyClusters # 2; 
};

_priorities = [_side, _clusters_centers, _cluster_sizes, _friendlyUnits, _membership, [50, -50, 100], _debug] call FS_fnc_AssignPriorities;
_newTarget = _clusters_centers # ( _priorities find (selectMax _priorities) );

_newTarget 