/* ----------------------------------------------------------------------------
Function: FS_fnc_DistanceBetweenArrays

Description:
	Returns distance between closest elements of two arrays of elements.
	In theory it should work faster if the second array is bigger than the first one
	(as opposed to the other way around).
	
Parameters:
    _array1 - Contains a set of elements to process [Array of positions or objects].
    _array2 - Contains a set of elements to process [Array of positions or objects].
    _verbose - Changes the output format of the function, from number (when False) to 
		[_minDistance, [_closestFromArray1, _closestFromArray2], [_index1, _index2]] (when True) [Boolean].
	
Returns:
    Distance, or [_minDistance, [_closestFromArray1, _closestFromArray2], [_index1, _index2]]
	if _verbose is set to True.

Examples:
	(begin example)
	_array1 = [_unit1, _unit2, _unit3];
	_array2 = [_unit4, _unit5, _unit6];
	_distance = [_array1, _array2] call FS_fnc_DistanceBetweenArrays;
	(end)

Author:
    kaydol
---------------------------------------------------------------------------- */

//diag_log format ["FS_fnc_DistanceBetweenArrays Input: %1", _this];

params [["_array1", []], ["_array2", []], ["_verbose", false, [true]], ["_distance2D", false, [true]]];

private _closestFromArray1 = objNull;
private _closestFromArray2 = objNull;
private _minDistance = -1;
private _index1 = -1;
private _index2 = -1;

if (count _array1 > 0 && count _array2 > 0) then 
{
	_minDistance = if (_distance2D) then [{( _array1 select 0 ) distance2D ( _array2 select 0 )},{( _array1 select 0 ) distance ( _array2 select 0 )}];;
	{
		_elem = _x;
		_temp = _forEachIndex;
		{
			_dist = if (_distance2D) then [{_elem distance2D _x},{_elem distance _x}];
			if ( _dist <= _minDistance ) then {
				_minDistance = _dist; 
				if ( _verbose ) then {
					_closestFromArray1 = _elem; 
					_closestFromArray2 = _x; 
					_index1 = _temp;
					_index2 = _forEachIndex;
				};
			};
		} 
		forEach _array2;
	}
	forEach _array1;
};

//diag_log format ["FS_fnc_DistanceBetweenArrays Output: %1", [_minDistance, [_closestFromArray1, _closestFromArray2], [_index1, _index2]]];

if ( _verbose ) exitWith {
	[_minDistance, [_closestFromArray1, _closestFromArray2], [_index1, _index2]]
};

_minDistance
 