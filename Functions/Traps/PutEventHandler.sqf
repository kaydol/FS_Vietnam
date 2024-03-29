
params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

if ( _weapon == "Put" ) then 
{
	private _id = _unit getVariable "PutEventHandler";
	
	if !( isNil{ _id } ) then {
		// Only remove this handler if it was stored in unit's namespace
		_unit removeEventHandler ["Fired", _id]; 
		_unit setVariable ["PutEventHandler", nil];
	};
	_projectile setVectorUp surfaceNormal position _projectile; // To fix some punji traps' wrong orientation
	_projectile enableDynamicSimulation true;
	
	//-- "surfaceIsWater also detects pond objects, but only if they are loaded in memory 
	//-- (normally only true if the objects are within the object view distance)"
	if (surfaceIsWater position _projectile) then {
		deleteVehicle _projectile;
	};
	
	(side _unit) revealMine _projectile;
	
	if ( isNil { FS_AllGookTraps }) then {
		FS_AllGookTraps = [];
	};
	
	FS_AllGookTraps pushBack _projectile;
	
	// For Garbage Collector
	publicVariable "FS_AllGookTraps";
	
};