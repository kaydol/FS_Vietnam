/*
	
	This module acts as a centralized place to safely hand out time limited god modes
	from multiple sources across the network.

	Runs locally and applies godmode to local units.
	
	From the user perspective, all you need to do is plop down a Godmode Synchronizer Module 
	and then hand out godmodes with the use of FS_fnc_AddGodmodeTimespan:
		
		[_localOrRemoteObject, _godmodeLength] remoteExec ["FS_fnc_AddGodmodeTimespan", _localOrRemoteObject];
		
	There is a small delay (0.1s) before the module applies godmode on its own, so you might want to do a 
	manual "allowDamage=true" if you want it to work immediately. Like so:
	
		_localOrRemoteObject allowDamage false;
		[_localOrRemoteObject, _godmodeLength] remoteExec ["FS_fnc_AddGodmodeTimespan", _localOrRemoteObject];
	
	
	Author: kaydol 
*/

private _logic = _this select 0;
private _units = _this select 1;
private _activated = _this select 2;

private _debug = _logic getVariable "Debug";

#include "GodmodeSynchronizerDefinitions.h"

[_debug] spawn {
	params ["_debug"];

	private _fnc_get = {

		params ["_varname", "_key"];
		
		if (isNil{ missionNameSpace getVariable _varname }) then {
			missionNameSpace setVariable [_varname, createHashMap];
		};
		
		private _hashMap = missionNameSpace getVariable _varname;
		
		_hashMap get _key 
	};


	private _fnc_getKeys = {

		params ["_varname"];
		
		if (isNil{ missionNameSpace getVariable _varname }) then {
			missionNameSpace setVariable [_varname, createHashMap];
		};
		
		private _hashMap = missionNameSpace getVariable _varname;
		
		keys _hashMap
	};


	private _fnc_removeKey = {
		
		params ["_varname", "_key"];

		if (isNil{ missionNameSpace getVariable _varname }) exitWith {};
		
		private _hashMap = missionNameSpace getVariable _varname;
		
		if (_key in (keys _hashMap)) then {
			_hashMap deleteAt _key;
		};
	};

	private _fnc_processGodmode = {
		
		private _keys = [DEF_GODMODE_TIMESPANS] call _fnc_getKeys;
		
		private _oldObjects = [];
		private _newObjects = [];
		
		{
			([DEF_GODMODE_TIMESPANS, _x] call _fnc_get) params ["_affectedObject", "_expirationTime"];
			
			_oldObjects pushBackUnique _affectedObject;
			
			if (_expirationTime <= time) then {
				[DEF_GODMODE_TIMESPANS, _x] call _fnc_removeKey;
			} else {
				_newObjects pushBackUnique _affectedObject;
			};
		}
		foreach _keys;
		
		{
			if !(_x in _newObjects) then 
			{
				_x allowDamage true;
				
				if (_debug) then {
					systemChat format ["(%1) %2 godmode expired", time, typeOf _x];
				};
			} 
			else 
			{
				if (_x in _newObjects && local _x && isDamageAllowed _x) then {
					_x allowDamage false;
				};
			};
		} forEach _oldObjects;
	};

	// Manager 
	while {true} do {
		call _fnc_processGodmode;
		sleep 0.1;
	};

};


