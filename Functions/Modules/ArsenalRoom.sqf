
#include "..\..\definitions.h"

_this spawn {

	params ["_roomPos", "_allowAll", "_respawnLoadout", "_respawnLoadoutMsgStyle"];

	if (vehicle DEF_CURRENT_PLAYER != DEF_CURRENT_PLAYER || DEF_CURRENT_PLAYER isKindOf "VirtualCurator_F") exitWith {};

	waitUntil {time > 0 && !isNull DEF_CURRENT_PLAYER};

	DEF_CURRENT_PLAYER setVariable ["UsesArsenalRoom", True, True];

	enableRadio False; 

	"ArsenalRoom" cutText ["", "BLACK", 0.00001, true];
	DEF_CURRENT_PLAYER allowDamage false;

	if (isMultiplayer) then {
		sleep 1; // If you don't do that in multiplayer, Arsenal will fail with BIS_fnc_SetIdentity "unit can't be null" error
	};

	private _returnPos = getPosATL DEF_CURRENT_PLAYER;
	private _returnDir = getDir DEF_CURRENT_PLAYER;

	private _getPlayerShiftBasedOnGUID = {
		params ["_beginPos", "_guid"];
		private _i = _guid % 8;
		private _j = floor ( _guid / 8 ); 
		private _stepI = 1.7;
		private _stepJ = -3.8;
		private _shiftedPos = +_beginPos;
		_shiftedPos set [0, ( _beginPos # 0 ) + _i * _stepI]; 
		_shiftedPos set [1, ( _beginPos # 1 ) + _j * _stepJ]; 
		_shiftedPos set [2, _beginPos # 2]; 
		_shiftedPos
	};

	/* Test
	[getPos player] spawn 
	{
		for [{_i = 0},{_i < 20},{_i = _i + 1}] do {
			_playerPos = [[0,0,0], _i] call _getPlayerShiftBasedOnGUID;
			systemCHat str _playerPos;
			_sPos = (_this # 0) vectorAdd _playerPos;
			_s = "VR_3DSelector_01_Incomplete_F" createVehicle _sPos;
			_s setPos _sPos;
		};
	};
	*/

	private _playerPosInRoom = [[-3.00293,-22.9119,0.00143862], clientOwner % 40] call _getPlayerShiftBasedOnGUID;
	private _playerDirInRoom = 180.0;

	DEF_CURRENT_PLAYER setPosASL ( _roomPos vectorAdd _playerPosInRoom );
	DEF_CURRENT_PLAYER setDir _playerDirInRoom;

	/*
		A workaround to prevent replacing player's gear with random shit if the module is run
		in a freshly created mission right after mission start. We save player's gear and then
		immediately load it after the Virtual Arsenal opens.
	*/
	[] spawn {
		[DEF_CURRENT_PLAYER, [missionNameSpace, "FS_PLAYER_LOADOUT"]] call BIS_fnc_saveInventory;
		waitUntil {!isNull (uinamespace getvariable ["BIS_fnc_arsenal_cam",objnull])};
		[DEF_CURRENT_PLAYER, [missionNameSpace, "FS_PLAYER_LOADOUT"]] call BIS_fnc_LoadInventory;
	};

	['Open', _allowAll] call BIS_fnc_Arsenal;


	waitUntil {!isNull (uinamespace getvariable ["BIS_fnc_arsenal_cam",objnull])};
	/*
	_cam = uinamespace getvariable "BIS_fnc_arsenal_cam";
	_cam camSetTarget player;
	_cam camSetRelPos [0,3.5,1.2];
	_cam camSetTarget objNull;
	_cam camSetFov 0.85;
	_cam camCommit 0;
	*/

	"ArsenalRoom" cutText ["", "BLACK IN", 4, True, False];

	sleep 0.5; 
	DEF_CURRENT_PLAYER switchMove "";

	waitUntil {isNull (uinamespace getvariable ["BIS_fnc_arsenal_cam",objnull])};

	DEF_CURRENT_PLAYER setPosATL _returnPos;
	DEF_CURRENT_PLAYER setDir _returnDir;
	DEF_CURRENT_PLAYER allowDamage true;

	DEF_CURRENT_PLAYER setVariable ["UsesArsenalRoom", False, True];

	"ArsenalRoom" cutText ["", "BLACK IN", 4, True, False];

	if ( _respawnLoadout ) then {
		[DEF_CURRENT_PLAYER, [missionNameSpace, "FS_PLAYER_LOADOUT"]] call BIS_fnc_saveInventory;
		if (isNil{missionNameSpace getVariable "FS_PLAYER_LOADOUT_HANDLER"}) then {
			private _id = DEF_CURRENT_PLAYER addMPEventHandler ["MPRespawn", {
				params ["_unit", "_corpse"];
				[DEF_CURRENT_PLAYER, [missionNameSpace, "FS_PLAYER_LOADOUT"]] call BIS_fnc_LoadInventory;
			}];
			missionNameSpace setVariable ["FS_PLAYER_LOADOUT_HANDLER", _id];
		};
		_respawnLoadoutMsgStyle spawn {
			sleep 2;
			switch (_this) do {
				case 0: {
					["RespawnAdded", ["Loadout saved", "You will respawn with the current loadout", "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\instructor_ca.paa"]] call BIS_fnc_showNotification; 
				};
				case 1: {
					[parseText format ["<t font='PuristaBold' size='1.6' color='#FFA500' >%2</t><br />%1",gettext (configfile >> "CfgWeapons" >> currentweapon DEF_CURRENT_PLAYER >> "displayName"),"LOADOUT SAVED"], true, nil, 7, 0.7, 0] spawn BIS_fnc_textTiles; 
				};
				default {};
			};
		};
	};

	enableRadio True;
};