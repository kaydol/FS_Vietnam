
#include "..\..\definitions.h"

#define DEF_STONE_BACKPACK "FS_Backpack_RaiStone"
#define DEF_STONE_BACKPACK_GEOMETRY "FS_Backpack_RaiStone_Geometry"

#define DEF_TURRET_BACKPACK "FS_PortableTurret_BP"
#define DEF_TURRET_BACKPACK_SHOULDER_GUN "FS_PortableTurret_Shoulder"

if (!hasInterface) exitWith {};

[] spawn 
{
	waitUntil {sleep 1; !(isNull player) && alive player};

	private _code = {
		params ["_unit"];
		
		{
			private _backpackClass = _x # 0;
			private _attachmentClass = _x # 1;
			private _coordinates = _x # 2;
			private _isManned = _x # 3;
			
			private _attached = ((attachedObjects _unit) select {typeOf _x == _attachmentClass});
		
			private _conditionToAttach = (vehicle _unit == _unit) && (backpack _unit isEqualTo _backpackClass);
			
			if (!_conditionToAttach && _attached isNotEqualTo []) exitWith {
				detach (_attached # 0);
				deleteVehicle (_attached # 0);
			};
			
			if (_conditionToAttach && _attached isEqualTo []) then 
			{
				private _attachment = _attachmentClass createVehicle position _unit;
				_attachment attachTo [_unit, _coordinates, "spine3", true];
				
				if (_isManned) then 
				{
					// Done via config now 
					//_attachment addEventHandler ["Reloaded", {
					//	params ["_unit", "_weapon", "_muzzle", "_newMagazine", "_oldMagazine"];
					//	vehicle _unit addMagazineTurret [_oldMagazine # 0, [0]];
					//}];
					
					[_attachment, 99999999] remoteExec ["FS_fnc_AddGodmodeTimespan", _attachment];

					private _fnc_join_group = {
						params ["_group", "_attachment"];
						{
							if !(isPlayer _x) then {
								[_x] joinSilent _group;
								[_x, 99999999] remoteExec ["FS_fnc_AddGodmodeTimespan", _x];
							}
						} foreach crew _attachment;
					};
					
					private _grp = createGroup [side player, true];
					_grp setGroupId ["Turret Backpack"];
					
					isNil {
						createVehicleCrew (vehicle _attachment);
						{
							_x disableAI "AIMINGERROR"; 
							_x setSkill ["spotTime",1];
							_x setSkill ["spotDistance",1];
							_x setSkill ["aimingAccuracy", 1];
							_x setSkill ["aimingSpeed",1];
							_x setSkill ["aimingShake",1];
							
							systemchat format ["Set skill for: %1 %2", time, _x];
						} 
						forEach units _grp;
					};
					
					[_grp, (vehicle _attachment)] call _fnc_join_group;
				};
			};
		}
		forEach [
			[DEF_STONE_BACKPACK, DEF_STONE_BACKPACK_GEOMETRY, [0,-0.85,-0.35], false],
			[DEF_TURRET_BACKPACK, DEF_TURRET_BACKPACK_SHOULDER_GUN, [0,-0.15,0.55], true]
		];
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