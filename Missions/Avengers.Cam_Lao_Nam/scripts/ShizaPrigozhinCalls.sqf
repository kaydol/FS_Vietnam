
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

sleep 60;

//-- Support calls 
[_fnc_getName, _fnc_getAvatar, _fnc_phoneCall] spawn 
{
	params ["_fnc_getName", "_fnc_getAvatar", "_fnc_phoneCall", "_isTransmitting"];
	
	while {true} do 
	{
		waitUntil { sleep 0.5; _isTransmitting = (player getVariable ["BIS_SUPP_selectedProvider", objNull]) getVariable ["BIS_SUPP_supporting", false]; _isTransmitting };
		
		private _array = [
			[7, "support_call_1", 28],
			[7, "support_call_2", 18]
		];
		
		(selectRandom _array) params ["_ringtoneLength", "_sound", "_totalCallLength"];
		
		[call _fnc_getName, call _fnc_getAvatar, _ringtoneLength, _sound, _totalCallLength] call _fnc_phoneCall;
		
		waitUntil {sleep 1; _isTransmitting = (player getVariable ["BIS_SUPP_selectedProvider", objNull]) getVariable ["BIS_SUPP_supporting", false]; !_isTransmitting };
	};
};

private _array = [
	[7, "shiza_introduction", 24, 100],
	[3, "shiza_1", 33, 30],
	[4, "shiza_2", 34, 10],
	[3, "shiza_3", 14, 300],
	[3, "shiza_4", 33, 400],
	[2, "shiza_5", 56, 400],
	[4, "shiza_6", 56, 400],
	[3, "shiza_7", 33, 400],
	[3, "shiza_8", 24, 400],
	[4, "shiza_9", 73, 400],
	[4, "shiza_10", 75, 400],
	[4, "end_of_russia", 76, 400]
];

private _i = -1;

while { true } do 
{
	if (!alive player || (player getVariable ["vn_revive_incapacitated", false]) || typeOf player == "VirtualCurator_F" ) then {
		sleep 30;
	}
	else 
	{
		_i = (_i + 1) % count _array;
		(_array # _i) params ["_ringtoneLength","_sound","_totalCallLength","_sleep"];
		
		[call _fnc_getName, call _fnc_getAvatar, _ringtoneLength, _sound, _totalCallLength] call _fnc_phoneCall;
		
		sleep _sleep;
	};
};



