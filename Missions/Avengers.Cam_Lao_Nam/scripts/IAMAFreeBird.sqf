

#include "definitions.h"


#define DEF_MAGAZINES_THAT_GRANT_PERK ["vn_prop_drink_07_01", "vn_prop_drink_07_03"]
#define DEF_ITEMS_THAT_GRANT_PERK []
#define DEF_NOUN_IN_SERVERWIDE_ANNOUNCEMENT "%1 opened %2!"

#define DEF_PERK_ACTIVATED_STR "Use this as a last resort..."
#define DEF_PERK_DEACTIVATED_STR "Clearly, you can manage WITHOUT it."

#define DEF_ACTION_CONDITION "_this getVariable ['vn_revive_incapacitated', false]"

#define DEF_ACTION_DESCRIPTION "Open the bottle..."
#define DEF_ACTION_ID_VAR "OpenTheBottleActionId"
#define DEF_ACTION_ICON "a3\ui_f\data\igui\cfg\actions\obsolete\ui_action_fire_in_flame_ca.paa"
#define DEF_ACTION_SOUND "open_bottle"

#define DEF_MODULE_CLASSNAME "FS_NapalmCAS_Module"
#define DEF_HANDLER_VAR "custom_fired_napalm_eh"
#define DEF_UNIT_ATTACH_TO [0,-20,5]
#define DEF_SOUND ""
#define DEF_OLD_UNIT "old_unit"
#define DEF_VIRTUAL_UNIT "VirtualCurator_F"

#define DEF_DEBUG true 

params ["_unit"];

if (_unit != player) exitWith {};


if !(player diarySubjectExists "Readme") then 
{
	player createDiarySubject ["Readme","Your abilities"];
	player setDiarySubjectPicture ["Readme","Your abilities"];
};

private _displayNames = [];
{_displayNames pushBack _x} forEach ((DEF_MAGAZINES_THAT_GRANT_PERK apply {gettext (configfile >> "CfgMagazines" >> _x >> "displayName")}) + (DEF_ITEMS_THAT_GRANT_PERK apply {gettext (configfile >> "CfgWeapons" >> _x >> "displayName")}));
player createDiaryRecord ["Readme", ["Old Spice", format ["<br/>Keep an eye out for spicy food such as %1.<br/><br/>Do your best and don't eat every bottle you come across (unless the situation becomes dire, then you can eat it).<br/><br/>Can only be opened while incapacitated.<br/><br/>The item is consumed upon usage.<br/><br/>", _displayNames]]];



//-- "Respawn" EH is persisted across multiple respawns
_unit addEventHandler ["Respawn", {
	
	params ["_unit", "_corpse"];
	
	{
		private _previousAction = _x getVariable DEF_ACTION_ID_VAR;
		
		if (!isNil{_previousAction}) then {
			_x setVariable [DEF_ACTION_ID_VAR, nil];
			[_x, _previousAction] call BIS_fnc_holdActionRemove;
		};
	} forEach ([_unit, _corpse] select {!(_x isEqualTo objNull)});
	
	//-- Copy pasted -----------------------------------------
	_unit addEventHandler ["InventoryClosed", 
	{
		params ["_unit", "_targetContainer"];
		
		private _consumables = [];
		
		if (DEF_MAGAZINES_THAT_GRANT_PERK isNotEqualTo []) then 
		{
			_consumables = (DEF_MAGAZINES_THAT_GRANT_PERK apply {toLowerANSI _x}) arrayIntersect ((magazines _unit) apply {toLowerANSI _x});
		};
		
		if (DEF_ITEMS_THAT_GRANT_PERK isNotEqualTo []) then 
		{
			_consumables = (DEF_ITEMS_THAT_GRANT_PERK apply {toLowerANSI _x}) arrayIntersect ((items _unit) apply {toLowerANSI _x});
		};
		
		if (count _consumables > 0 && isNil{ _unit getVariable DEF_ACTION_ID_VAR }) then 
		{
			private _consumable = _consumables select 0;
	
			if (DEF_MAGAZINES_THAT_GRANT_PERK isNotEqualTo []) then 
			{
				[parseText format ["<t font='PuristaBold' size='1.6' color='#FFA500' >%2</t><br />%1", DEF_PERK_ACTIVATED_STR, gettext (configfile >> "CfgMagazines" >> _consumable >> "displayName")], true, nil, 7, 0.7, 0] spawn BIS_fnc_textTiles;
			};
			
			if (DEF_ITEMS_THAT_GRANT_PERK isNotEqualTo []) then 
			{
				[parseText format ["<t font='PuristaBold' size='1.6' color='#FFA500' >%2</t><br />%1", DEF_PERK_ACTIVATED_STR, gettext (configfile >> "CfgWeapons" >> _consumable >> "displayName")], true, nil, 7, 0.7, 0] spawn BIS_fnc_textTiles;
			};
			
			#include "IAMAFreeBird.h"
			
			_unit call _fnc_addAction;
			
		};
		if (count _consumables <= 0 && !isNil{ _unit getVariable DEF_ACTION_ID_VAR }) then 
		{
			private _consumable = _consumables select 0;
	
			if (DEF_MAGAZINES_THAT_GRANT_PERK isNotEqualTo []) then 
			{
				[parseText format ["<t font='PuristaBold' size='1.6' color='#FFA500' >%2</t><br />%1", DEF_PERK_ACTIVATED_STR, gettext (configfile >> "CfgMagazines" >> _consumable >> "displayName")], true, nil, 7, 0.7, 0] spawn BIS_fnc_textTiles;
			};
			
			if (DEF_ITEMS_THAT_GRANT_PERK isNotEqualTo []) then 
			{
				[parseText format ["<t font='PuristaBold' size='1.6' color='#FFA500' >%2</t><br />%1", DEF_PERK_ACTIVATED_STR, gettext (configfile >> "CfgWeapons" >> _consumable >> "displayName")], true, nil, 7, 0.7, 0] spawn BIS_fnc_textTiles;
			};
			
			private _previousAction = _unit getVariable DEF_ACTION_ID_VAR;
			if (!isNil{_previousAction}) then {
				_unit setVariable [DEF_ACTION_ID_VAR, nil];
				[_unit, _previousAction] call BIS_fnc_holdActionRemove;
			};
		};
	}];
	//-- /Copy pasted ----------------------------------------
	
}];

