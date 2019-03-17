/* ----------------------------------------------------------------------------
Function: FS_fnc_GetSideVariable

Description:
	A getter for a Map (Dictionary). Gets the value of the 
	key-value pair stored in a global variable with a complex name.
	
	A map cannot contain duplicate keys; each key can map to at most one value. 
	
Parameters:
    _side - EAST, WEST, or INDEPENDENT [Side].
    _varname - "AIRSTATIONS", "FIRETASKS" or any other name [String].
	_key - key for a key-value pair stored in the map [Anything]. 
	
Returns:
    Value from the key-value pair or [].

Examples:
	(begin example)
	_value = [EAST, "AIRSTATIONS", _heli] call FS_fnc_GetSideVariable;
	(end)

Author:
    kaydol
---------------------------------------------------------------------------- */

/*
	_this select 0: side
	_this select 1: "AIRSTATIONS", "FIRETASKS", or any other string
	_this select 2: _key 

*/

params ["_side", "_varname", "_key"];

_array = [];
call compile format ["
	if ( isNil { %1_%2 } ) then { %1_%2 = [] }; 
	_array = %1_%2;
", _side, _varname];

_index = _array findIf { _x # 0 == _key };

if ( _index >= 0 ) exitWith 
{
	( _array # _index ) # 1
};

[] 
