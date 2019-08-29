/* ----------------------------------------------------------------------------
Function: FS_fnc_Snapshots

Description:
	Stores a variable with a lifespan and dispenses it if it's still relevant.
	Used to decrese the amount of calculations by using cached values that are 
	not too old yet.
	
Parameters:
    _side - Defines a prefix of the global variable [EAST|WEST|RESISTANCE].
    _varname - Name of the variable [String].
	_parameter - [Number] or [Array of data]. If number, returns the variable's 
		value if age is less than this number. If not a number, it's treated as 
		data to be stored.
		
Returns:
    Data stored in the variable or [].

Examples:
	Stores _data to a global variable GUER_CLUSTERIZATION_DATA:
		[RESISTANCE, "CLUSTERIZATION_DATA", _data] call FS_fnc_Snapshots;
		
	Retreives the data if the age of the variable is less than 30 seconds, otherwise returns []:
		_data = [RESISTANCE, "CLUSTERIZATION_DATA", 30] call FS_fnc_Snapshots;

Author:
    kaydol
---------------------------------------------------------------------------- */

params ["_side", "_varname", "_parameter"];

_stored = [];
call compile format ["
	if ( isNil{ %1_%2 } ) then { %1_%2 = []; }; 
	_stored = %1_%2;
", _side, _varname];

_result = [];

if ( _parameter isEqualType 0 ) then {

	if ( count _stored == 0 ) exitWith { };

	// Dispense data, treat _parameter as a time frame
	if ( time - _stored # 0  < _parameter ) then { _result = _stored # 1; };
}
else {
	// Store data, treat _parameter as data to be stored
	_stored set [0, time];
	_stored set [1, _parameter];
};

_result 