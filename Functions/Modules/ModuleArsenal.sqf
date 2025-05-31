/* ----------------------------------------------------------------------------
Function: FS_fnc_ModuleArsenal

Description:
	This module creates a room at the corner of the map, then teleports players
	each to their own specific coordinate in that room, and opens BIS Arsenal 
	for them. As soon as players individually exit the Arsenal, they are 
	teleported back to the position they were at when the Arsenal Module was 
	launched. The room stays at the corner of the map forever.
	
Synced objects:
	Triggers:	(OPTIONAL) You can activate the module with triggers.

Returns:
    Nothing.

Author:
    kaydol
---------------------------------------------------------------------------- */

#include "..\..\definitions.h"

_this spawn {

	params ["_module", ["_units", []], ["_activated", false]];

	private _arsenalRoomAt = ASLToAGL [-100, -100, getTerrainHeightASL [50,50] + 50];

	if ( isServer && !(missionNameSpace getVariable ["ArsenalRoomCreated", false])) then {
		/* Create Arsenal */
		[_arsenalRoomAt] call FS_fnc_ArsenalRoomCreate;
		missionNameSpace setVariable ["ArsenalRoomCreated", true, true];
	};

	if (_activated && !(DEF_CURRENT_PLAYER getVariable ["UsesArsenalRoom", false])) then 
	{
		if (vehicle DEF_CURRENT_PLAYER != DEF_CURRENT_PLAYER || DEF_CURRENT_PLAYER isKindOf "VirtualCurator_F") exitWith {};

		private _allowAll = _module getVariable "allowAll";
		private _respawnLoadout = _module getVariable "respawnLoadout";
		private _respawnLoadoutMsgStyle = _module getVariable "respawnLoadoutMsgStyle";
		
		if (hasInterface) then {
			"ArsenalRoom" cutText ["", "BLACK OUT", 0.0001];
			waitUntil {time > 1 && !isNull DEF_CURRENT_PLAYER && missionNameSpace getVariable ["ArsenalRoomCreated", false]};
			[_arsenalRoomAt, _allowAll, _respawnLoadout, _respawnLoadoutMsgStyle] spawn FS_fnc_ArsenalRoom;
		};
	};
};