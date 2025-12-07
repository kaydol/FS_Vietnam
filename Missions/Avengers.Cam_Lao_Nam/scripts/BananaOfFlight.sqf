

#include "definitions.h"


#define DEF_MAGAZINES_THAT_GRANT_PERK []
#define DEF_ITEMS_THAT_GRANT_PERK ["ACE_Banana"]
#define DEF_NOUN_IN_SERVERWIDE_ANNOUNCEMENT "%1 eats %2!"

#define DEF_PERK_ACTIVATED_STR "Gives 60 seconds of godmode"
#define DEF_PERK_DEACTIVATED_STR "Quitting your banana addiction? GOOD."

#define DEF_ACTION_CONDITION "!(_this getVariable ['vn_revive_incapacitated', false])"

#define DEF_ACTION_DESCRIPTION "Eat banana..."
#define DEF_ACTION_ID_VAR "EatBananaActionId"
#define DEF_ACTION_ICON "a3\ui_f\data\igui\cfg\holdactions\holdaction_takeoff2_ca.paa"
#define DEF_ACTION_SOUND ""


#define DEF_DEBUG true 

params ["_unit"];

if (_unit != player) exitWith {};


if !(player diarySubjectExists "Readme") then 
{
	player createDiarySubject ["Readme","Your abilities"];
	player setDiarySubjectPicture ["Readme","Your abilities"];
};

player createDiaryRecord ["Readme", ["Banana Lover", format ["<br/>Keep an eye out for %1.<br/><br/>It fills your bowels with butterflies!<br/><br/>Can not be opened while incapacitated.<br/><br/>The item is consumed upon usage.<br/><br/>", DEF_MAGAZINES_THAT_GRANT_PERK apply {gettext (configfile >> "CfgMagazines" >> _x >> "displayName")}]]];



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
			
			[parseText format ["<t font='PuristaBold' size='1.6' color='#FFA500' >%2</t><br />%1", DEF_PERK_ACTIVATED_STR, gettext (configfile >> "CfgMagazines" >> _magazine >> "displayName")], true, nil, 7, 0.7, 0] spawn BIS_fnc_textTiles;
			
			#include "BananaOfFlight.h"
			
			_unit call _fnc_addAction;
			
		};
		if (count _consumables <= 0 && !isNil{ _unit getVariable DEF_ACTION_ID_VAR }) then 
		{
			private _magazine = _magazines select 0;
		
			[parseText format ["<t font='PuristaBold' size='1.6' color='#FFA500' >%2</t><br />%1", DEF_PERK_DEACTIVATED_STR, gettext (configfile >> "CfgMagazines" >> _magazine >> "displayName")], true, nil, 7, 0.7, 0] spawn BIS_fnc_textTiles; 
			
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
			
			#include "BananaOfFlight.h"
			
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




	



