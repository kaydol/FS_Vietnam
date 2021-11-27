/*
	An attempt to recreate VietCong loadout from Tanoa's DLC weapons.
	The unit is given Chinese voice though. Some units may get an RPG.
*/

if !(isServer) exitWith {};

params ["_unit"];

comment "Exported from Arsenal by Fess";

comment "Remove existing items";
removeAllWeapons _unit;
removeAllItems _unit;
removeAllAssignedItems _unit;
removeUniform _unit;
removeVest _unit;
removeBackpack _unit;
removeHeadgear _unit;
removeGoggles _unit;

comment "Add containers";

_uniform = selectRandom [
	"U_I_C_Soldier_Bandit_3_F", 
	"U_BG_Guerilla1_1", 
	"U_BG_Guerilla1_2_F", 
	"U_C_Mechanic_01_F",
	"U_I_C_Soldier_Para_3_F",
	"U_I_C_Soldier_Para_4_F",
	"U_I_C_Soldier_Para_1_F"
];

_unit forceAddUniform _uniform;

_unit addItemToUniform "FirstAidKit";
_unit addItemToUniform "MiniGrenade";
_unit addItemToUniform "30Rnd_762x39_Mag_F";

_vest = selectRandom [
	"V_BandollierB_khk", 
	"V_BandollierB_ghex_F", 
	"V_BandollierB_rgr", 
	"V_BandollierB_cbr"
];

_unit addVest _vest;


_unit addItemToVest "FirstAidKit";
for "_i" from 1 to 6 do {_unit addItemToVest "30Rnd_762x39_Mag_F";};
_unit addItemToVest "HandGrenade";

comment "Add weapons";
_unit addWeapon "arifle_AKM_F";

if (random 1 > 0.8) then {
	comment "RPG, backpack and rockets";
	
	_backpack = selectRandom [
		"B_FieldPack_khk", 
		"B_FieldPack_oli"
	];
	
	_unit addBackpack _backpack;
	for "_i" from 1 to 3 do {_unit addItemToBackpack "RPG7_F";};
	_unit addWeapon "launch_RPG7_F";
};

comment "Add items";
_unit linkItem "ItemCompass";
_unit linkItem "ItemGPS";

comment "Set identity";

_face = selectRandom [
	"AsianHead_A3_01", 
	"AsianHead_A3_02",
	"AsianHead_A3_03",
	"AsianHead_A3_04",
	"AsianHead_A3_05",	
	"AsianHead_A3_06"
];

_unit setFace _face;

_voice = selectRandom [
	"male01chi", 
	"male02chi", 
	"male03chi"
];

_unit setSpeaker _voice;
