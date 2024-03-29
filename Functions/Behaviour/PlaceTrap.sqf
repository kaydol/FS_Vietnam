
#include "..\..\definitions.h"

params ["_unit", ["_debug", false]];

if !(alive _unit) exitWith {};
if !(local _unit) exitWith {
	[_unit, _debug] remoteExec ["FS_fnc_PlaceTrap", _unit];
};

private _tripwires = getArray (configFile >> "CfgWeapons" >> "Put" >> DEF_PUT_MUZZLE_WIREMINE >> "magazines");
private _punjis = getArray (configFile >> "CfgWeapons" >> "Put" >> DEF_PUT_MUZZLE_PUNJI >> "magazines");

_tripwires = magazines _unit arrayIntersect _tripwires; // returns an array of unique common elements
_punjis = magazines _unit arrayIntersect _punjis; 		// returns an array of unique common elements

if (count _tripwires == 0 && count _punjis == 0) exitWith {};

_unit playActionNow "PutDown"; 
private _choice = selectRandom (_tripwires + _punjis);

private _id = _unit addEventHandler ["Fired", { _this call FS_fnc_PutEventHandler; }];

_unit setVariable ["PutEventHandler", _id];

if ( _choice in _tripwires ) then {
	_unit selectWeapon DEF_PUT_MUZZLE_WIREMINE; 
	_unit fire [DEF_PUT_MUZZLE_WIREMINE, DEF_PUT_MUZZLE_WIREMINE, _choice];
} else {
	_unit selectWeapon DEF_PUT_MUZZLE_PUNJI; 
	_unit fire [DEF_PUT_MUZZLE_PUNJI, DEF_PUT_MUZZLE_PUNJI, _choice]; 
};

_unit setWeaponReloadingTime [_unit, "PutMuzzle", 0];
_unit selectWeapon primaryWeapon _unit; 

