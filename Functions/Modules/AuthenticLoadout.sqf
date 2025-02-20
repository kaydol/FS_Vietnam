/*
	An attempt to recreate VietCong loadout from Tanoa's DLC weapons.
	The unit is given Chinese voice though. Some units may get an RPG.
*/

if !(isServer) exitWith {};

params ["_unit"];

if !(local _unit) exitWith {};
if !(_unit isKindOf "MAN") exitWith {};

if (typeOf _unit == "O_soldier_Melee_Hybrid") then 
{
	comment "Remove existing items";
	removeAllWeapons _unit;
	removeAllItems _unit;
	removeAllAssignedItems _unit;
	removeUniform _unit;
	removeVest _unit;
	removeBackpack _unit;
	removeHeadgear _unit;
	removeGoggles _unit;

	// Decide vest 
	switch (round random 7) do {
		case 0: { 
			_unit forceAddUniform "vn_o_uniform_vc_01_01";
			_unit addVest "vn_o_vest_vc_02";
			_unit addHeadgear "vn_b_bandana_04";
		};
		case 1: { 
			_unit forceAddUniform "vn_o_uniform_vc_04_03";
			_unit addVest "vn_o_vest_vc_05";
		};
		case 2: { 
			_unit forceAddUniform "vn_o_uniform_vc_mf_09_07";
			_unit addVest "vn_o_vest_vc_03";
			_unit addHeadgear "vn_o_helmet_nva_04";
		};
		case 3: { 
			_unit forceAddUniform "vn_o_uniform_vc_mf_11_07";
			_unit addVest "vn_o_vest_06";
			_unit addHeadgear "vn_b_helmet_sog_01";

		};
		case 4: { 
			_unit forceAddUniform "vn_o_uniform_nva_army_09_04";
			_unit addVest "vn_o_vest_02";
			_unit addHeadgear "vn_o_helmet_nva_07";
		};
		case 5: { 
			_unit forceAddUniform "vn_o_uniform_vc_reg_12_09";
			_unit addVest "vn_o_vest_08";
			_unit addHeadgear "vn_o_helmet_nva_08";
		};
		case 6: { 
			_unit forceAddUniform "vn_o_uniform_pl_army_03_11";
			_unit addVest "vn_o_vest_01";
			_unit addHeadgear "vn_o_pl_cap_01_01";
		};
		default {
			_unit forceAddUniform "vn_o_uniform_vc_01_07";
			_unit addVest "vn_o_vest_vc_01";
			_unit addHeadgear "vn_o_cap_02";
		};
	};
	
	// Decide primary weapon 
	switch (round random 8) do {
		case 0: {
			_unit addWeapon "vn_m9130";
			_unit addPrimaryWeaponItem "vn_b_m38";
			_unit addPrimaryWeaponItem "vn_m38_mag";
			for "_i" from 1 to 1 do {_unit addItemToVest "vn_o_item_firstaidkit";};
			for "_i" from 1 to 10 do {_unit addItemToVest "vn_m38_mag";};
		};
		case 1: {
			_unit addWeapon "vn_m38";
			_unit addPrimaryWeaponItem "vn_b_m38";
			_unit addPrimaryWeaponItem "vn_m38_mag";
			for "_i" from 1 to 1 do {_unit addItemToVest "vn_o_item_firstaidkit";};
			for "_i" from 1 to 10 do {_unit addItemToVest "vn_m38_mag";};
		};
		case 2: {
			_unit addWeapon "vn_izh54";
			_unit addPrimaryWeaponItem "vn_izh54_mag";
			for "_i" from 1 to 13 do {_unit addItemToVest "vn_izh54_mag";};
		};
		case 3: { 
			_unit addWeapon "vn_k98k";
			_unit addPrimaryWeaponItem "vn_b_k98k";
			_unit addPrimaryWeaponItem "vn_k98k_mag";
			for "_i" from 1 to 10 do {_unit addItemToVest "vn_k98k_mag";};
		};
		case 4: { 
			_unit addWeapon "vn_ak_01";
			_unit addPrimaryWeaponItem "vn_type56_mag";
			for "_i" from 1 to 3 do {_unit addItemToUniform "vn_type56_mag";};
			for "_i" from 1 to 4 do {_unit addItemToVest "vn_type56_mag";};
		};
		case 5: { 
			_unit addWeapon "vn_mat49_vc";
			_unit addPrimaryWeaponItem "vn_mat49_vc_t_mag";
			for "_i" from 1 to 8 do {_unit addItemToVest "vn_mat49_vc_mag";};
		};
		case 6: { 
			_unit addWeapon "vn_pps52";
			_unit addPrimaryWeaponItem "vn_pps_mag";
			for "_i" from 1 to 3 do {_unit addItemToUniform "vn_pps_mag";};
			for "_i" from 1 to 6 do {_unit addItemToVest "vn_pps_mag";};
		};
		case 7: { 
			_unit addWeapon "vn_sks";
			_unit addPrimaryWeaponItem "vn_b_sks";
			_unit addPrimaryWeaponItem "vn_sks_mag";
			for "_i" from 1 to 3 do {_unit addItemToUniform "vn_sks_mag";};
			for "_i" from 1 to 10 do {_unit addItemToVest "vn_sks_mag";};
		};
		default {};
	};
	
	// Decide secondary weapon 
	switch (round random 8) do {
		case 0: { _unit addWeapon "Shovel_Russian"; };
		case 1: { _unit addWeapon "vn_m_hammer"; };
		case 2: { _unit addWeapon "vn_m_machete_01";	};
		case 3: { _unit addWeapon "vn_m712"; _unit addHandgunItem "vn_m712_mag"; for "_i" from 1 to 3 do {_unit addItemToUniform "vn_m712_mag";}; };
		case 4: { _unit addWeapon "vn_m_axe_fire"; };
		case 5: {  };
		case 6: {  };
		case 7: {  };
		default {};
	};
	
	_unit addItemToVest "vn_rgd5_grenade_mag";
	_unit addItemToVest "vn_molotov_grenade_mag";
	
	if (random 1 > 0.8) then 
	{
		_unit addGoggles "cigs_Apollo_cig0";
		_unit addItemToUniform "cigs_Kosmos_cigpack";
		_unit addItemToUniform "cigs_lighter";
	};
	
};

private _face = selectRandom [
	"AsianHead_A3_01", 
	"AsianHead_A3_02",
	"AsianHead_A3_03",
	"AsianHead_A3_04",
	"AsianHead_A3_05",	
	"AsianHead_A3_06"
];

_unit setFace _face;
/*
private _voice = selectRandom [
	"male01chi", 
	"male02chi", 
	"male03chi"
];

_unit setSpeaker _voice;
*/
_unit setSpeaker "NoVoice";