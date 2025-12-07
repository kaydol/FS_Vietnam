
#define DEF_IMS_UNCONSCIOUS_ANIMS ["IMS_Rifle_Sync_1_victim", "IMS_Rifle_Sync_2_victim", "IMS_Rifle_Sync_Player_1_victim", "IMS_Rifle_Sync_Player_2_victim", "IMS_Rifle_Sync_Blunt_back_victim", "IMS_Rifle_Sync_Blunt_front_victim", "IMS_Rifle_Sync_Knife_back_reversed_victim", "IMS_Rifle_Sync_Knife_back_victim", "IMS_Rifle_Sync_Knife_front_reversed_victim", "IMS_Rifle_Sync_Knife_front_victim", "IMS_Rifle_Sync_Knife_front_victim_1", "human_execution_bayonet_victim_front", "human_execution_bayonet_victim_backward"]
#define DEF_A3_INCAPPED_STATES ["INCAPACITATED", "INJURED"]
#define DEF_STANDUP_ANIMS ["Acts_Getting_Up_Player","Acts_Flashes_Recovery_1","Acts_Flashes_Recovery_2"]


params ["_unit"];

if !(local _unit) exitWith {
	//[_unit, {_this execVM "scripts\ImmortalNPC.sqf"}] remoteExec ["spawn", _unit];
};

private _fnc_quitDyingAnimation = {
	params ["_unit", "_anim"];
	
	if (DEF_IMS_UNCONSCIOUS_ANIMS findIf { _anim == _x } >= 0 || DEF_A3_INCAPPED_STATES findIf {lifeState _unit == _x} >= 0 ) then 
	{
		[_unit, selectRandom DEF_STANDUP_ANIMS] remoteExec ["switchMove", 0];
		_unit setUnconscious false;
	};
};
_unit addEventHandler ["AnimDone", _fnc_quitDyingAnimation];


[_unit, 99999999] remoteExec ["FS_fnc_AddGodmodeTimespan", _unit];

_unit addEventHandler ["FiredMan", {
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];
	_unit setAmmo [currentWeapon _unit, 1000];
}];

_unit addEventHandler ["HandleDamage", {0}];

_unit addEventHandler ["Killed", {
	params ["_unit", "_killer", "_instigator", "_useEffects"];
	
	//private _group = group ( ((switchableUnits + playableUnits) select {side _x == WEST}) select 0 );
	private _group = group _unit;
	private _newUnit = _group createUnit [typeOf _unit, getPos _unit, [], 0, ""];
	
	private _fullName = name _unit;
	
	if (_fullName find " " > 0) then {
		(_fullName splitString " ") params ["_firstName", "_secondName"];
		private _array = [_fullName, _firstName, _secondName];
		_newUnit setName _array;
	};
	
	if (nameSound _unit != "") then {
		_newUnit setNameSound (nameSound _unit);
	};
	_newUnit setMimic "Angry";
	
	_newUnit execVM "scripts\ImmortalNPC.sqf";
	_newUnit execVM "scripts\AddMapMarkerNametagAndHealthbar.sqf";
	
	call compile format ["%1 = %2; publicVariable '%1';", _unit, _newUnit call BIS_fnc_setVar];
	
	deleteVehicle _unit;
}];

