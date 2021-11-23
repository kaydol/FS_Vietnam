params ["_aircraft"];

if !( alive _aircraft ) exitWith { False };
if !( canMove _aircraft ) exitWith { False };
if !( call FS_fnc_IsEnoughDaylight ) exitWith { False };
if ( _aircraft call FS_fnc_IsMaintenanceNeeded ) exitWith { False };
if ( {!alive _x} count crew _aircraft > 0 ) exitWith { False };

// Check crew HEALTH 
private _can = True;
private _maxDamage = missionNameSpace getVariable ["MAINTENANCE_HEAL_AT", 0.35];
{
	if ( damage _x > _maxDamage ) exitWith { _can = False; };
} 
forEach crew _aircraft;

_can
