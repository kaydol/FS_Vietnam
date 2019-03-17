
/*
	Returns a valid snapshot if it exists, otherwise does what it's told
	to calculate, update and return that snapshot
	
	Please, in order to spend 3 days debugging, do NOT use pushBack with
	the results that come of this function
*/

params ["_side", "_varname", "_time", "_arguments", "_function"];

_variable = [_side, _varname, _time] call FS_fnc_Snapshots;

if ( _variable isEqualTo [] ) then 
{
	_variable = _arguments call call compile _function;
	
	/* Saving into a snapshot */
	[_side, _varname, _variable] call FS_fnc_Snapshots;
	
};

_variable = +_variable; // After I wasted 3 days chasing a very rare and weird bug, I learned that this variable must be dispensed as a copy, and that by default it's sent out as a reference
_variable
