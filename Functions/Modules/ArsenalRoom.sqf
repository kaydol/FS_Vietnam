params ["_roomPos", "_allowAll", "_respawnLoadout", "_playMusic", "_aceCompatibility"];

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

_playerPosInRoom = [3.06543,2.78906,1.64733];
_playerDirInRoom = 111.968;

player setPosASL (_roomPos vectorAdd _playerPosInRoom);
player setDir _playerDirInRoom;

endLoadingScreen;

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

waitUntil { preloadCamera _returnPos };

progressLoadingScreen 0.7; 

player setPos _returnPos;
player setDir _returnDir;

player hideObjectGlobal False;
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

