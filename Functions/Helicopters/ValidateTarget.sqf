
params ["_aircraft", "_target", ["_debug", false]];

if (_debug) then {
	diag_log "Validate target";
};


if ( _target isEqualType objNull ) exitWith { False }; 

True 