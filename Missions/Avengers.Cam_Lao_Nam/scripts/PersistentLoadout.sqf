
#include "definitions.h"


params ["_unit"];

if (_unit != player) exitWith {};

if !(player diarySubjectExists "Readme") then 
{
	player createDiarySubject ["Readme","Your abilities"];
	player setDiarySubjectPicture ["Readme","Your abilities"];
};

player createDiaryRecord ["Readme", ["Persistent Loadout", "<br/>Your loadout is constantly saved and will be restored upon respawn.<br/><br/>That means you will need to find ways to replenish consumables such as ammo, grenades and medkits.<br/><br/>"]];


[] spawn {
	while {sleep 1; true} do {
		if (alive player && !(player getVariable ["vn_revive_incapacitated", false]) && typeOf player != "VirtualCurator_F") then {
			[player, [missionNameSpace, DEF_LOADOUT_NAME]] call BIS_fnc_saveInventory;
		};
	};
};

private _returnLoadout = {
	params ["_unit"];
	[_unit, [missionNameSpace, DEF_LOADOUT_NAME], []] call BIS_fnc_loadInventory;
	
	//-- This makes sense only if "goko_bi_patched" addon is installed 
	//-- Prevents the hat being shot off the head
	_unit setVariable ["goko_blacklisted", true, true];
};

//-- "Respawn" EH is persisted across multiple respawns
_unit addEventHandler ["Respawn", _returnLoadout];