//-- If respawn on start is disabled, manually add action on mission start
if (getNumber(missionConfigFile >> "respawnOnStart") <= 0) then 
{
	//-- Copy pasted -----------------------------------------
	_unit addEventHandler ["InventoryClosed",
	{
		params ["_unit", "_targetContainer"];
		
		private _consumables = [];
		
		if (DEF_MAGAZINES_THAT_GRANT_PERK isNotEqualTo []) then 
		{
			_consumables = (DEF_MAGAZINES_THAT_GRANT_PERK apply {toLowerANSI _x}) arrayIntersect ((magazines _unit) apply {toLowerANSI _x});
		};
		
		if (DEF_ITEMS_THAT_GRANT_PERK isNotEqualTo []) then 
		{
			_consumables = (DEF_ITEMS_THAT_GRANT_PERK apply {toLowerANSI _x}) arrayIntersect ((items _unit) apply {toLowerANSI _x});
		};
		
		if (count _consumables > 0 && isNil{ _unit getVariable DEF_ACTION_ID_VAR }) then 
		{
			private _consumable = _consumables select 0;
		
			if (DEF_MAGAZINES_THAT_GRANT_PERK isNotEqualTo []) then 
			{
				[parseText format ["<t font='PuristaBold' size='1.6' color='#FFA500' >%2</t><br />%1", DEF_PERK_ACTIVATED_STR, gettext (configfile >> "CfgMagazines" >> _consumable >> "displayName")], true, nil, 7, 0.7, 0] spawn BIS_fnc_textTiles;
			};
			
			if (DEF_ITEMS_THAT_GRANT_PERK isNotEqualTo []) then 
			{
				[parseText format ["<t font='PuristaBold' size='1.6' color='#FFA500' >%2</t><br />%1", DEF_PERK_ACTIVATED_STR, gettext (configfile >> "CfgWeapons" >> _consumable >> "displayName")], true, nil, 7, 0.7, 0] spawn BIS_fnc_textTiles;
			};
			
			#include "IAMAFreeBird.h"
			
			_unit call _fnc_addAction;
			
		};
		if (count _consumables <= 0 && !isNil{ _unit getVariable DEF_ACTION_ID_VAR }) then 
		{
			private _consumable = _consumables select 0;
		
			if (DEF_MAGAZINES_THAT_GRANT_PERK isNotEqualTo []) then 
			{
				[parseText format ["<t font='PuristaBold' size='1.6' color='#FFA500' >%2</t><br />%1", DEF_PERK_ACTIVATED_STR, gettext (configfile >> "CfgMagazines" >> _consumable >> "displayName")], true, nil, 7, 0.7, 0] spawn BIS_fnc_textTiles;
			};
			
			if (DEF_ITEMS_THAT_GRANT_PERK isNotEqualTo []) then 
			{
				[parseText format ["<t font='PuristaBold' size='1.6' color='#FFA500' >%2</t><br />%1", DEF_PERK_ACTIVATED_STR, gettext (configfile >> "CfgWeapons" >> _consumable >> "displayName")], true, nil, 7, 0.7, 0] spawn BIS_fnc_textTiles;
			};
			
			private _previousAction = _unit getVariable DEF_ACTION_ID_VAR;
			if (!isNil{_previousAction}) then {
				_unit setVariable [DEF_ACTION_ID_VAR, nil];
				[_unit, _previousAction] call BIS_fnc_holdActionRemove;
			};
		};
	}];
	//-- /Copy pasted ----------------------------------------
};




	



