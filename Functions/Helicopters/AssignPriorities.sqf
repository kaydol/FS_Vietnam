
params ["_side", "_clusters_centers", "_cluster_sizes", "_collection", "_membership", "_config", ["_debug", True]];

_config params [["_overrunMultiplier", 0], ["_stationAlreadyTakenPenalty", 0], ["_distressPriority", 0]];
// how much importance to add to a cluster if it's being overrun (more enemies than friendlies in the vicinity)
// how much priority to subtract from a station that already has at least one other scout assigned to it
// how much importance to add to clusters that directly stated their distress (can only be one by players)

/* Initialization */
_priorities = [];
_priorities resize count _clusters_centers;
_priorities = _priorities apply {0};

_maxKnownEnemiesPerCluster = [];
_maxKnownEnemiesPerCluster resize count _clusters_centers;
_maxKnownEnemiesPerCluster = _maxKnownEnemiesPerCluster apply {0};


/* Work */
for [{_i = 0},{_i < count _collection},{_i = _i + 1}] do 
{
	_obj = _collection # _i;
	
	/* Adding distress priority : multiple distresses don't stack */
	if !( _distressPriority isEqualTo 0 ) then 
	{
		if ( _obj getVariable ["DISTRESSED", False] ) then {
			_priorities set [_membership # _i, _distressPriority];
		};
	};
	
	/* Finding the biggest estimated size of the enemy group around each cluster */
	_enemiesAround = ( _obj getVariable ["KNOWN_ENEMIES_AROUND", 0] ) max ( _maxKnownEnemiesPerCluster # ( _membership # _i ) );
	_maxKnownEnemiesPerCluster set [_membership # _i, _enemiesAround]; 
}; 


/* 	
	Adding additional priorities to those in danger of being overrun; 
	Adding cluster's size to its priority
*/
for [{_i = 0},{_i < count _cluster_sizes},{_i = _i + 1}] do {
	_overrunCoef = _overrunMultiplier * ( _maxKnownEnemiesPerCluster # _i / _cluster_sizes # _i );
	_p = _cluster_sizes # _i + _priorities # _i + _overrunCoef;
	_priorities set [_i, _p];
};


/* Substracting prioritites from clusters that already have air units on station */
if !( _stationAlreadyTakenPenalty isEqualTo 0 ) then {
	for [{_i = 0},{_i < count _clusters_centers},{_i = _i + 1}] do {
		if ( [_side, _clusters_centers # _i] call FS_fnc_IsStationTaken ) then {
			_p = _priorities # _i + _stationAlreadyTakenPenalty;
			_priorities set [_i, _p];
		};
	};
};

if ( _debug ) then {
	_markers = [];
	// create markers on every cluster
	for [{_i = 0},{_i < count _clusters_centers},{_i = _i + 1}] do {
		_pos = _clusters_centers select _i;
		_marker = createMarkerLocal [str(round random(1000000)), _pos];
		_marker setMarkerTypeLocal "mil_dot";
		_marker setMarkerColor "ColorBlue";
		_marker setMarkerText str (_priorities # _i);
		_markers pushBack _marker;
	};
	// gradually increase transparency
	[_markers] spawn {
		params ["_markers"];
		_lifetime = 30;
		for [{_i = 0},{_i < _lifetime},{_i = _i + _lifetime / 10}] do {
			sleep (_lifetime / 10);
			{
				_x setMarkerAlphaLocal linearConversion [0, _lifetime, _i, 1, 0];
			} forEach _markers;
		};
		{ deleteMarker _x } forEach _markers;
	};
};

_priorities 