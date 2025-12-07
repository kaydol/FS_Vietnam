
/*--------------------------------------------------------------------------------------

	For when SOG Prairie Fire DLC is installed
	
	This requires:
		- S.O.G. CDLC Modules -> Advanced Revive ->  missionNamespace setVariable ["vn_revive_headshot_kill",false]
	
----------------------------------------------------------------------------------------*/

// Fix to not die from headshots with SOG Advanced Revive 
missionNamespace setVariable ["vn_revive_headshot_kill",false];

#define DEF_HANDLER_NAME "reduce_damage_taken_eh"

#define DEF_DAMMAGED_SOUND (getMissionPath format["\music\kruber_%1.ogg", 1 + round(time) % 14])
#define DEF_LAST_TIME_SOUND_WAS_PLAYED "LastTimeSoundWasPlayed"
#define DEF_DAMMAGED_SOUND_PERIOD 10

#define DEF_GODMODE_SOUND "cheat_death_activated"
#define DEF_CHANCE_TO_BECOME_IMMORTAL 0.3
#define DEF_INVUL_PERIOD 10 


params ["_unit"];

if !(local _unit) exitWith {};

if (_unit == player) then {

	if !(player diarySubjectExists "Readme") then 
	{
		player createDiarySubject ["Readme","Your abilities"];
		player setDiarySubjectPicture ["Readme","Your abilities"];
	};

	player createDiaryRecord ["Readme", ["Nuln Regiment Survivor", format ["<br/>On receiving damage from small caliber firearms, get a %1 percent chance to gain invulnerability for %2s.<br/><br/>Snipers still can (and will) one-shot you.<br/><br/>Also, you have a deep hatred for campfires...<br/><br/>", DEF_CHANCE_TO_BECOME_IMMORTAL*10, DEF_INVUL_PERIOD]]];
	
	player createDiaryRecord ["Readme", ["Explosive Dysentery", "<br/>When dying, a lot of energy is released, often leading to unexpected results.<br/><br/>Will you be content with your illness, or do something about it?<br/><br/>Remember, uncle Nurgle loves you either way.<br/><br/>"]];

	[] spawn 
	{
		waitUntil { sleep 1; !dialog };

		sleep 1;
		
		private _perkName = "";
		private _perkDescription = "";
		
		_perkName = "Nuln Regiment Survivor";
		_perkDescription = format ["On receiving damage, get a %1 percent chance to gain invulnerability", DEF_CHANCE_TO_BECOME_IMMORTAL*100];
		//systemChat format ["New Perk: %1 - %2", _perkName, _perkDescription];
		["RespawnAdded",[format ["Perk: %1", _perkName],_perkDescription,"\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\instructor_ca.paa"]] call BIS_fnc_showNotification;
		
		_perkDescription = format ["Almost immortal... but at what cost...?", _perkName];
		_perkName = "Explosive Dysentery";
		//systemChat format ["New Perk: %1 - %2", _perkName, _perkDescription];
		["RespawnAdded",[format ["Perk: %1", _perkName],_perkDescription,"\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\instructor_ca.paa"]] call BIS_fnc_showNotification;
	};
};


private _addDamageHandler = {

	params ["_unit"];
	
	if (!isNil{_unit getVariable DEF_HANDLER_NAME}) then { 
		_unit removeEventHandler ["HandleDamage", _unit getVariable DEF_HANDLER_NAME]; 
		_unit setVariable [DEF_HANDLER_NAME, nil]; 
	};

	private _handleDamage = _unit addEventHandler ["HandleDamage", {
		params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint", "_directHit"];
		
		private _success = (random 1) <= DEF_CHANCE_TO_BECOME_IMMORTAL;
		private _isDamageAllowed = isDamageAllowed _unit;
		private _isIncapacitated = _unit getVariable ["vn_revive_incapacitated",false];
		
		if (DEF_DAMMAGED_SOUND != "" && time - (missionNameSpace getVariable [DEF_LAST_TIME_SOUND_WAS_PLAYED, 0]) > DEF_DAMMAGED_SOUND_PERIOD) then 
		{
			missionNameSpace setVariable [DEF_LAST_TIME_SOUND_WAS_PLAYED, time]; // anti spam 
			
			[[_unit, DEF_DAMMAGED_SOUND], {
				params ["_speaker", "_sound"];
				playSound3D [_sound, _speaker, _speaker call FS_fnc_IsInside, getPosASL _speaker, 3];
			
			}] remoteExec ["call", 0];
		};
		
		if (_damage < 0.1) exitWith { _damage };
		if (_isIncapacitated) exitWith { _damage };
		if !(_success) exitWith { _damage };
		if !(_isDamageAllowed) exitWith { _damage };
		
		_unit allowDamage false;
		[_unit, DEF_INVUL_PERIOD] remoteExec ["FS_fnc_AddGodmodeTimespan", _unit];
		[[_unit, DEF_GODMODE_SOUND], { params ["_speaker", "_sound"]; _speaker say3D [_sound, 500, 1, 0, 0, true]; }] remoteExec ["call", 0];
		
		/*
		private _animation = selectRandom [
			"AsdvPercMtacSnonWrflDf", // swimming forward
			"AsdvPercMstpSnonWrflDnon_goup", // swimming up
			"AinjPfalMstpSnonWnonDf_carried_fallwc", // falling from the shoulder
			"AinjPfalMstpSnonWrflDnon_carried_Up", // injured laying flat  
			"AcinPercMstpSnonWnonDnon" // carrying someone on shoulders 
		];
		[[_unit, _animation], {
			params ["_unit", "_animation"];
			if (alive _unit) then {
				_unit switchMove _animation;
			};
			sleep 7;
			if (alive _unit) then {
				_unit switchMove "Acts_Taking_Cover_From_Jets_out";
			};
		}] remoteExec ["spawn", 0];
		*/
		
		_unit setDamage 0;
		_unit spawn {
			for[{_i = 0},{_i < 10},{_i = _i + 1}] do {
				_this setVariable ["vn_revive_incapacitated",false,true];
				sleep 0.1;
			};
		};
		
		if (_unit == player) then {
			private _perkName = "Cheat death";
			//systemChat format ["Perk Activated: %1", _perkName];
			("CheatDeathActivated" call BIS_fnc_rscLayer) cutRsc ["RscStatic", "PLAIN"];
		};
		
		_unit execVM "scripts\Shout.sqf";
		
		_damage
	}];
	
	_unit setVariable [DEF_HANDLER_NAME, _handleDamage];
	
};

//-- "Respawn" EH is persisted across multiple respawns
_unit addEventHandler ["Respawn", _addDamageHandler];

//-- If respawn on start is disabled, manually add action on mission start
if (getNumber(missionConfigFile >> "respawnOnStart") <= 0) then {
	[_unit] call _addDamageHandler;
};


