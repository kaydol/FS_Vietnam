
/*
	Storing time-specific variables and dispensing them if they're still relevant 
	Used to decrease the amount of calculations where applicable by using the recent
	values instead of re-calculating them all over again
*/

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