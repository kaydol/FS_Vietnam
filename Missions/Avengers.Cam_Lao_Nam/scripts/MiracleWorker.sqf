
#define DEF_MIRACLE_WORKER_RADIUS 5
#define DEF_INVUL_PERIOD 1.5
#define DEF_SOUND_TO_PLAY "heartbeat"

params ["_unit"];

if (_unit != player) exitWith {};
 
if !(player diarySubjectExists "Readme") then 
{
	player createDiarySubject ["Readme","Your abilities"];
	player setDiarySubjectPicture ["Readme","Your abilities"];
};

player createDiaryRecord ["Readme", ["Miracle Worker", format ["<br/>Closest ally within %1m is immune to damage (only if you are not incapacitated).<br/><br/>If the ally is incapacitated, YOU will be immune to damage instead.<br/><br/>The invulnerability effect plays a heartbeat sound both for you and the affected ally when active.<br/><br/>", DEF_MIRACLE_WORKER_RADIUS]]];

waitUntil { sleep 1; !dialog };

sleep 1;

["RespawnAdded", ["Perk: Miracle Worker", format ["Closest ally within %1m is immune to damage", DEF_MIRACLE_WORKER_RADIUS], '\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\instructor_ca.paa']] call BIS_fnc_showNotification;
//systemChat format ["New Perk: Miracle Worker - Closest ally within %1m is immune to damage", DEF_MIRACLE_WORKER_RADIUS];

private _fnc_onRespawn = {
	_this spawn 
	{
		params ["_unit", ["_corpse", objNull]];
		
		while { alive _unit } do 
		{
			// Only provide immunity if the unit itself is not incapacitated 
			if !(_unit getVariable ["vn_revive_incapacitated", false]) then 
			{
				private _teammates = (units group _unit) select { alive _x && _unit != _x && ((_x distance _unit) < DEF_MIRACLE_WORKER_RADIUS) };
				
				if !(_teammates isEqualTo []) then 
				{
					([[_unit], _teammates, true] call FS_fnc_DistanceBetweenArrays) params ["_distance","_array"];
					_array params ["_unit", "_closestTeammate"];
					
					//systemChat name _closestTeammate;
					
					// It seems that SOG revive is running a loop that does allowDamage=true on incapacitated players, so
					// give invul to the medic instead if the closest teammate is incapacitated 
					if (_closestTeammate getVariable ["vn_revive_incapacitated", false]) then 
					{
						[_unit, DEF_INVUL_PERIOD, true] remoteExec ["FS_fnc_AddGodmodeTimespan", _unit];
						playSound DEF_SOUND_TO_PLAY;
					}
					else
					{
						// Give invul to teammate 
						[_closestTeammate, DEF_INVUL_PERIOD, true] remoteExec ["FS_fnc_AddGodmodeTimespan", _closestTeammate];
						
						if (isPlayer _closestTeammate) then 
						{
							[[_closestTeammate, DEF_SOUND_TO_PLAY], {
								params ["_closestTeammate", "_sound"];
								if (_closestTeammate == player) then {
									playSound _sound;
								};
							}] remoteExec ["call", _closestTeammate];
						};
					};
				};
				
				sleep 1;
			};
		};
	};
};

//-- "Respawn" EH is persisted across multiple respawns
_unit addEventHandler ["Respawn", _fnc_onRespawn];

//-- If respawn on start is disabled, manually add action on mission start
if (getNumber(missionConfigFile >> "respawnOnStart") <= 0) then {
	[_unit] call _fnc_onRespawn;
};










