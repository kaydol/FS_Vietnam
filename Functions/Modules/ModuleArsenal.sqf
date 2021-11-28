
params ["_module", ["_units", []], ["_activated", false]];

_arsenalRoomAt = ASLToAGL [-100, -100, getTerrainHeightASL [50,50] + 50];

if ( isServer && !(missionNameSpace getVariable ["ArsenalRoomCreated", false])) then {
	/* Create Arsenal */
	[_arsenalRoomAt] call FS_fnc_ArsenalRoomCreate;
	missionNameSpace setVariable ["ArsenalRoomCreated", true, true];
};

if (_activated && !(player getVariable ["UsesArsenalRoom", false])) then 
{
	_allowAll = _module getVariable "allowAll";
	_respawnLoadout = _module getVariable "respawnLoadout";
	_respawnLoadoutMsgStyle = _module getVariable "respawnLoadoutMsgStyle";

	if (hasInterface) then {
		waitUntil {time > 0 && !isNull player && missionNameSpace getVariable ["ArsenalRoomCreated", false]};
		[_arsenalRoomAt, _allowAll, _respawnLoadout, _respawnLoadoutMsgStyle] spawn FS_fnc_ArsenalRoom;
	};
};