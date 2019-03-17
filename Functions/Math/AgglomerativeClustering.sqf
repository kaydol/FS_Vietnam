/* ----------------------------------------------------------------------------
Function: FS_fnc_AgglomerativeClustering

Description:
	The implementation of agglomerative clustering. 
	Works faster than k-Means and supports the usage of precalculated data.
	
Parameters:
    _collection - Contains a set of elements to process [Array of positions or objects].
    _distance - The element is absorbed by the cluster if the distance between the center of the cluster and the element is less than this [Number].
    _precalculatedClusters - (Optional) If the clusterization of some of the data was already done before, it can be used to speed up the clusterization of new elements [Array of [_clusterCenter, _belongingElements]].
	
	
Returns:
    Array of [_clusterCenter, _belongingElements]

Examples:
   (begin example)
   _collection1 = [_unit1, _unit2];
   _membership1 = [0, 1];
   _collection2 = [_unit3, _unit4, _unit5];
   _membership2 = [1, 0, 2];
   _precalculated = [_collection1, _membership1] call FS_fnc_AgglomerativeClustering;
   _clusters = [_collection2, _membership2, _precalculated] call FS_fnc_AgglomerativeClustering;
   (end)

Author:
    kaydol
---------------------------------------------------------------------------- */

params ["_collection", "_distance", ["_precalculatedClusters", []]];

/*
	Consequently absorbs the elements if the distance 
	to cluster's center is below threshold. 
	
	This implementation was commented out because it 
	doesn't support feeding new points to precalculated clusters.
*//*

_workingCopy = +_collection;
_clusters = [];

while { count _workingCopy > 0 } do 
{
	_index = count _workingCopy - 1; // or 0 if removing from the start is faster
	_curCluster = [position ( _workingCopy # _index ), [_workingCopy # _index]];
	_workingCopy deleteAt _index;
	_mindist = -1;
	while { _mindist < _distance && count _workingCopy > 0 } do 
	{
		_data = [[_curCluster # 0], _workingCopy, True] call FS_fnc_DistanceBetweenArrays;
		_mindist = _data # 0;
		_closestObj = ( _data # 1 ) # 1;
		_closestIndex = ( _data # 2 ) # 1;
		
		if ( _mindist > 0 && _mindist < _distance ) then {
			( _curCluster # 1 ) pushBack _closestObj;
			_workingCopy deleteAt _closestIndex;
			_curCluster set [0, [_curCluster # 1] call FS_fnc_CalculateCenter2D];
		};
		
	};
	
	_clusters pushBack _curCluster;
};

_clusters 
*/

/*
	Tries to attach the point to the closest cluster 
	within threshold or turns it into a new cluster. 
	
	Basically the same idea but implented specifically
	to support adding new points to the already existing 
	array of clusters.
*/

if ( count _collection == 0 ) exitWith { _precalculatedClusters };

_workingCopy = +_collection;
_clusters = +_precalculatedClusters;

/* 
	Sometimes we can get an array of objects instead of positions for input... 
	Transform these into positions

if ( _collection # 0 isEqualType objNull ) then 
{	
	{
		_workingCopy set [_forEachIndex, position ( _collection # _forEachIndex )];
	}
	forEach _collection;
};
*/
while { count _workingCopy > 0 } do 
{
	_obj = _workingCopy deleteAt ( count _workingCopy - 1 ); // or 0 if removing from the start is faster
	
	_cluster = -1;
	_mindist = _distance + 1;
	{
		_dist = _x # 0 distance _obj;
		if ( _dist < _mindist ) then {
			_mindist = _dist;
			_cluster = _forEachIndex;
		};
	} 
	forEach _clusters;
	
	if ( _mindist < _distance ) then {
		// Merging the object with existing cluster
		_cluster = _clusters # _cluster;
		_cluster # 1 pushBackUnique _obj;
		_cluster set [0, [_cluster # 1] call FS_fnc_CalculateCenter2D];
	} 
	else {
		// Creating a new cluster out of this object
		_pos = if ( _obj IsEqualType [] ) then [{_obj},{position _obj}];
		_cluster = [_pos, [_obj]];
		_clusters pushBack _cluster;
	};
	
};

_clusters 