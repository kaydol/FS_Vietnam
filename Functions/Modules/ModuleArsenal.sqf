
params ["_module"];

_arsenalRoomAt = ASLToAGL [-100, -100, 40];

if ( isServer ) then {
	/* Create Arsenal */
	[_arsenalRoomAt] call FS_fnc_ArsenalRoomCreate;
};

_allowAll = _module getVariable "allowAll";
_respawnLoadout = _module getVariable "respawnLoadout";
_respawnLoadoutMsgStyle = _module getVariable "respawnLoadoutMsgStyle";

if (hasInterface) then {
	[_arsenalRoomAt, _allowAll, _respawnLoadout, _respawnLoadoutMsgStyle] spawn FS_fnc_ArsenalRoom;
};