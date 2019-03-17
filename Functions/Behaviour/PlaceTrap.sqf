
params ["_unit"];

if !(alive _unit) exitWith {};

private ["_tripwires", "_punjis", "_choice", "_id"];

_tripwires = getArray (configFile >> "CfgWeapons" >> "Put" >> "uns_ClassicMineWireMuzzle" >> "magazines");
_punjis = getArray (configFile >> "CfgWeapons" >> "Put" >> "uns_punj1_muzzle" >> "magazines");

_tripwires = magazines _unit arrayIntersect _tripwires; // returns an array of unique common elements
_punjis = magazines _unit arrayIntersect _punjis; 		// returns an array of unique common elements

if (count _tripwires == 0 && count _punjis == 0) exitWith {};

_unit playActionNow "PutDown"; 

_choice = selectRandom (_tripwires + _punjis);


_id = _unit addEventHandler ["Fired", {
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
	if ( _weapon == "Put" ) then 
	{
		_id = _unit getVariable "EH_Fire";
		_unit removeEventHandler ["Fired", _id];
		_projectile setVectorUp surfaceNormal position _projectile; // To fix some punji traps' wrong orientation
		
		if ( isNil { FS_AllGookTraps }) then { FS_AllGookTraps = []; };
		if ( _muzzle == "uns_punj1_muzzle" ) then {
			FS_AllGookTraps pushBack [_projectile, getPos _projectile, [vectorDir _projectile, vectorUP _projectile]]; 
		} else {
			FS_AllGookTraps pushBack _projectile;
		};
		
		// For Garbage Collector && Punji T  rap animations
	};
}];

_unit setVariable ["EH_Fire", _id];

if ( _choice in _tripwires ) then {
	_unit selectWeapon "uns_ClassicMineWireMuzzle"; 
	_unit fire ["uns_ClassicMineWireMuzzle", "uns_ClassicMineWireMuzzle", _choice];
} else {
	_unit selectWeapon "uns_punj1_muzzle"; 
	_unit fire ["uns_punj1_muzzle", "uns_punj1_muzzle", _choice]; 
};

_unit setWeaponReloadingTime [_unit, "PutMuzzle", 0];
_unit selectWeapon primaryWeapon _unit; 

