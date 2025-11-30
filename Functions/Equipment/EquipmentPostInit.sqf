
#include "..\..\definitions.h"

#define DEF_ENABLE_TEXTURE true  

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
						[_grp, (vehicle _attachment)] call _fnc_join_group;
						
						{
							_x disableAI "AIMINGERROR"; 
							_x setSkill ["spotTime",1];
							_x setSkill ["spotDistance",1];
							_x setSkill ["aimingAccuracy", 1];
							_x setSkill ["aimingSpeed",1];
							_x setSkill ["aimingShake",1];
						}
						forEach units _grp;
					};
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

if (hasInterface) then 
{
	[DEF_LASER_SOURCES_EH_VAR, "onEachFrame", 
	{
		private _sources = missionNameSpace getVariable [DEF_LASER_SOURCES_VAR, []];
		{
			private _thisSource = _x;
			if (!isNull _thisSource) then 
			{	
				private _selections = ["Laser", "Laser_R", "Laser_L"];
				{
					private _thisSelection = _x;
					private _offset = _thisSource selectionPosition _thisSelection;
					
					if (_offset isNotEqualTo [0,0,0]) then 
					{
						private _laserColor = [1000,0,0];
						private _thisSourceASL = _thisSource modelToWorldVisualWorld _offset;
						
						drawLaser [
							_thisSourceASL, 
							_thisSource weaponDirection currentWeapon _thisSource, 
							_laserColor,
							[],
							0.1,
							0.1,
							-1,
							false
						];
						
						if (DEF_ENABLE_TEXTURE) then 
						{
							private _camPos = AGLToASL (positionCameraToWorld [0,0,0.2]);
							private _camDistance = _camPos distance DEF_CURRENT_PLAYER;
							private _zoom = (0.5 - ((worldToScreen positionCameraToWorld [0, 1, 1]) # 1)) * (getResolution # 5);
							private _size = (-1 * (_camDistance / 100) + 1.5) * (_zoom / 2);
							
							if (_cameraMode == 1) then {
								_laserColor = [1000,0,0];
							};
							
							_laserColor set [3,1];

							drawIcon3D
							[
								"\FS_Vietnam\Textures\laserpoint_ca.paa",
								_laserColor,
								ASLToAGL _thisSourceASL,
								_size,
								_size,
								0,
								"",
								0,
								0,
								"PuristaMedium",
								"center",
								false
							];
						};
					};
				}
				forEach _selections;
			};
		}
		forEach _sources;
	}] call BIS_fnc_addStackedEventHandler; 
};