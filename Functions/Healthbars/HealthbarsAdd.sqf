
#include "..\..\definitions.h"

#define DEF_RSC_TITLE "FS_HealthBar_HUD"
#define DEF_RSC_PROGRESS "FS_HealthBar_HUD_RscProgress"
#define DEF_HEALTHBARS_CTRL_IDD "FS_Healthbars_Ctrl"

if (!hasInterface) exitWith {};

params ["_unit", ["_debug", true]];

disableSerialization;

if (_debug) then {
	diag_log format ["(Machine @ %1) Adding healthbar on unit (%2 @ %3)", clientOwner, _unit, owner _unit];
};

if ( isNull _unit ) exitWith {};

//_respHandler = _unit addEventHandler ["Respawn", {
//	params ["_unit", "_corpse"];
//	_corpse spawn FS_fnc_HealthbarsRemove;
//	_unit spawn FS_fnc_HealthbarsAdd;
//}];
//_unit setVariable ["FS_Healthbars_RespHandler", _respHandler];


_unit call FS_fnc_HealthbarsRemove;

private _display = uiNamespace getVariable [DEF_RSC_TITLE, displayNull];
private _ctrl_idd = 10000 + (round random 10000);
_unit setVariable [DEF_HEALTHBARS_CTRL_IDD, _ctrl_idd];
private _ctrl = _display ctrlCreate [DEF_RSC_PROGRESS, _ctrl_idd];
	_ctrl ctrlShow false;
	
addMissionEventHandler ["Draw3D", 
{
	_thisArgs params ["_unit"];
	disableSerialization;
	
	private _display = uiNamespace getVariable [DEF_RSC_TITLE, displayNull];
	private _ctrl = _display displayCtrl ( _unit getVariable DEF_HEALTHBARS_CTRL_IDD );
	private _pos = worldToScreen( visiblePosition _unit );
	
	if ( count _pos > 0 ) then 
	{
		private _dmg = selectMax ((getAllHitPointsDamage _unit) # 2);
		private _canSee = ( [(missionNameSpace getVariable ["bis_fnc_moduleRemoteControl_unit", DEF_CURRENT_PLAYER]), "VIEW", _unit] checkVisibility [eyePos DEF_CURRENT_PLAYER, eyePos DEF_CURRENT_PLAYER] ) > 0.3;
		
		if ( _canSee ) then 
		{
			private _color = [1,1,1,1];
			if(_dmg <= 0.25) then {_color = [0,0.5,0,1];};
			if(_dmg > 0.25 && damage _unit < 0.6) then {_color = [1,1,0,1];};
			if(_dmg >= 0.6) then {_color = [1,0,0,1];};
			if (!isDamageAllowed _unit) then {_color = [0.3,0.3,1,1];};
			
			private _mod = ( DEF_CURRENT_PLAYER distance _unit ) call FS_fnc_HealthbarsGetSize;
			_pos set [0, (_pos select 0) - 0.1 * _mod];
			_pos set [1, (_pos select 1) + 0.001 * _mod];
			
			_ctrl progressSetPosition (1 - _dmg);
			_ctrl ctrlSetTextColor _color;
			_ctrl ctrlSetPosition _pos;
			_ctrl ctrlSetScale _mod;
			_ctrl ctrlSetFade 0;
			_ctrl ctrlCommit 0;
			_ctrl ctrlShow true;
		} 
		else 
		{
			_ctrl ctrlShow false;
		};
	} 
	else 
	{
		_ctrl ctrlShow false;
	};
	
	if (isNil{_unit}) then 
	{
		ctrlDelete _ctrl;
		removeMissionEventHandler ["Draw3D", _thisEventHandler];
	}
	else 
	{
		if (isNull _unit) then 
		{
			ctrlDelete _ctrl;
			removeMissionEventHandler ["Draw3D", _thisEventHandler];
		};
	};
}, [_unit]];
