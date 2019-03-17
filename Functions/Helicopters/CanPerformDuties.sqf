params ["_aircraft"];

if ( !alive _aircraft ) exitWith { False };
if ( !canMove _aircraft ) exitWith { False };
if ( _aircraft call FS_fnc_IsMaintenanceNeeded ) exitWith { False };
if ( {!alive _x} count crew _aircraft > 0 ) exitWith { False };

_can = True;

{
	if ( damage _x > 0.35 ) exitWith { _can = False; };
} 
forEach crew _aircraft;

_can
