
#define DEF_TRACE_DISTANCE 1000 // Maximum Distance from origin point to record positions (Default -1, for no max)
#define DEF_TRACE_LIFETIME 5 // Duration after firing to keep the line drawn.  (Default -1, for indefinite duration)

params ["_unit"];

if (_unit != player) exitWith {};

waitUntil { sleep 1; !dialog };

sleep 1;

if !(player diarySubjectExists "Readme") then 
{
	player createDiarySubject ["Readme","Your abilities"];
	player setDiarySubjectPicture ["Readme","Your abilities"];
};

player createDiaryRecord ["Readme", ["Bullet Trajectory", format ["<br/>Your bullets (and grenades) leave a trajectory up to %1m.<br/><br/>The trajectory is visible to all players and remains on screen for %2 seconds.<br/><br/>", DEF_TRACE_DISTANCE, DEF_TRACE_LIFETIME]]];


private _perkName = "Bullet Trajectory";
private _perkDescription = "All bullets have their trajectory shown to you and your teammates";
//systemChat format ["New Perk: %1 - %2", _perkName, _perkDescription];
["RespawnAdded",[format ["Perk: %1", _perkName],_perkDescription,"\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\instructor_ca.paa"]] call BIS_fnc_showNotification;

waitUntil {sleep 1; !isNil{hyp_fnc_traceFire}};

_unit addEventHandler ["Respawn", {
	params ["_unit", ["_corpse", objNull]];
	[_unit, nil, DEF_TRACE_LIFETIME, 0.1, DEF_TRACE_DISTANCE, DEF_TRACE_LIFETIME, true] remoteExec ["hyp_fnc_traceFire", 0, TRUE];
}];

if (getNumber(missionConfigFile >> "respawnOnStart") <= 0) then {
	[_unit, nil, DEF_TRACE_LIFETIME, 0.1, DEF_TRACE_DISTANCE, DEF_TRACE_LIFETIME, true] remoteExec ["hyp_fnc_traceFire", 0, TRUE];
};
