
/*
	This is a redefine of vn_fnc_music function from SOG CDLC 
	I wanted to have a custom song list for each vehicle type 
*/

#define DEF_DEBUG false  
#define DEF_CONFIG missionConfigFile
//#define DEF_CONFIG configFile

private _hashMap = createHashMapFromArray [
	[toLowerANSI "vnx_o_wheeled_tuktuk_01_vc",["radio_tuk_tuk"]]
];

disableSerialization;

params
[
	["_mode","",[""]],
	["_params",[],[[]]]
];

switch (tolower _mode) do
{
	case ("open"):
	{
		private _player = call vn_fnc_player;
		private _vehicle = vehicle _player;
		if (!(_vehicle isEqualTo _player) && {local _vehicle && !(isNull (findDisplay 46))}) then
		{
			closeDialog 2;
			createDialog "vn_displayvehiclemusic";
		};
	};
	case ("onload"):
	{
		((uiNamespace getVariable ["vn_displayvehiclemusic",displayNull]) displayCtrl 1001) ctrlEnable false;
		
		private _player = call vn_fnc_player;
		private _vehicle = vehicle _player;
		private _time = [time, serverTime] select isMultiplayer;

		lbClear ((uiNamespace getVariable ["vn_displayvehiclemusic",displayNull]) displayCtrl 1000);
		
		private _music_list = [];
		private _key = toLowerANSI typeOf _vehicle;
		
		if (_key in _hashMap) then {
			_music_list = _music_list + (_hashMap get _key);
			if (DEF_DEBUG) then {
				diag_log format ["vn_fnc_music: %1", _hashMap get _key];
			};
		} else {
			if (DEF_DEBUG) then {
				diag_log format ["vn_fnc_music: %1 not in %2", typeOf _vehicle, keys _hashMap];
			};
		};
		
		{
			private _config = (DEF_CONFIG >> "cfgsounds" >> _x);
			private _name = getText (_config >> "name");
			private _duration = getNumber (_config >> "duration");
			private _minutes =  floor (_duration / 60);
			private _seconds = _duration % 60;
			if (_seconds < 10) then {_seconds = "0" + str _seconds};
			private _text = "%1";
			if (_duration > 0 && {_minutes > 0}) then {_text = "%2:%1";};
			private _index = ((uiNamespace getVariable ["vn_displayvehiclemusic",displayNull]) displayCtrl 1000) lnbAddRow [_name, format[_text, _seconds, _minutes]];
			((uiNamespace getVariable ["vn_displayvehiclemusic",displayNull]) displayCtrl 1000) lnbSetData [[_index, 0], _x];
		} foreach _music_list;

		((uiNamespace getVariable ["vn_displayvehiclemusic",displayNull]) displayCtrl 1001) ctrlSetText localize "STR_A3_STOP";
		((uiNamespace getVariable ["vn_displayvehiclemusic",displayNull]) displayCtrl 1001) ctrlAddEventHandler ["ButtonDown",{
			private _player = call vn_fnc_player;
			private _vehicle = vehicle _player;
			[_vehicle] remoteExec ["vn_fnc_music_stop",0];
		}];
		
		((uiNamespace getVariable ["vn_displayvehiclemusic",displayNull]) displayCtrl 1001) ctrlEnable true;

		((uiNamespace getVariable ["vn_displayvehiclemusic",displayNull]) displayCtrl 1000) ctrlAddEventHandler ["LBSelChanged", {
			params ["_ctrl","_index"];
			private _player = call vn_fnc_player;
			private _vehicle = vehicle _player;
			private _time = [time, serverTime] select isMultiplayer;

			if (_vehicle getVariable ["vn_music_last", 0] <= _time) then
			{
			_vehicle setVariable ["vn_music_last", _time + 1];

			[_vehicle] remoteExec ["vn_fnc_music_stop",0];

			[_index, _vehicle] spawn
			{
			params ["_index", "_vehicle"];
			sleep 0.5;
			private _config = (DEF_CONFIG >> "cfgsounds" >> (((uiNamespace getVariable ["vn_displayvehiclemusic",displayNull]) displayCtrl 1000) lnbData [_index, 0]));


			if (isNull _vehicle || isNull _config) exitWith {};
			if (!isClass _config) exitWith {};
			if (configName _config == "") exitWith {};

			["play", [configName _config, _vehicle]] call vn_fnc_music;
			};
			};
		}];
	};
	case ("play"):
	{
		_params params ["_configname", "_vehicle"];


		if (isNull _vehicle || _configname == "") exitWith {};
		if (!isClass (DEF_CONFIG >> "CfgSounds" >> _configname) && {!isClass (missionConfigFile >> "CfgSounds" >> _configname)}) exitWith {};

		[_vehicle,_configname] remoteExec ["vn_fnc_music_play",0];
	};
};
true
