/* ----------------------------------------------------------------------------
Function: FS_fnc_BiggestClusterDiameter

Description:
	This function calculates the diameter in meters of the biggest cluster of objects \ positions.
	Used in conjuction with <FS_fnc_kMeansClustering> to determine if the clusterization is good.
  
Parameters:
    _objects - Contains a set of units or coordinates [Array of pos or objects].
    _membership - Contains the membership of each element from the first array [Array of integers].
	
Returns:
    Diameter of the biggest cluster.

Examples:
   (begin example)
   _collection = [_unit1, _unit2, _unit3, _unit4, _unit5];
   _membership = [0, 0, 0, 1, 2];
   _diameter = [_collection, _membership] call FS_fnc_BiggestClusterDiameter;
   (end)

Author:
    kaydol
---------------------------------------------------------------------------- */


params [["_objects", []], ["_membership", []]];

_maxDistance = 0;

for [{_i = 0},{_i < count _objects},{_i = _i + 1}] do 
{
	for [{_j = 0},{_j < count _objects},{_j = _j + 1}] do 
	{
		if (_i != _j) then {
			 if (( _membership # _j ) == ( _membership # _i )) then {
				_dist = ( _objects # _i ) distance ( _objects # _j );
				if ( _dist > _maxDistance ) then { _maxDistance = _dist }; 
			 };
		};
	};
};

_maxDistance
