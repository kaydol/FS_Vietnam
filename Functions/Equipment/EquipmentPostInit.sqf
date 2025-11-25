
#include "..\..\definitions.h"

#define DEF_STONE_BACKPACK "FS_Backpack_RaiStone"
#define DEF_STONE_BACKPACK_GEOMETRY "FS_Backpack_RaiStone_Geometry"

if (!hasInterface) exitWith {};

[] spawn 
{
	waitUntil {sleep 1; !(isNull player) && alive player};

	private _code = {
		params ["_unit"];
		
		private _attached = ((attachedObjects _unit) select {typeOf _x == DEF_STONE_BACKPACK_GEOMETRY});
		
		private _conditionToAttach = (vehicle _unit == _unit) && (backpack _unit isEqualTo DEF_STONE_BACKPACK);
		
		if (!_conditionToAttach && _attached isNotEqualTo []) exitWith {
			detach (_attached # 0);
			deleteVehicle (_attached # 0);
		};
		
		if (_conditionToAttach && _attached isEqualTo []) then {
			private _geometry = DEF_STONE_BACKPACK_GEOMETRY createVehicle position _unit;
			_geometry attachTo [_unit, [0,-0.85,-0.35], "spine3", true];
		};
	};

	player addEventHandler ["SlotItemChanged", _code];

	//-- Persistent on respawn if assigned where unit was local.
	player addEventHandler ["GetInMan", _code];

	//-- Persistent on respawn if assigned where unit was local.
	player addEventHandler ["GetOutMan", _code];

	//-- "Respawn" EH is persisted across multiple respawns
	player addEventHandler ["Respawn", _code];

	player call _code; 
};