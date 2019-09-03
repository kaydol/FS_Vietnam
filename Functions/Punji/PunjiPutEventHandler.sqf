
params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

if ( _weapon == "Put" ) then 
{
	private _id = _unit getVariable "PunjiPutEventHandler";
	
	if !( isNil{ _id } ) then {
		// Only remove this handler if it was stored in unit's namespace
		_unit removeEventHandler ["Fired", _id]; 
	};
	_projectile setVectorUp surfaceNormal position _projectile; // To fix some punji traps' wrong orientation
	
	if ( isNil { FS_AllGookTraps }) then {
		FS_AllGookTraps = [];
	};
	
	// TODO add isPlayer _unit to distinguish mines placed by player
	if ( _muzzle == "uns_punj1_muzzle" ) then {
		FS_AllGookTraps pushBack [_projectile, getPos _projectile, [vectorDir _projectile, vectorUP _projectile]]; 
	} else {
		FS_AllGookTraps pushBack _projectile;
	};
	
	// For Garbage Collector && Punji Trap animations
	publicVariable "FS_AllGookTraps"; // *sigh*
	
};