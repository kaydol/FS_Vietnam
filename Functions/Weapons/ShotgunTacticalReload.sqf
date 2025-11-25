
#include "..\..\definitions.h"

// This was taken from https://steamcommunity.com/sharedfiles/filedetails/?id=1783239696 by Rogue_THE_GAMER and then 
// 1. Adapted to be called from the R button in a very hardcoded way
// 2. Added flechettes magazine to the list of support mags 
// 3. Added individual shell insertion sound  
// 4. Now only works for weapons that have `FS_one_shell_reloadable = 1` in their config class 
// 5. Added cache to store each new weapon a player holds due to my totally unfounded concerns of slow config read time   

#define DEF_CONFIG_FLAG "FS_one_shell_reloadable"
#define DEF_RELOAD_SHELL_SOUND "FS_Vietnam\Sounds\Weapons\shotgun_insert_one_shell.ogg"
#define DEF_DEBUG false
#define DEF_ROUNDS_RELOADED_VAR "FS_ShotgunTacticalReload_RoundsReloaded"

if (!hasInterface) exitWith {};

#include "\a3\ui_f\hpp\definedikcodes.inc"

[] spawn 
{
	FS_ShotgunTacticalReload_PRESSED_R = FALSE;

	waitUntil { !isNull (findDisplay 46) };

	FS_ONE_SHELL_RELOADABLE_CACHE = createHashMap;

	FS_ShotgunTacticalReload_KeyEvents = {
		private ["_type", "_this", "_param", "_key"];
		_type = _this select 0;
		_param = _this select 1;

		_key = _param select 1;
		//PRESSED_SHIFT = _param select 2;
		//PRESSED_CTRL = _param select 3; 
		//PRESSED_ALT = _param select 4; 
		
		private _handled = false;
		
		switch (_type) do 
		{
			case "KeyDown": 
			{
				switch (_key) do 
				{
					case DIK_R: { 
						private _currentWeapon = currentWeapon DEF_CURRENT_PLAYER;
						if (_currentWeapon != "") then 
						{
							private _value = FS_ONE_SHELL_RELOADABLE_CACHE getOrDefault [_currentWeapon, -1];
							
							if (_value isEqualTo -1) then {
								_value = getNumber(ConfigFile >> "CfgWeapons" >> currentWeapon DEF_CURRENT_PLAYER >> DEF_CONFIG_FLAG);
								FS_ONE_SHELL_RELOADABLE_CACHE set [_currentWeapon, _value];
								
								if (DEF_DEBUG) then {
									diag_log format ["(ShotgunTacticalReload) New weapon added to cache %1, reloadable = %2", _currentWeapon, _value];
								};
							};
							
							FS_ShotgunTacticalReload_PRESSED_R = _value > 0;
							_handled = _value > 0;
						};
					};
				};
			};
			case "KeyUp": 
			{
				switch (_key) do 
				{
					case DIK_R: { FS_ShotgunTacticalReload_PRESSED_R = FALSE; };
				};
			};
		};
		
		_handled
	};

	(findDisplay 46) displayAddEventHandler ["KeyDown", {["KeyDown",_this] call FS_ShotgunTacticalReload_KeyEvents}];
	(findDisplay 46) displayAddEventHandler ["KeyUp", {["KeyUp",_this] call FS_ShotgunTacticalReload_KeyEvents}];

	//========================================================================================================================
	//Paste the code below inside of a gamelogic or inside the initplayer.sqf, avoid copy this comment or you will get errors.


	RTG_Shotgun_TacReloadInProgress = 0;
	RTG_Shotgun_TacReload = {
		
		private _fnc_PlayReloadSound = {
			//-- Play reload 1 shell sound globally
			if (DEF_RELOAD_SHELL_SOUND != "") then 
			{
				[[DEF_CURRENT_PLAYER, DEF_RELOAD_SHELL_SOUND], {
					params ["_speaker", "_sound"]; 
					
					private _fnc_isInside = {
						params ["_speaker", ["_distance", 2]];
						if !(_speaker isKindOf "MAN") exitWith { true };

						private _posASL = eyePos _speaker;
						private _intersections = lineIntersectsSurfaces [_posASL, [_posASL # 0, _posASL # 1, (_posASL # 2) + _distance], _speaker];
						!(_intersections isEqualTo [])
					};
					
					/*_speaker say3D [_sound, 500, 1, 0, 0, true];*/ 
					playSound3D [_sound, _speaker, _speaker call _fnc_isInside, getPosASL _speaker, 5, 10];
				}] remoteExec ["call", 0];
			};
		};
		
		if (RTG_Shotgun_TacReloadInProgress == 1) exitWith {};
		RTG_Shotgun_TacReloadInProgress = 1;
		private _shotgun = currentMuzzle DEF_CURRENT_PLAYER;
		private _oldmagazine = currentMagazine DEF_CURRENT_PLAYER;
		private _MyMags = magazinesAmmo DEF_CURRENT_PLAYER; 
		private _MyMags = _MyMags select {(currentMagazine DEF_CURRENT_PLAYER) in _x};
		private _fullMagNum = getNumber (configFile >> "CfgMagazines" >> _oldmagazine >> "count");
		private _AmmoInWeapon = DEF_CURRENT_PLAYER ammo currentMuzzle DEF_CURRENT_PLAYER;
		private _AmoutOfMags = count _MyMags;
		private _MyMagsAllAmmo = 0; 
		{_MyMagsAllAmmo = _MyMagsAllAmmo + (_x select 1)} foreach _MyMags;
		sleep 0.1;
		
		
		if (_AmmoInWeapon == _fullMagNum) exitWith {hint "Weapon already Full"; RTG_Shotgun_TacReloadInProgress = 0;};
		if (_AmoutOfMags == 0) exitWith {hint "No mags to reload"; RTG_Shotgun_TacReloadInProgress = 0;};
		
		DEF_CURRENT_PLAYER playactionNow "GestureEmpty" ;
		DEF_CURRENT_PLAYER playactionNow "GestureReloadM4SSAS";
		
		sleep 1.2;
		
		private _roundsReloaded = 0;
		
		if (_AmmoInWeapon < _fullMagNum) then {
			DEF_CURRENT_PLAYER setAmmo [_shotgun, (_AmmoInWeapon + 1)];
			_MyMagsAllAmmo = _MyMagsAllAmmo - 1;
			_AmmoInWeapon = DEF_CURRENT_PLAYER ammo currentMuzzle DEF_CURRENT_PLAYER;
			sleep 0.7;
			
			[] call _fnc_PlayReloadSound;
			_roundsReloaded = _roundsReloaded + 1;
		};
	 
		while {FS_ShotgunTacticalReload_PRESSED_R and _AmmoInWeapon < _fullMagNum and _MyMagsAllAmmo > 0} do 
		{
			_AmmoInWeapon = DEF_CURRENT_PLAYER ammo currentMuzzle DEF_CURRENT_PLAYER;
			if (_AmmoInWeapon < _fullMagNum) then {
				_MyMagsAllAmmo = _MyMagsAllAmmo - 1;
				DEF_CURRENT_PLAYER setAmmo [_shotgun, (_AmmoInWeapon + 1)];
				sleep 0.7;
				
				[] call _fnc_PlayReloadSound;
				_roundsReloaded = _roundsReloaded + 1;
			};
		};
		
		if (DEF_DEBUG) then {
			hint format ["Rounds reloaded: %1", _roundsReloaded];
		};
		
		// Exposing this data to the mission maker just for fun. 
		// Maybe play some custom sounds when reloading certain amount of rounds.
		DEF_CURRENT_PLAYER setVariable [DEF_ROUNDS_RELOADED_VAR, _roundsReloaded, true];
		
		DEF_CURRENT_PLAYER removeMagazines _oldmagazine;
		
		{
			if (_MyMagsAllAmmo > _fullMagNum) then {
				DEF_CURRENT_PLAYER addMagazine _oldmagazine;
				_MyMagsAllAmmo = abs (_MyMagsAllAmmo - _fullMagNum);
			};
			if (_MyMagsAllAmmo <= _fullMagNum and _MyMagsAllAmmo > 0) then {
				DEF_CURRENT_PLAYER addMagazine [_oldmagazine, _MyMagsAllAmmo];
				_MyMagsAllAmmo = 0;
			};
		} foreach _MyMags;
		
		DEF_CURRENT_PLAYER playactionNow "gestureNod" ;
		RTG_Shotgun_TacReloadInProgress = 0;
	};

	["ShotgunTacReload", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
	["ShotgunTacReload", "onEachFrame", {
		private _MyMags = magazinesAmmo DEF_CURRENT_PLAYER; 
		private _MyMags = _MyMags select {(currentMagazine DEF_CURRENT_PLAYER) in _x};
		private _AmoutOfMags = count _MyMags;
		private _oldmagazine = currentMagazine DEF_CURRENT_PLAYER;
		private _fullMagNum = getNumber (configFile >> 'CfgMagazines' >> _oldmagazine >> 'count');
		private _AmmoInWeapon = DEF_CURRENT_PLAYER ammo (currentMuzzle DEF_CURRENT_PLAYER);
		if (
			vehicle DEF_CURRENT_PLAYER == DEF_CURRENT_PLAYER and
			_AmoutOfMags > 0 and
			_fullMagNum != _AmmoInWeapon and
			_fullMagNum < 9 and
			_fullMagNum > 4 and
			(['buck','slug','HE','frag','PPA','Stun','Pellets','fl'] findIf {[_x, _oldmagazine] call BIS_fnc_inString} != -1) and
			FS_ShotgunTacticalReload_PRESSED_R and
			RTG_Shotgun_TacReloadInProgress == 0
		) then {
			[] spawn RTG_Shotgun_TacReload;
		};
	}] call BIS_fnc_addStackedEventHandler;

};