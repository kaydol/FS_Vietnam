/* ------------------------------------------------------------------------------
Function: FS_fnc_UpdateSideVariable

Description:
	A setter for a Map (Dictionary). Sets or removes the value of the 
	key-value pair stored in a global variable with a complex name.
	
	Can remove the variable after given time has elapsed.
	Can remove the variable if _value is not supplied.
	
	A map cannot contain duplicate keys; each key can map to at most one value.
	
Parameters:
    _side - EAST, WEST, or INDEPENDENT [Side].
    _varname - "AIRSTATIONS", "FIRETASKS" or any other name [String].
	_data - a key-value pair that needs to be stored in the map, or _key to remove it.
	_lifetime - (Optional) time in seconds after which this variable will be removed [Number].
	
Returns:
    Nothing.

Examples:
	(begin example)
	_value = [EAST, "AIRSTATIONS", [_heli, _pos], 120] call FS_fnc_UpdateSideVariable;
	(end)

Author:
    kaydol
------------------------------------------------------------------------------ */


/*
	Map implementation 
	
	_this select 0: side
	_this select 1: "AIRSTATIONS", "FIRETASKS", or any other string
	_this select 2: [_key, _data] 
	_this select 3: variable lifetime in seconds after which it will be removed
	
*/

params ["_side", "_varname", "_data", "_lifetime"];
_data params ["_key", "_value"];

_array = [];
call compile format ["
	if ( isNil { %1_%2 } ) then { %1_%2 = [] }; 
	_array = %1_%2;
", _side, _varname];

_index = _array findIf { _x # 0 == _key };

// If no _value was specified, remove the _key from the list 
if ( isNil{ _value } ) exitWith 
{
	if ( _index >= 0 ) then { _array deleteAt _index; };
};

// Inserting or updating the array
if ( _index < 0 ) then {
	_pair = [_key, _value]; 
	_array pushBack _pair;
} else {
	( _array # _index ) set [1, _value];
};

if !( isNil{ _lifetime } ) then 
{
	[_side, _varname, _key, _lifetime] spawn {
		params ["_side", "_varname", "_key", "_lifetime"];
		sleep _lifetime;
		//systemchat "Removing side variable " + _key;
		[_side, _varname, _key] call FS_fnc_UpdateSideVariable;
	};
};