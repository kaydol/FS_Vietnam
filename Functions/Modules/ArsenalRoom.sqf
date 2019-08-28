params ["_roomPos", "_allowAll", "_respawnLoadout", "_playMusic", "_aceCompatibility"];

if (vehicle player != player) exitWith {};

if ( _aceCompatibility ) then {
	ace_hearing_disableVolumeUpdate = true; // thanks ACE devs for this
};

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

['Open', _allowAll] call BIS_fnc_Arsenal;

if ( _playMusic ) then {
	playMusic selectRandom ["arsenal_1", "arsenal_2", "arsenal_3", "arsenal_4", "arsenal_5"];
};

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



if ( _playMusic ) then {
	_aceCompatibility spawn {
		3 fadeMusic 0;
		sleep 3;
		playMusic "";
		0 fadeMusic 0.5;
		if ( _this ) then {
			ace_hearing_disableVolumeUpdate = false; // thanks ACE devs for this
		};
	};
};
enableRadio True;



/* Old ver

params ["_roomPos", "_allowAll", "_playMusic", "_aceCompatibility"];

if (vehicle player != player) exitWith {};

if ( _aceCompatibility ) then {
	ace_hearing_disableVolumeUpdate = true; // thanks ACE devs for this
};

startLoadingScreen ["Loading Arsenal..."];

player setVariable ["UsesArsenalRoom", True, True];
_returnPos = getPos player;
_returnDir = getDir player;

player hideObjectGlobal True; 
player hideObject False;

player setPosASL (_roomPos vectorAdd [-1.254,0.838,-3.53162]);
player setDir 129.864;

endLoadingScreen;

sleep 0.001;

enableRadio False; 

['Open', _allowAll] call BIS_fnc_Arsenal;

if ( _playMusic ) then {
	playMusic selectRandom ["arsenal_1", "arsenal_2", "arsenal_3", "arsenal_4", "arsenal_5"];
};

waitUntil {!isNull (uinamespace getvariable ["BIS_fnc_arsenal_cam",objnull])};

0 cutText ["", "BLACK IN", 4, True, False];

sleep 0.5; 
player switchMove "AmovPercMstpSlowWrflDnon";

waitUntil {isNull (uinamespace getvariable ["BIS_fnc_arsenal_cam",objnull])};

startLoadingScreen ["Exiting Arsenal..."];

[player, [missionNameSpace, "FS_PLAYER_LOADOUT"]] call BIS_fnc_saveInventory;

waitUntil { preloadCamera _returnPos };

progressLoadingScreen 0.7; 

player setPos _returnPos;
player setDir _returnDir;

player hideObjectGlobal False;
player setVariable ["UsesArsenalRoom", False, True];

endLoadingScreen;

0 cutText ["", "BLACK IN", 4, True, False];

if ( _playMusic ) then {
	_aceCompatibility spawn {
		3 fadeMusic 0;
		sleep 3;
		playMusic "";
		0 fadeMusic 0.5;
		if ( _this ) then {
			ace_hearing_disableVolumeUpdate = false; // thanks ACE devs for this
		};
	};
};
enableRadio True;

sleep 2;

["RespawnAdded", ["Loadout saved", "You will respawn with the current loadout", "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\instructor_ca.paa"]] call BIS_fnc_showNotification;



*/

