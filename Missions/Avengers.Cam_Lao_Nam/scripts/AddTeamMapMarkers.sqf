
params ["_unit"];

if (_unit != player) exitWith {};


if !(player diarySubjectExists "Readme") then 
{
	player createDiarySubject ["Readme","Your abilities"];
	player setDiarySubjectPicture ["Readme","Your abilities"];
};

player createDiaryRecord ["Readme", ["Map Knowledge", "<br/>The members of your group are always marked on your map.<br/><br/>"]];


waitUntil { sleep 1; !dialog };

sleep 1;

["RespawnAdded", ["Perk: Map Knowledge", "Can see group members on the map", '\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\instructor_ca.paa']] call BIS_fnc_showNotification;
//systemChat "New Perk: Map Knowledge - Can see group members on the map";


FS_addMapMarker = {
	private _markerType = "Select";
	private _text = name _this;

	private _objmark = createMarkerLocal [format ["%1",_this], getPos _this];
	
	_objmark setMarkerColorLocal "ColorUNKNOWN";
	if (side _this == WEST) then {
		_objmark setMarkerColorLocal "colorBLUFOR";
	};
	if (side _this == EAST) then {
		_objmark setMarkerColorLocal "colorOPFOR";
	};
	if (side _this == INDEPENDENT) then {
		_objmark setMarkerColorLocal "colorIndependent";
	};
	if (side _this == CIVILIAN) then {
		_objmark setMarkerColorLocal "colorCivilian";
	};
	
	_objmark setMarkerTypeLocal _markerType;
	_objmark setMarkerTextLocal _text;

	while {alive _this && !isNull _this} do 
	{
		_objmark setMarkerPosLocal getpos _this;
		sleep 0.1;
	};

	deleteMarker _objmark;
};

/*

private _codeForLocalUnitRespawn = format ["
	
		params ['_localUnit', ['_corpse', objNull]];
		_localUnit remoteExec ['FS_addMapMarker', %1];
		
", clientOwner];

private _codeForPlayers = {
	params ["_clientOwner", ["_code", {}]];
	if (
		!isNull player // do not execute code on the headless server
	) then {
		player addEventHandler ["Respawn", compile _code];
		diag_log format ["(Machine @ %1) Adding respawn code on player (%2 @ %3): %4", clientOwner, player, owner player, _code];
	};
};

// Adding markers on JIP players 
[[clientOwner, _codeForLocalUnitRespawn], _codeForPlayers] remoteExec ["spawn", 0, true];

{
	_x addEventHandler ["Respawn", {
		params ["_unit", "_corpse"]; 
		_unit spawn FS_addMapMarker; 
	}];
	
	//-- If respawn on start is disabled, manually add action on mission start
	if (getNumber(missionConfigFile >> "respawnOnStart") <= 0) then {
		_x spawn FS_addMapMarker; 
	};
}
forEach ((units group player) select {!isPlayer _x});


*/

// This should probably work fine even for JIP players...
{
	_x addEventHandler ["Respawn", { params ["_unit", "_corpse"]; _unit spawn FS_addMapMarker; }];
	
	//-- If respawn on start is disabled, manually add action on mission start
	if (getNumber(missionConfigFile >> "respawnOnStart") <= 0) then {
		_x spawn FS_addMapMarker; 
	};
}
forEach units group player;


