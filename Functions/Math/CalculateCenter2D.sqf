/* ----------------------------------------------------------------------------
Function: FS_fnc_CalculateCenter2D

Description:
	Calculates a center of a set of positions or objects. 
	
Parameters:
    _collection - Contains a set of elements to process [Array of positions or objects].
	
Returns:
    Position of the center, z-coordinate is 0.

Examples:
   (begin example)
   _collection = [_unit1, _unit2, _unit3];
   _center2D = [_collection] call FS_fnc_CalculateCenter2D;
   (end)

Author:
    kaydol
---------------------------------------------------------------------------- */

params ["_collection"];

_k = count _collection;
if ( _k isEqualTo 0 ) exitWith { [] };

_sumX = 0; _sumY = 0; _sumZ = 0;

if ( _collection # 0 isEqualType [] ) then 
{
	for [{_i = 0},{_i < _k},{_i = _i + 1}] do 
	{
		_sumX = _sumX + (_collection # _i) # 0; 
		_sumY = _sumY + (_collection # _i) # 1;
	};
}
else 
{
	for [{_i = 0},{_i < _k},{_i = _i + 1}] do 
	{
		_pos = position ( _collection # _i );
		_sumX = _sumX + _pos # 0; 
		_sumY = _sumY + _pos # 1;
	};
};

_center = [_sumX / _k, _sumY / _k, 0];

_center








