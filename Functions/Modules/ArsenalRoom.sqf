params ["_roomPos", "_allowAll", "_respawnLoadout"];

if (vehicle player != player) exitWith {};

//startLoadingScreen ["Loading Arsenal..."];

player setVariable ["UsesArsenalRoom", True, True];
_returnPos = getPos player;
_returnDir = getDir player;

sleep 0.001;

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

_playerPosInRoom = [[-3.00293,-22.9119,0.00143862], clientOwner % 40] call _getPlayerShiftBasedOnGUID;
_playerDirInRoom = 180.0;

player setPosASL ( _roomPos vectorAdd _playerPosInRoom );
player setDir _playerDirInRoom;

//endLoadingScreen;

sleep 0.001;

enableRadio False; 

if ( time < 1 ) then 
{
	/*
		A workaround to prevent replacing player's gear with random shit if the module is run
		in a freshly created mission right after mission start. We save player's gear and then
		immediately load it after the Virtual Arsenal opens.
	*/
	[] spawn {
		[player, [missionNameSpace, "FS_PLAYER_LOADOUT"]] call BIS_fnc_saveInventory;
		waitUntil {!isNull (uinamespace getvariable ["BIS_fnc_arsenal_cam",objnull])};
		[player, [missionNameSpace, "FS_PLAYER_LOADOUT"]] call BIS_fnc_LoadInventory;
	};
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
0 cutText ["", "BLACK IN", 4, True, False];

sleep 0.5; 
player switchMove "";

waitUntil {isNull (uinamespace getvariable ["BIS_fnc_arsenal_cam",objnull])};

startLoadingScreen ["Exiting Arsenal..."];

//waitUntil { preloadCamera _returnPos };

progressLoadingScreen 0.7; 

player setPos _returnPos;
player setDir _returnDir;

player setVariable ["UsesArsenalRoom", False, True];

endLoadingScreen;

0 cutText ["", "BLACK IN", 4, True, False];

if ( _respawnLoadout ) then {
	[player, [missionNameSpace, "FS_PLAYER_LOADOUT"]] call BIS_fnc_saveInventory;
	player addMPEventHandler ["MPRespawn", {
		params ["_unit", "_corpse"];
		[player, [missionNameSpace, "FS_PLAYER_LOADOUT"]] call BIS_fnc_LoadInventory;
	}];
	[] spawn {
		sleep 2;
		["RespawnAdded", ["Loadout saved", "You will respawn with the current loadout", "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\instructor_ca.paa"]] call BIS_fnc_showNotification;
	};
};

enableRadio True;
