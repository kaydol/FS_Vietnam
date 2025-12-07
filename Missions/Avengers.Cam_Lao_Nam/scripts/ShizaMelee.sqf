
#include "definitions.h"

#define DEF_TIMEOUT 60 
#define DEF_SAY3D "skyrim_bass_boosted_battle_theme"


params ["_target"];

diag_log format ["(ShizaMelee @ %1) Attempt to run script on %2", clientOwner, _target];

if !(local _target) exitWith {
	diag_log format ["(ShizaMelee @ %1) Unit %2 is not local, exiting...", clientOwner, _target];
};

private _grp = createGroup [EAST, true];

private _charger = objNull; 

isNil{
	_charger = _grp createUnit ["vn_o_men_vc_regional_13", _target modelToWorld [0, 50, 0], [], 0, "NONE"];
	
	removeAllWeapons _charger;
	removeAllItems _charger;
	removeAllAssignedItems _charger;
	removeUniform _charger;
	removeVest _charger;
	removeBackpack _charger;
	removeHeadgear _charger;
	removeGoggles _charger;
	
	_charger addWeapon "vn_m1891";
	//_charger addPrimaryWeaponItem "vn_b_m38";
	_charger forceAddUniform "vn_o_uniform_vc_mf_02_07";
	_charger addHeadgear "vn_o_helmet_vc_04";
	_charger addGoggles "vn_o_scarf_01_04";
	[_charger,"vn_vietnamese_02_02_face","vie"] call BIS_fnc_setIdentity;
};

if (DEF_SAY3D != "") then {
	_charger say3d ["skyrim_bass_boosted_battle_theme", 500];
};

_charger setCaptive true;

_charger addEventHandler ["HandleDamage", {0}];
_charger execVM "scripts\ImmortalNPC.sqf";

_charger hideObjectGlobal true;
_charger hideObject false;

_charger reveal [_target, 4];
_charger setBehaviourStrong "CARELESS";
_charger doMove getPos _target;
_charger doTarget _target;

_charger setVariable ["ForcedNearestEnemyResult", _target, true];

_charger spawn IMS_AI_MakeAiGoBayonetScript;

diag_log format ["(ShizaMelee @ %1) Unit %2 spawned", clientOwner, _charger];

private _time = time;

waitUntil {
	private _check = isNil{_charger}; 
	if (!_check) then { _check = isNull _charger };
	if (!_check) then { _check = isNil{_target} };
	if (!_check) then { _check = isNull _target };
	(_target getVariable ["vn_revive_incapacitated", false]) || !alive _target || !alive _charger || time - _time > DEF_TIMEOUT
};

diag_log format ["(ShizaMelee @ %1) Deleting %2", clientOwner, _charger];

deleteVehicle _charger;
