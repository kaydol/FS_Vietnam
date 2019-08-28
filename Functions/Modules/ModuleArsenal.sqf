
params ["_module"];

_arsenalRoomAt = ASLToAGL [-100, -100, 40];

if ( isServer ) then {
	/* Create Arsenal */
	[_arsenalRoomAt] call FS_fnc_ArsenalRoomCreate;
};

_playMusic = _module getVariable "playMusic";
_allowAll = _module getVariable "allowAll";
_respawnLoadout = _module getVariable "respawnLoadout";
_aceCompatibility = _module getVariable "aceCompatibility";

if (hasInterface) then {
	[_arsenalRoomAt, _allowAll, _respawnLoadout, _playMusic, _aceCompatibility] spawn FS_fnc_ArsenalRoom;
};