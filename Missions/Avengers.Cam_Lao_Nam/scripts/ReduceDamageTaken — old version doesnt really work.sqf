
/*--------------------------------------------------------------------------------------

	For when SOG Prairie Fire DLC is installed
	
	This requires:
		- S.O.G. CDLC Modules -> Advanced Revive ->  missionNamespace setVariable ["vn_revive_headshot_kill",false]
	
----------------------------------------------------------------------------------------*/

// Fix to not die from headshots with SOG Advanced Revive 
missionNamespace setVariable ["vn_revive_headshot_kill",false];

#define DEF_HANDLER_NAME "reduce_damage_taken_eh"
#define DEF_OHK_FLAG "can_die_in_one_hit"
#define DEF_DMG_MULTIPLIER 0.5
#define DEF_INVUL_PERIOD 8 

params ["_unit"];

if !(local _unit) exitWith {};

private _reduceDamageTaken = {
	params ["_unit"];
	
	_unit setVariable [DEF_OHK_FLAG, false];
	
	if (!isNil{_unit getVariable DEF_HANDLER_NAME}) then { 
		_unit removeEventHandler ["HandleDamage", _unit getVariable DEF_HANDLER_NAME]; 
		_unit setVariable [DEF_HANDLER_NAME, nil]; 
	};

	private _handleDamage = _unit addEventHandler ["HandleDamage", {
		params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint", "_directHit"];
	
		private _incomingDamage = _damage * DEF_DMG_MULTIPLIER;
		private _oneHitKillPossible = _unit getVariable [DEF_OHK_FLAG, false];
		private _isLethalDamage = (1 - (getDammage _unit) - _incomingDamage) < 0.4;
		
		if (_oneHitKillPossible == false && _isLethalDamage) then 
		{
			_unit setVariable [DEF_OHK_FLAG, true, true];
			
			//-- Godmode given 
			_unit allowDamage false;
			[_unit, DEF_INVUL_PERIOD] remoteExec ["FS_fnc_AddGodmodeTimespan", _unit];
			
			
			[[_unit, "cheat_death_activated"], { params ["_speaker", "_sound"]; _speaker say3D [_sound, 500, 1, 0, 0, true]; }] remoteExec ["call", 0];
			
			_unit spawn 
			{
				private _perkName = "";
				
				_perkName = "Cheat death once";
				_perkDescription = "Gain short invulnerability on lethal damage";
				
				if (_this == player) then {
					systemChat format ["Perk Expired: %1", _perkName];
					
					("CheatDeathActivated" call BIS_fnc_rscLayer) cutRsc ["RscStatic", "PLAIN"];
				};
				
				_this setDamage 0;
				
				// Fix to work with SOG Advanced Revive 
				_this spawn {
					for[{_i = 0},{_i < 10},{_i = _i + 1}] do {					
						_this setVariable ["vn_revive_incapacitated",false,true];
						sleep 0.1;
					};
				};
				
				_this spawn {
					_this execVM "scripts\Shout.sqf";
				};
				
				sleep DEF_INVUL_PERIOD;
				
				if (_this == player) then {
					["RespawnAdded",[format ["Perk Expired: %1",_perkName],_perkDescription,"\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\instructor_ca.paa"]] call BIS_fnc_showNotification;
					systemChat format ["Perk Expired: %1", _perkName];
				};
				
				//-- Handled by Godmode Synchronizer Module 
				//_this allowDamage true;
			};
			
			_incomingDamage = 0;
		};
		
		if !(isDamageAllowed _unit) then {
			_incomingDamage = 0;
		};
		
		// Block multiple damage procs from one source 
		if (_incomingDamage > 0) then {
			_unit allowDamage false;
			[_unit, 0.1] remoteExec ["FS_fnc_AddGodmodeTimespan", _unit];
		};
		
		systemChat format ["dmg: %1 Lethal? %2 resulting: %3", _damage, _isLethalDamage, _incomingDamage];
		
		// TODO it looks like you need to get hitpoint damage instead of getDammage ! 
		(getDammage _unit) + _incomingDamage 
	}];
	
	_unit setVariable [DEF_HANDLER_NAME, _handleDamage];
	
	// Notify player 
	if (_unit == player) then {
		[] spawn {
			sleep 1;
			private _perkName = "";
			private _perkDescription = "";
			
			_perkName = "Tough guy";
			_perkDescription = format ["Incoming damage is multiplied by %1", DEF_DMG_MULTIPLIER];
			systemChat format ["New Perk: %1 - %2", _perkName, _perkDescription];
			["RespawnAdded",["Perk",_perkDescription,"\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\instructor_ca.paa"]] call BIS_fnc_showNotification;
			
			_perkName = "Cheat death once";
			_perkDescription = "Gain short invulnerability on lethal damage";
			systemChat format ["New Perk: %1 - %2", _perkName, _perkDescription];
			["RespawnAdded",["Perk",_perkDescription,"\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\instructor_ca.paa"]] call BIS_fnc_showNotification;
			
			_perkName = "The name is Kruber";
			_perkDescription = "Shout when Cheat Death procs";
			systemChat format ["New Perk: %1 - %2", _perkName, _perkDescription];
			["RespawnAdded",["Perk",_perkDescription,"\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\instructor_ca.paa"]] call BIS_fnc_showNotification;
		};
	};
};

//-- "Respawn" EH is persisted across multiple respawns
_unit addEventHandler ["Respawn", _reduceDamageTaken];

//-- If respawn on start is disabled, manually add action on mission start
if (getNumber(missionConfigFile >> "respawnOnStart") <= 0) then {
	[_unit] call _reduceDamageTaken;
};


