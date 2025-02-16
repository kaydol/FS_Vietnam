/* ----------------------------------------------------------------------------
Function: FS_fnc_Clusterize

Description:
	A wrapper of supported clusterization algorithms, bundled with debugging tools.
	
Parameters:
    _collection - Contains a set of elements to process [Array of positions or objects].
    _maxClusterDiam - The two furthermost points of each cluster won't be farther than this threshold [Number].
	_precalculatedClusters - (Optional) If the clusterization of some of the data was already done before, it can be used to speed up the clusterization of new elements [Array of [_clusterCenter, _belongingElements]]. Use [] for kMeans.
	_debug - (Optional) True or False. Draws lines and markers on all elements and centers of the clusters [Boolean].
	_algo - (Optional) Either "Agglomerative" or "kMeans" [String].
	
Returns:
    Array of arrays, [_clusters_centers, _cluster_sizes, _membership]
	_membership is an array with the same size as _collection and it contains the ID of cluster each element belongs to

Examples:
	(begin example)
	_data = [[_unit1, _unit2, _unit3], 35, [], "Agglomerative", True] call FS_fnc_Clusterize;
	(end)

Author:
    kaydol
---------------------------------------------------------------------------- */

params ["_collection", "_maxClusterDiam", ["_precalculatedClusters", []], ["_debug", False], ["_algo", "Agglomerative"]];

/*
	Two algorithms are available for clustering purposes :
		kMeans - clunky and slow working version
		Aglomeration - new faster method 
	
	The biggest weakness of kMeans is that we don't know how many of clusters there are,
	so it performs multiple iterations each time increasing the number of clusters by 1
	until the biggest cluster reached _maxClusterDiam threshold.
	
	The new Aglomeration method lacks that weakness and instead implements a hierarchical
	algorithm that makes all clusters consequently absorb closest elements within threshold. 
*/

private _data = [];
//_start = diag_tickTime;
//diag_log format ["FS_fnc_Clusterize Input: %1", _this];

switch ( _algo ) do {
	case "kMeans": {
	
		/* Increase amount of clusters until maximum distance inside a single cluster drops beyond threshold */
		private _numberOfClusters = 1;
		_data = [_collection, _numberOfClusters] call FS_fnc_kMeansClustering;
		private _biggestCluster = [_collection, _data # 2] call FS_fnc_BiggestClusterDiameter;

		while { _biggestCluster > _maxClusterDiam } do 
		{
			_data = [_collection, _numberOfClusters] call FS_fnc_kMeansClustering;
			_biggestCluster = [_collection, _data # 2] call FS_fnc_BiggestClusterDiameter;
			_numberOfClusters = _numberOfClusters + 1;
		};

	};
	case "Agglomerative": {
		
		private _clusters = [_collection, _maxClusterDiam, _precalculatedClusters] call FS_fnc_AgglomerativeClustering;
		
		/* 
			Breaks _clusters into [_cluster_centers, _cluster_sizes, _membership] 
			Implemented for interchangeability of FS_fnc_AglomerativeClustering & FS_fnc_kMeansClustering 
		*/
		private _membership = []; 
		_membership resize count _collection;
		private _cluster_centers = [];
		private _cluster_sizes = [];
		
		{
			_cluster_centers pushBack ( _x # 0 );
			_cluster_content = _x # 1;
			_cluster_sizes pushBack count _cluster_content;
			
			private  _i = 0;
			for [{_i = 0},{_i < count _cluster_content},{_i = _i + 1}] do 
			{
				private _objectIsOwnedByClusterWithThisId = _collection find (_cluster_content # _i);
				
				if (_debug && !(_objectIsOwnedByClusterWithThisId isEqualType 0)) then 
				{
					diag_log format ["Could not find %1 in array %2", (_cluster_content # _i), _collection];
					//systemChat format ["Could not find %1 in array %2", (_cluster_content # _i), _collection];
					//hint format ["Could not find %1 in array %2", (_cluster_content # _i), _collection];
				};
				
				_membership set [_objectIsOwnedByClusterWithThisId, _forEachIndex];
			};
		}
		forEach _clusters;
		
		_data = [_cluster_centers, _cluster_sizes, _membership];
	};
	
	default {};
};

/* Debug */
if ( _debug && !(_data isEqualTo []) ) then 
{
	diag_log format ["Clusterize.sqf result is: %1", _data] ;
	_data params ["_clusters_centers", "_cluster_sizes", "_membership"];

	private _lineEHs = [];
	private _markers = [];
	
	private  _i = 0;
	for [{_i = 0},{_i < count _collection},{_i = _i + 1}] do 
	{
		_pos1 = _collection select _i;
		if !( _pos1 isEqualType [] ) then { _pos1 = getPos _pos1; };
		
		// sometimes _membership can have <null> values in it 
		if (( _membership select _i ) isEqualType 0) then 
		{
			_pos2 = _clusters_centers select ( _membership select _i );
			private _id = (findDisplay 12 displayCtrl 51) ctrlAddEventHandler ["Draw", format ["(_this select 0) drawLine [%1,%2,[1,1,1,1]];", _pos1, _pos2] ];
			_lineEHs pushBack _id;
		};
	};
	// create markers on enemies with their cluster for label
	for [{_i = 0},{_i < count _collection},{_i = _i + 1}] do {
		_pos = _collection select _i;
		
		private _marker = [_pos, "mil_box", "ColorBlack"/*,str ( _membership select _i )*/] call FS_fnc_CreateDebugMarker;
		_markers pushBack _marker;
	};
	// create markers on every cluster
	for [{_i = 0},{_i < count _clusters_centers},{_i = _i + 1}] do {
		_pos = _clusters_centers select _i;
		
		private _marker = [_pos, "mil_dot", "ColorWhite"] call FS_fnc_CreateDebugMarker;
		_markers pushBack _marker;
	};
	// gradually increase transparency
	// TODO should probably replace 30 with asessment rate 
	[_markers, 30] spawn FS_fnc_FadeDebugMarkers;
	
	[_lineEHs, 30] spawn {
		params ["_lineEHs", "_sleep"];
		sleep _sleep;
		{(findDisplay 12 displayCtrl 51) ctrlRemoveEventHandler ["Draw", _x]} forEach _lineEHs;
	};
};

//_stop = diag_tickTime;
//diag_log format ["%1 clustering took %2 ms", _algo, _stop - _start];
//diag_log format ["FS_fnc_Clusterize Result: %1", _data];

_data 
