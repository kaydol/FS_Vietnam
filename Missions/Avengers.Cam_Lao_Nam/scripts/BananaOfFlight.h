	
	
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
					
					[_unit, 60] remoteExec ["FS_fnc_AddGodmodeTimespan", _unit];
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