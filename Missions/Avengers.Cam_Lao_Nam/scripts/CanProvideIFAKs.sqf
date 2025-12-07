
#define DEF_IFAKS_TO_RESTORE 2
#define DEF_IFAK_CLASS "vn_b_item_firstaidkit"
#define DEF_ABILITY_COOLDOWN 240
#define DEF_ABILITY_RADIUS 10
#define DEF_CD_GLOBAL_VARIABLE Team_IFAKRestock_CoolDown
#define DEF_ACTION_ID_GLOBAL_VARIABLE Team_IFAKRestock_ActionId
#define DEF_ACTION_TEXT "Restock IFAKs"
#define DEF_ACTION_DESCRIPTION "When activated, restock IFAKs to self and allies nearby"
#define DEF_SYSTEMCHAT_EFFECT_RECEIVED "IFAKs have been restocked"
#define DEF_ACTION_SOUND "item_picked_up"

params ["_unit"];


if (_unit != player) exitWith {};


private _fnc_getAffectedAmount = {
	params ["_target"];
	{alive _x && _x distance _target < DEF_ABILITY_RADIUS} count (units group _target) 
};


private _fnc_updateActionText = {
	params ["_target", "_actionId"];
	/*
	object: Object - object the action is added to
	actionIndex: Number - action id returned by addAction
	textMenu: String or Structured Text - text title shown in scroll action menu
	textWindowBackground: String or Structured Text - (Optional, default "") background text
	textWindowForeground: String or Structured Text - (Optional, default "") foreground text
	*/
	private _actionText = format ["<t size='2.0' color='#00ff00'>%1</t> <t size='2.0' color='#ff0000'>%2</t>", DEF_ACTION_TEXT, player call _fnc_getAffectedAmount];
	_target setUserActionText [_actionId, _actionText, "", _actionText]; 
};


private _fnc_addAction = {
	
	params ["_unit", ["_corpse", objNull]];


	private _fnc_actionCondition = '{
		params ["_unit"];
		
		private _isIncapacitated = _unit getVariable ["vn_revive_incapacitated", false];
		
		!_isIncapacitated && DEF_CD_GLOBAL_VARIABLE <= 0
	}';


	private _fnc_action = {

		params ["_target", "_caller", "_actionId", "_arguments"];
		
		//-------------------------------
		
		private _affected = (units group _target) select {alive _x && _x distance _target < DEF_ABILITY_RADIUS};
		
		{
			for "_i" from 1 to DEF_IFAKS_TO_RESTORE do { _x addItem DEF_IFAK_CLASS };	
		}
		forEach _affected;
		
		//-------------------------------
		
		DEF_CD_GLOBAL_VARIABLE = DEF_ABILITY_COOLDOWN;
		
		[[_caller, DEF_ACTION_SOUND],{
			params ["_caller", "_sound"];
			_caller say3D _sound;
			["RespawnAdded", ["Perk Activated", DEF_SYSTEMCHAT_EFFECT_RECEIVED, '\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\instructor_ca.paa']] call BIS_fnc_showNotification;
			//systemChat format ["Perk Activated: %1 - %2", DEF_ACTION_TEXT, DEF_SYSTEMCHAT_EFFECT_RECEIVED];
		}] remoteExec ["call", 0];
		
		
	};
	
	
	if (DEF_ACTION_ID_GLOBAL_VARIABLE >= 0 && !(isNull _corpse)) then {
		_corpse removeAction DEF_ACTION_ID_GLOBAL_VARIABLE;
		DEF_ACTION_ID_GLOBAL_VARIABLE = -1;
	};

	private _id = _unit addAction ["", _fnc_action, [], 0, false, true, "", format ["alive _originalTarget && player call %1", _fnc_actionCondition]];
	DEF_ACTION_ID_GLOBAL_VARIABLE = _id;
};


DEF_ACTION_ID_GLOBAL_VARIABLE = -1;

//-- "Respawn" EH is persisted across multiple respawns
_unit addEventHandler ["Respawn", _fnc_addAction];

//-- If respawn on start is disabled, manually add action on mission start
if (getNumber(missionConfigFile >> "respawnOnStart") <= 0) then {
	[_unit] call _fnc_addAction;
};


DEF_CD_GLOBAL_VARIABLE = 3;
while {true} do 
{
	if (alive player && DEF_CD_GLOBAL_VARIABLE > 0) then {
		DEF_CD_GLOBAL_VARIABLE = DEF_CD_GLOBAL_VARIABLE - 1;
	};
	
	if (DEF_CD_GLOBAL_VARIABLE == 1) then 
	{
		["RespawnAdded", [format ["Perk: %1", DEF_ACTION_TEXT], DEF_ACTION_DESCRIPTION, '\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\instructor_ca.paa']] call BIS_fnc_showNotification;
		//systemChat format ["New Perk: %1 - %2", DEF_ACTION_TEXT, DEF_ACTION_DESCRIPTION];
	};
	
	if (DEF_CD_GLOBAL_VARIABLE <= 0) then 
	{
		WaitUntil { sleep 1; [player, DEF_ACTION_ID_GLOBAL_VARIABLE] call _fnc_updateActionText; DEF_CD_GLOBAL_VARIABLE > 0 };
		
	};
	
	sleep 1;
};











