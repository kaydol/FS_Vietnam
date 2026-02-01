
#include "ShizaDefinitions.hpp"

#define DEF_SCRIPT_NAME "RscPrigozhinCalls"
#define DEF_FNC_NAME_IN_MISSION_DESCRIPTION RscPrigozhinCalls_fn
#define DEF_FNC_DATA_VARIABLE RscPrigozhinCalls_data
#define DEF_LAST_CALLED_AT "RscPrigozhinCalls_LastCallTime"
#define DEF_RSC_LAYER_NAME "Shiza"
#define DEF_GLOBAL_MUTEX RscPrigozhinCalls_inProgress


DEF_FNC_NAME_IN_MISSION_DESCRIPTION = compile preprocessFileLineNumbers "eugene_my_beloved\RscPrigozhinCalls.sqf";
DEF_GLOBAL_MUTEX = false;

_fnc_getName = {
	"Evgeniy Victorovich"
};

_fnc_getAvatar = {
	private _pfps = [
		"phone_call_avatar_1", "phone_call_avatar_2", "phone_call_avatar_3", "phone_call_avatar_4", 
		"phone_call_avatar_5", "phone_call_avatar_6", "phone_call_avatar_7"
	];
	
	(format ["eugene_my_beloved\%1.paa", selectRandom _pfps])
};

_fnc_phoneCall = {
	params ["_name","_avatar","_ringtoneLength","_sound","_totalCallLength"];
	
	waitUntil {sleep 1; !DEF_GLOBAL_MUTEX};
	DEF_GLOBAL_MUTEX = true;
	
	DEF_FNC_DATA_VARIABLE = [_name,_avatar,_ringtoneLength,_sound,_totalCallLength];
	(DEF_RSC_LAYER_NAME call BIS_fnc_rscLayer) cutRsc [DEF_SCRIPT_NAME, "PLAIN"];
	playSound _sound;
	sleep _totalCallLength;
	(DEF_RSC_LAYER_NAME call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
	DEF_GLOBAL_MUTEX = false;
};

params ["_unit"];

if (_unit != player) exitWith {};

waitUntil { sleep 1; !dialog };

sleep 1;

private _perkName = "Shiza";
private _perkDescription = "You can hear the ghosts of the past long gone";

["RespawnAdded",[format ["Perk : %1",_perkName],_perkDescription,"\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\instructor_ca.paa"]] call BIS_fnc_showNotification;
//systemChat format ["New Perk: %1 - %2",_perkName, _perkDescription];


//-- Support calls 
[_fnc_getName, _fnc_getAvatar, _fnc_phoneCall] spawn 
{
	params ["_fnc_getName", "_fnc_getAvatar", "_fnc_phoneCall", "_isTransmitting"];
	
	private _firstTime = true;
	
	while {true} do 
	{
		waitUntil { sleep 0.5; _isTransmitting = (player getVariable ["BIS_SUPP_selectedProvider", objNull]) getVariable ["BIS_SUPP_supporting", false]; _isTransmitting };
		
		private _array = [
			[7, "eugene_first_support_call", 28, {_firstTime}],
			[7, "eugene_shas_bombanu", 12, {true}]
		];
		
		private _available = _array select { [] call (_x # 3) }; 
		
		(selectRandom _available) params ["_ringtoneLength", "_sound", "_totalCallLength"];
		
		[call _fnc_getName, call _fnc_getAvatar, _ringtoneLength, _sound, _totalCallLength] call _fnc_phoneCall;
		
		_firstTime = false;
		
		waitUntil {sleep 1; _isTransmitting = (player getVariable ["BIS_SUPP_selectedProvider", objNull]) getVariable ["BIS_SUPP_supporting", false]; !_isTransmitting };
	};
};


sleep 60;

private _array = [
	[3, "eugene_will_visit_in_person", 14, 100, { !isNil{ missionNameSpace getVariable DEF_SHIZA_FIRST_RUN_VAR }}]
];

private _i = -1;

while { _i + 1 < count _array } do 
{
	if (!alive player || (player getVariable ["vn_revive_incapacitated", false]) || typeOf player == "VirtualCurator_F" ) then {
		sleep 30;
	}
	else 
	{
		_i = (_i + 1) % count _array;
		(_array # _i) params ["_ringtoneLength","_sound","_totalCallLength","_sleep", "_conditionToSkip"];
		
		if !([] call _conditionToSkip) then {
			[call _fnc_getName, call _fnc_getAvatar, _ringtoneLength, _sound, _totalCallLength] call _fnc_phoneCall;
			sleep _sleep;
		};
	};
};

diag_log format ["(ShizaPrigozhinCalls.sqf): All calls were played, exiting..."];

