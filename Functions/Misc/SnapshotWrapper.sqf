/* ----------------------------------------------------------------------------
Function: FS_fnc_SnapshotWrapper

Description:
	Returns a valid snapshot if it exists. If it does not exist, or is expired,
	calculates and stores a new value and returns it.
	Used to decrese the amount of calculations by using cached values that are 
	not too old yet.
	
Parameters:
    _side - Defines a prefix of the global variable [EAST|WEST|RESISTANCE].
    _varname - Name of the variable [String].
	_time - if variable's age is bigger than this, it will be recalculated [Number].
	_arguments - arguments passed to the function for recalculating [Array].
	_function - function used to calculate the new value [String].
		
Returns:
    Cached or calculated variable.

Author:
    kaydol
---------------------------------------------------------------------------- */

params ["_side", "_varname", "_time", "_arguments", "_function"];

private _variable = [_side, _varname, _time] call FS_fnc_Snapshots;

if ( _variable isEqualTo [] ) then 
{
	_variable = _arguments call call compile _function;
	
	/* Saving into a snapshot */
	[_side, _varname, _variable] call FS_fnc_Snapshots;
	
};

_variable = +_variable; // 3 days wasted to find out I needed a + here.
_variable
