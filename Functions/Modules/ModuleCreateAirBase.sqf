/* ----------------------------------------------------------------------------
Function: FS_fnc_ModuleCreateAirBase

Description:
	Adds a new base to the list of bases available to the pilots.
	Relies heavily on synced objects to determine side, ressuply points
	and repairing capabilities.
	
Synced objects:
    "SideXXX_F":				Side this base belongs to. Must be an object with type 
								"SideBLUFOR_F", "SideOPFOR_F" or "SideResistance_F".
    "LocationRespawnPoint_F": 	(Optional) Defines a spawn position for new crew replacements to spawn at.
								A new unit will spawn and run from here to the helicopter. Can sync many.

Parameters:
    _module - The module with a side synced to it.
	
Returns:
    Nothing.

Author:
    kaydol
---------------------------------------------------------------------------- */

if !(isServer || isDedicated) exitWith {};

params ["_module"];

_synced = synchronizedObjects _module; 

/* The first iterated synchronyzed Side will define the side of this base. 
If no Side is synced, the base is unavailable to everyone. */

_side = sideLogic;
{
	_side = _x call FS_fnc_GetModuleOwner;
	if !( _side isEqualTo sideLogic ) exitWith { };
} 
forEach _synced;

if ( _side isEqualTo sideLogic ) exitWith { ["[Air Base] No Side has been synced, please sync a Side that will get access to this module"] call BIS_fnc_error };

if (isNil{ FS_REFUELRELOAD_BASES }) then { 
	FS_REFUELRELOAD_BASES = []; 
};
if (isNil{ FS_REINFORCEMENT_BASES }) then { 
	FS_REINFORCEMENT_BASES = []; 
};
	
_providesMaintenance = _module getVariable ["providesMaintenance", False];
if ( _providesMaintenance ) then 
{
	FS_REFUELRELOAD_BASES pushBackUnique _module;
};

_providesCrew = _module getVariable ["providesCrew", False];
if ( _providesCrew ) then 
{
	FS_REINFORCEMENT_BASES pushBackUnique _module;

	/* If respawn point entities were synced, use their positions as respawn points for new crew */
	_respawn_points = [];
	{
		if (typeOf _x == "LocationRespawnPoint_F") then {
			_respawn_points pushBack getPos _x;
		};
	}
	forEach _synced;
	
	_module setVariable ["respawn_points", _respawn_points, True];
};


/* Code that happens only once regardles of how many air bases are placed */
if (isNil { FS_AIRBASES_INIT_PUBLICVARIABLE }) then {
	FS_AIRBASES_INIT_PUBLICVARIABLE = 0;
	sleep 5;
	publicVariable "FS_REINFORCEMENT_BASES";
	publicVariable "FS_REFUELRELOAD_BASES";
	FS_AIRBASES_INIT_PUBLICVARIABLE = nil;
};
