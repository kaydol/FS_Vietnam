/* ----------------------------------------------------------------------------
Function: FS_fnc_kMeansClustering

Description:
	The implementation of k-means clustering. 
	
	Works slower than agglomerative clustering and the only way to find out if the 
	clusterization was good is to run <FS_fnc_BiggestClusterDiameter>.
	
	If the amount of clusters can is not known beforehand, the only way to clusterize
	points into separated groups is to run clusterization multiple times until the
	biggest cluster fits within given diameter, which is very slow and inefficient. 
	
Parameters:
    _objects - Contains a set of elements to process [Array of positions or objects].
    _numberOfClusters - How many clusters we want to get [Number].
	
Returns:
    Array of arrays, [_clusters_centers, _cluster_sizes, _membership]

Examples:
	(begin example)
	_numberOfClusters = 1;
	_data = [_collection, _numberOfClusters] call FS_fnc_kMeansClustering;
	_biggestCluster = [_collection, _data # 2] call FS_fnc_BiggestClusterDiameter;

	while { _biggestCluster > _maxClusterDiam } do 
	{
		_data = [_collection, _numberOfClusters] call FS_fnc_kMeansClustering;
		_biggestCluster = [_collection, _data # 2] call FS_fnc_BiggestClusterDiameter;
		_numberOfClusters = _numberOfClusters + 1;
	};
	(end)

Author:
    kaydol
---------------------------------------------------------------------------- */

params ["_objects", "_numberOfClusters"];

_N = count _objects;
_K = _numberOfClusters;

_objects = +_objects;

/* If an array of objects is given, change it to an array of positions */
if !(( _objects select 0 ) isEqualType [] ) then {
	for [{_i = 0},{_i < _N},{_i = _i + 1}] do {
		_objects set [_i, getPos (_objects select _i)];
	};
};

/* Creating array with _K clusters */
_cluster_sizes = [];
_clusters_centers = [];
while { count _clusters_centers < _numberOfClusters } do {
	_clusters_centers pushBackUnique ( _objects call BIS_fnc_SelectRandom ); 
};
_clusters_old_centers = +_clusters_centers; // "deep" copying

/* _membership[_i] stores a clusterID which owns _object[_i] */
_membership = [];
_membership set [_N - 1, nil];
for [{_i = 0},{_i < _N},{_i = _i + 1}] do {
	_membership set [_i, 0];
};

while { true } do 
{
	for [{_i = 0},{_i < _N},{_i = _i + 1}] do 
	{
		_mindist = ( _objects select _i ) distance ( _clusters_centers select 0 );
		_owner = 0;
		
		for [{_j = 0},{_j < _K},{_j = _j + 1}] do 
		{
			_distance = ( _objects select _i ) distance ( _clusters_centers select _j );
			if ( _distance < _mindist ) then { _mindist = _distance; _owner = _j; };
		};
		
		if !(( _membership select _i ) isEqualTo _owner ) then { 
			_membership set [_i, _owner];
		};
		
	};
	
	/* Calculating a new center for each cluster */
	for [{_j = 0},{_j < _K},{_j = _j + 1}] do 
	{
		_count = 0; _sumX = 0; _sumY = 0; _sumZ = 0;
		
		for [{_i = 0},{_i < _N},{_i = _i + 1}] do 
		{
			if (( _membership select _i ) isEqualTo _j ) then {
				_sumX = _sumX + ((_objects select _i) select 0); 
				_sumY = _sumY + ((_objects select _i) select 1); 
				_sumZ = if ( count (_objects select _i) > 2 ) then [{ _sumZ + ((_objects select _i) select 2) },{0}];
				_count = _count + 1;
				_cluster_sizes set [_j, _count];
			};
		};
		if ( _count > 0 ) then {
			_new_center = [_sumX / _count, _sumY / _count, _sumZ / _count];
			_clusters_centers set [_j, _new_center];
		};
	};
	
	/* Check if the coordinates of old centers are the same as the new ones */
	if ( _clusters_centers isEqualTo _clusters_old_centers ) exitWith { };
	_clusters_old_centers = +_clusters_centers;
	
};

[_clusters_centers, _cluster_sizes, _membership]
