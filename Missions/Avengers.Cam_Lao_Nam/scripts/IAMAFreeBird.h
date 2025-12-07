

	private _fnc_addAction = {

		params ["_unit"];
		
		private _id = [
			player, 
			DEF_ACTION_DESCRIPTION, 
			DEF_ACTION_ICON, 
			DEF_ACTION_ICON, 
			DEF_ACTION_CONDITION, 
			"true",
			{
				//code started
				params ["_target", "_caller", "_actionId", "_arguments"];
				
				playSound DEF_ACTION_SOUND;
				
			},
			{
				// code progress 
				params ["_target", "_caller", "_actionId", "_arguments", "_frame", "_maxFrame"];
			},
			{ 	
				//code completed ----------------------------------------------------------------------------------------------------------------------------------
				params ["_target", "_caller", "_actionId", "_arguments"];
				
				private _unit = _caller;
				
				private _fnc_actionActivated = {

					params ["_unit"];
					
					// Remove consumable 
					if (DEF_MAGAZINES_THAT_GRANT_PERK isNotEqualTo []) then {
						private _magazines = (DEF_MAGAZINES_THAT_GRANT_PERK apply {toLowerANSI _x}) arrayIntersect ((magazines _unit) apply {toLowerANSI _x});
						private _magazine = _magazines select 0;
						_unit removeMagazine _magazine;
					};
					if (DEF_ITEMS_THAT_GRANT_PERK isNotEqualTo []) then {
						private _items = (DEF_ITEMS_THAT_GRANT_PERK apply {toLowerANSI _x}) arrayIntersect ((items _unit) apply {toLowerANSI _x});
						private _item = _items select 0;
						_unit removeItem _item;
					};
					// save the removal
					[_unit, [missionNameSpace, DEF_LOADOUT_NAME]] call BIS_fnc_saveInventory; 
					
					
					private _grp = createGroup sideLogic;
					private _module = _grp createUnit [DEF_MODULE_CLASSNAME, getPos _unit, [], 0, ""];
					
					_module setVariable ["type", 3, true];
					_module setVariable ["debug", false, true];
					_module setVariable ["vehicle", "vn_b_air_f4b_navy_cas", true];
					
					([allPlayers, [_unit], True] call FS_fnc_DistanceBetweenArrays) params ["_minDistance", "_array1", "_array2"];
					_array1 params ["_closestFromArray1", "_closestFromArray2"];
					private _closestFriend = _closestFromArray1;
					
					// drop napalm sideways to the closest friendly 
					private _bestAngle = (( [getPos _unit, _closestFriend] call BIS_fnc_dirTo ) + 90) % 360;
					_module setDir _bestAngle;
					
					// must be on server 
					[[_module, [], true], {_this spawn FS_fnc_ModuleNapalmCAS}] remoteExec ["spawn", 2];
					
					
					private _newGrp = createGroup west;
					private _virtualUnit = _newGrp createUnit ["VirtualCurator_F", position _unit, [], 0, ""];
					_virtualUnit allowDamage false;
					[_virtualUnit, 180] remoteExec ["FS_fnc_AddGodmodeTimespan", _virtualUnit];
					
					private _time = time;
					
					waitUntil { time - _time > 30 || !isNil {_module getVariable "plane"} };
					
					if (time - _time > 30) exitWith {};
					_time = time;
					
					private _plane = _module getVariable "plane";
					
					sleep 1;
					
					0 fadeSound 0;
					0 cutText ["", "BLACK IN", 20, true, true]; 

					selectPlayer _virtualUnit;
					_virtualUnit attachTo [_plane, DEF_UNIT_ATTACH_TO];
					_plane setVariable [DEF_OLD_UNIT, _unit];
					_plane setVariable [DEF_VIRTUAL_UNIT, _virtualUnit];
					
					if (DEF_SOUND != "") then {
						[[_virtualUnit, DEF_SOUND], { params ["_speaker", "_sound"]; _speaker say3D [_sound, 1500, 1, 0, 0, true]; }] remoteExec ["call", 0];
					};
					
					private _handler = _plane addEventHandler ["Fired", {
						params ["_vehicle", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
						
						private _handler = _vehicle getVariable DEF_HANDLER_VAR;
						_vehicle removeEventHandler ["Fired", _handler];
						//player setVelocity velocity _projectile;
						_this spawn {
							params ["_vehicle", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
							
							private _virtualUnit = _vehicle getVariable DEF_VIRTUAL_UNIT;
							private _oldUnit = _vehicle getVariable DEF_OLD_UNIT;
							
							_virtualUnit attachTo [_projectile, DEF_UNIT_ATTACH_TO];
							
							waitUntil {!alive _projectile};
							
							0 fadeSound 1;
							
							if (DEF_DEBUG) then {
								diag_log "Free Bird: selecting old unit";
							};
							
							selectPlayer _oldUnit;
							
							sleep 1;
							
							_oldUnit setDamage 1;
							detach _virtualUnit;
							deleteVehicle _virtualUnit;
						};
					}];
					
					_plane setVariable [DEF_HANDLER_VAR, _handler];
					
					sleep 60; // Timeout 
					
					if (DEF_DEBUG) then {
						diag_log "Free Bird: script is ending";
						
					};
					
					// Return control if it didn't happen
					if (player != _unit) then {
						
						if (DEF_DEBUG) then {
							diag_log "Free Bird: player is stuck inside virtual unit, attempting to correct";
						};
						
						selectPlayer _unit;
					};
					
					if !(isNull _virtualUnit) then 
					{
						deleteVehicle _virtualUnit;
						
						if (DEF_DEBUG) then {
							diag_log "Free Bird: attempt to delete virtual unit";
						};
					};
				};
				
				if (DEF_MAGAZINES_THAT_GRANT_PERK isNotEqualTo []) then 
				{
					private _magazines = (DEF_MAGAZINES_THAT_GRANT_PERK apply {toLowerANSI _x}) arrayIntersect ((magazines _unit) apply {toLowerANSI _x});
					private _magazine = _magazines select 0;
					
					// Serverwide announce
					[[_caller, _magazine, DEF_ACTION_SOUND],{
						params ["_caller", "_magazine", "_sound"];
						if (_caller != player) then 
						{
							_caller say3D _sound;
							private _displayName = gettext (configfile >> "CfgMagazines" >> _magazine >> "displayName");
							["RespawnAdded", [_displayName, format [DEF_NOUN_IN_SERVERWIDE_ANNOUNCEMENT, name _caller, _displayName], '\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\instructor_ca.paa']] call BIS_fnc_showNotification;
						};
					}] remoteExec ["call", 0];
				};
				if (DEF_ITEMS_THAT_GRANT_PERK isNotEqualTo []) then 
				{
					private _items = (DEF_ITEMS_THAT_GRANT_PERK apply {toLowerANSI _x}) arrayIntersect ((items _unit) apply {toLowerANSI _x});
					private _item = _items select 0;
					
					// Serverwide announce
					[[_caller, _item, DEF_ACTION_SOUND],{
						params ["_caller", "_item", "_sound"];
						if (_caller != player) then 
						{
							_caller say3D _sound;
							private _displayName = gettext (configfile >> "CfgWeapons" >> _item >> "displayName");
							["RespawnAdded", [_displayName, format [DEF_NOUN_IN_SERVERWIDE_ANNOUNCEMENT, name _caller, _displayName], '\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\instructor_ca.paa']] call BIS_fnc_showNotification;
						};
					}] remoteExec ["call", 0];
				};
				
				_caller setVariable [DEF_ACTION_ID_VAR, nil];
				_caller spawn _fnc_actionActivated;
				
				//-------------------------------------------------------------------------------------------------------------------------------------------------
			},
			{
				// code interrupted
				params ["_target", "_caller", "_actionId", "_arguments"]; 
			},
			[],
			3,
			-1000,
			true, // removeCompleted
			true // showUnconscious
		] call BIS_fnc_holdActionAdd; 
		
		_unit setVariable [DEF_ACTION_ID_VAR, _id];
	};
	
