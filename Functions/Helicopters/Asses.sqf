
#define DEF_NAPALM_STRIKE_LENGTH 150


params ["_aircraft", "_assessmentRate", "_supportParams", ["_debug", false, [true]]];

private _side = _aircraft getVariable ["initSide", side _aircraft];

private _taskAssigned = False;

private _friendlyUnits = [_side, "FRIENDLY_UNITS", _assessmentRate, [_aircraft], "FS_fnc_GetFriendlyUnits"] call FS_fnc_SnapshotWrapper;
private _hostileUnits = [_side, "HOSTILE_UNITS", _assessmentRate, [_aircraft], "FS_fnc_GetHostileUnits"] call FS_fnc_SnapshotWrapper;

if ( count _hostileUnits == 0 ) exitWith { /* All clear */ _taskAssigned };

/* Clusterizing the enemies */
private _hostileClusters = [_side, "HOSTILE_CLUSTERS", _assessmentRate, [_hostileUnits, 70, [], _debug], "FS_fnc_Clusterize"] call FS_fnc_SnapshotWrapper;
_hostileClusters params ["_clusters_centers", "_cluster_sizes", "_membership"];


/*	NOTE:
	_clusters_centers & _cluster_sizes share the same index, meaning the elements with the same index are related.
	_hostileUnits & _membership are related by index too.
*/

// Mark clusters that are too close to friendlies as empty
if ( count _friendlyUnits > 0 ) then {
	for [{_i = 0},{_i < count _clusters_centers},{_i = _i + 1}] do {
		private _distance = [_friendlyUnits, [_clusters_centers select _i]] call FS_fnc_DistanceBetweenArrays;
		if ( _distance < 40 ) then { _cluster_sizes set [_i, 0] };
	};
};


// try to select 2 near located clusters to hit them with a single line of bombs
// orientating the line of strike to hit maximum amount of targets
private _estimatedFACvictims = 0;
private _bestLineForFAC = [];

for [{_i = 0},{_i < count _clusters_centers},{_i = _i + 1}] do {
	private _pos1 = _clusters_centers select _i;
	private _size1 = _cluster_sizes select _i;
	for [{_j = 0},{_j < count _clusters_centers},{_j = _j + 1}] do {
		private _pos2 = _clusters_centers select _j;
		private _size2 = _cluster_sizes select _j;
		// finding cluster combo with the most victims 
		if (_i != _j && _size1 > 0 && _size2 > 0 && _size1 + _size2 > _estimatedFACvictims && _pos1 distance _pos2 < DEF_NAPALM_STRIKE_LENGTH) then 
		{
			_bestLineForFAC = [_pos1, _pos2];
			_estimatedFACvictims = _size1 + _size2;
		};
	};
};

// Best line for FAC is treated like a separated cluster further along
if !( _bestLineForFAC isEqualTo [] ) then 
{
	_clusters_centers pushBack _bestLineForFAC;
	_cluster_sizes pushBack _estimatedFACvictims;
};


/*
	Now after we formed an array of potential targets, it is time to select a single target that will be fired upon
	
	The procedure is as follows:
		1) Take the biggest target
		2) Try to assign a fire task 
		3) If none was assigned, choose next biggest target and try again
		
	The fire task may not be assigned due to unavailability of support or proximity to the friendlies.
*/

private _i = 0;

while { ! _taskAssigned && _i < count _clusters_centers} do 
{
	private _size = selectMax _cluster_sizes;
	private _biggestId = _cluster_sizes findIf { _x == _size };
	_cluster_sizes set [_biggestId, 0]; // mark the cluster empty to exclude it from next checks
	
	private _coordinates = _clusters_centers select _biggestId;
	private _dbaInput = _coordinates;
	if ( _coordinates isEqualTypeAll 0 ) then { _dbaInput = [_coordinates] }; // if only 1 pos is given, wrap it into an array 
	private _proximity = [_friendlyUnits, _dbaInput, True] call FS_fnc_DistanceBetweenArrays;
	private _closestFriend = (_proximity select 1) select 0;
	
	_taskAssigned = [_aircraft, _coordinates, _size, _supportParams, _closestFriend, _debug] call FS_fnc_AssignFireTask;
	
	_i = _i + 1;
};


/* Debug */
if ( _debug ) then {
	private _arrows = [];
	// draw arrows on proposed FAC strikes
	for [{_i = 0},{_i < count _clusters_centers},{_i = _i + 1}] do {
		private _pos = _clusters_centers select _i;
		if ( _pos isEqualTypeAll [] ) then 
		{
			private _arrow = [_pos select 0, _pos select 1, [1,0,0,1], [3,1/5,3]] call BIS_fnc_drawArrow;
			_arrows pushBack _arrow;
		};
	};
	// delete arrows after _lifetime
	_arrows spawn {
		private _lifetime = 30;
		sleep _lifetime;
		{ _x call BIS_fnc_drawArrow } forEach _this;
	};
};

_taskAssigned
