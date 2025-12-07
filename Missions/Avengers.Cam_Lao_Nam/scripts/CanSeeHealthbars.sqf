
params ["_unit"];

if (player != _unit) exitWith {};

if !(player diarySubjectExists "Readme") then 
{
	player createDiarySubject ["Readme","Your abilities"];
	player setDiarySubjectPicture ["Readme","Your abilities"];
};

player createDiaryRecord ["Readme", ["Healthbars", "<br/>The healthy-ness of your allies is represented by a visible bar.<br/><br/>It's called a healthbar!<br/><br/>"]];

waitUntil { sleep 1; !dialog };

sleep 1;

["RespawnAdded", ["Perk: Healthbars", "Can see healthbars on your group members", '\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\instructor_ca.paa']] call BIS_fnc_showNotification;
//systemChat "New Perk: Healthbars - Can see healthbars on your group members";


if (isNull( uiNamespace getVariable ['FS_HealthBar_HUD', displayNull] )) then 
{
	("FS_HealthBar_HUD" call BIS_fnc_rscLayer) cutRsc ["FS_HealthBar_HUD", "PLAIN"];
};

// Task: make a remote unit execute code on this particular machine every time the remote unit respawns 
// (the code must be executed only on this machine and no other) 
// Must work for all connected players as well as for every future player joining the mission  

private _codeForLocalUnitRespawn = format ["
	
		params ['_localUnit', ['_corpse', objNull]];
		_localUnit remoteExec ['FS_fnc_HealthbarsAdd', %1];
		
", clientOwner];

private _codeForPlayers = {
	params ["_clientOwner", ["_code", {}]];
	if (
		clientOwner != _clientOwner && // do not execute code for the medic player 
		!isNull player // do not execute code on the headless server
	) then {
		player addEventHandler ["Respawn", compile _code];
		diag_log format ["(Machine @ %1) Adding respawn code on player (%2 @ %3): %4", clientOwner, player, owner player, _code];
	};
};


private _codeForBots = {
	params ["_unit", ["_code", {}]];
	if (local _unit) then {
		_unit addEventHandler ["Respawn", compile _code];
		diag_log format ["(Machine @ %1) Adding respawn code on bot (%2 @ %3): %4", clientOwner, _unit, owner _unit, _code];
	};
};

// This should take care of all players, including JIP players 
[[clientOwner, _codeForLocalUnitRespawn], _codeForPlayers] remoteExec ["spawn", 0, true];

// This should take care of bots 
{
	//[[_x, _codeForLocalUnitRespawn], _codeForBots] remoteExec ["spawn", _x, true];
	_x spawn FS_fnc_HealthbarsAdd;
}
forEach ((units group player) select {!isPlayer _x && _x != player});
