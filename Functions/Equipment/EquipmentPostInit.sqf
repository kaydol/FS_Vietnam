
#include "..\..\definitions.h"

//-- Lasers
#define DEF_ENABLE_3DICON_AT_LASER_SOURCE false  

//-- Helmet HUD 
#define DEF_HUD_SLEEP 0.3
#define DEF_HUD_RANGE 200
#define DEF_EXCLUDED_CLASSES ["VirtualCurator_F", "FS_PortableTurret_Shoulder"]
#define DEF_ZEUS_DISPLAY_ID 312
#define DEF_NEAR_UNITS_VAR FS_Helmet_Targets
#define DEF_INIT_SIDE_VAR "initSide"
#define DEF_ICON_VEHICLE "FS_Vietnam\Textures\HUD_Target_Vehicle.paa"
#define DEF_ICON_VEHICLE_SIZE 0.6
#define DEF_ICON_EMPLACEMENT "FS_Vietnam\Textures\HUD_Target_Emplacement.paa"
#define DEF_ICON_EMPLACEMENT_SIZE 0.4
#define DEF_ICON_HUMAN "FS_Vietnam\Textures\HUD_Target_Human.paa"
#define DEF_ICON_HUMAN_SIZE 0.3
#define DEF_ICON_GRENADE "FS_Vietnam\Textures\HUD_Target_Grenade.paa"
#define DEF_ICON_GRENADE_SIZE 2.2
#define DEF_ICON_COLOR_RED [1,0,0,1]
#define DEF_ICON_COLOR_NEUTRAL [1,1,0,1]
#define DEF_ICON_COLOR_ENEMY [1,0,0,1]
#define DEF_ICON_COLOR_GROUP [0.15,0.5,1,1]
#define DEF_ICON_COLOR_FRIENDLY [0.1,1,0.5,1]
// When the HUD is enabled, spawn a local invisible object with fire geometry and attach it to a flying grenade
// When the bullets hit the object, delete the grenade 
#define DEF_ALLOW_SHOOTING_DOWN_GRENADES true
#define DEF_LOCAL_GRENADE_COLLIDER_OBJECT_CLASS "FS_Invisible_Fire_Geometry"
#define DEF_LOCAL_GRENADE_COLLIDERS_VAR "FS_LOCAL_GRENADE_COLLIDERS"

if (!hasInterface) exitWith {};

[] spawn 
{
	waitUntil {sleep 1; !(isNull DEF_CURRENT_PLAYER) && alive DEF_CURRENT_PLAYER};

	//-- Preparing data for drawing the Lasers 
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
					
					private _grp = createGroup [side DEF_CURRENT_PLAYER, true];
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
	DEF_CURRENT_PLAYER addEventHandler ["SlotItemChanged", _code];
	//-- Persistent on respawn if assigned where unit was local.
	DEF_CURRENT_PLAYER addEventHandler ["GetInMan", _code];
	//-- Persistent on respawn if assigned where unit was local.
	DEF_CURRENT_PLAYER addEventHandler ["GetOutMan", _code];
	//-- "Respawn" EH is persisted across multiple respawns
	DEF_CURRENT_PLAYER addEventHandler ["Respawn", _code];
	DEF_CURRENT_PLAYER call _code; 
	
	
	//-- Preparing data for drawing Helmet HUD
	//-- Saving the init side is needed because player can be made captive 
	DEF_CURRENT_PLAYER setVariable [DEF_INIT_SIDE_VAR, side player];
	while {true} do 
	{
		while {toLowerANSI headgear DEF_CURRENT_PLAYER in (DEF_HUD_HELMETS apply {toLowerANSI _x})} do 
		{
			private _nearUnits = (nearestObjects [DEF_CURRENT_PLAYER, ["MAN","CAR","TANK","AIR","StaticWeapon"], DEF_HUD_RANGE, true]) select { 
				(getEntityInfo _x) params ["_isMan", "_isAnimal"]; 
				!_isAnimal
			};
		   
			DEF_NEAR_UNITS_VAR = _nearUnits select 
			{
				private _unitBlocked = lineIntersects [
					if (vehicle DEF_CURRENT_PLAYER == DEF_CURRENT_PLAYER) then [{eyePos DEF_CURRENT_PLAYER},{getPosASL vehicle DEF_CURRENT_PLAYER}],
					eyePos _x,
					vehicle DEF_CURRENT_PLAYER,
					_x
				] OR terrainIntersectASL [eyepos DEF_CURRENT_PLAYER, eyepos _x];
				
				alive _x && vehicle _x != vehicle DEF_CURRENT_PLAYER && !_unitBlocked && !isObjectHidden _x && (_x animationSourcePhase "cloak_source" <= 0) && !(toLowerANSI typeOf _x in (DEF_EXCLUDED_CLASSES apply {toLowerANSI _x}))
			};
			
			sleep DEF_HUD_SLEEP;
		};
		sleep 3;
	};
};

if (hasInterface) then 
{
	[DEF_EQUIPMENT_DRAW3D_EH_VAR, "onEachFrame", 
	{
		//-- Drawing Lasers 
		private _sources = missionNameSpace getVariable [DEF_LASER_SOURCES_VAR, []];
		{
			private _thisSource = _x;
			if (alive _thisSource) then 
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
						
						if (DEF_ENABLE_3DICON_AT_LASER_SOURCE) then 
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
		
		//-- Drawing Helmet HUD
		private _enabled = missionNameSpace getVariable [DEF_EQUIPMENT_ENABLE_HUD_VAR, false];
		if (_enabled && toLowerANSI headgear DEF_CURRENT_PLAYER in (DEF_HUD_HELMETS apply {toLowerANSI _x}) && isNull(findDisplay DEF_ZEUS_DISPLAY_ID)) then 
		{
			{
				private _unit = _x;
				if (!(isObjectHidden _unit) && !(_unit isKindOf "VirtualCurator_F") && typeOf _x != "FS_PortableTurret_Shoulder") then 
				{
					private _distance = (positionCameraToWorld [0,0,0]) distance _unit;
					private _icon = "";
					private _size = 0;
					private _color = [0,0,0,0];
					private _sideUnit = side _unit;
					private _sidePlayer = DEF_CURRENT_PLAYER getVariable [DEF_INIT_SIDE_VAR, side DEF_CURRENT_PLAYER];
					private _hostileCheck = _sidePlayer getFriend _sideUnit;
					private _fov = getObjectFOV vehicle DEF_CURRENT_PLAYER;
					private _pos = [0,0,0];

					if (_unit isKindof "MAN") then 
					{
						_pos = _unit modelToWorldVisual (_unit selectionPosition "spine3");
						if (_sideUnit == civilian OR lifeState _unit == "INCAPACITATED") then {
							_color = DEF_ICON_COLOR_NEUTRAL;
						}
						else 
						{
							if (_hostileCheck < 0.6) then {
								_color = DEF_ICON_COLOR_ENEMY;
							} 
							else 
							{
								if (group DEF_CURRENT_PLAYER isEqualTo group _unit) then {
									_color = DEF_ICON_COLOR_GROUP;
								} else {
									_color = DEF_ICON_COLOR_FRIENDLY;
								};
							};
						};
						
						_icon = DEF_ICON_HUMAN;
						_size = (DEF_ICON_HUMAN_SIZE / tan(_fov /2) / _distance) max 0.5;
					} 
					else 
					{
						if (_sideUnit == civilian OR lifeState _unit == "INCAPACITATED") then {
							_color = DEF_ICON_COLOR_NEUTRAL;
						} 
						else 
						{
							if (_hostileCheck < 0.6) then {
								_color = DEF_ICON_COLOR_ENEMY;
							} else {
								if (group DEF_CURRENT_PLAYER isEqualTo group _unit) then {
									_color = DEF_ICON_COLOR_GROUP;
								} else {
									_color = DEF_ICON_COLOR_FRIENDLY;
								};
							};
						};
						if (_unit isKindof "StaticWeapon") then {
							_pos = _unit modelToWorldVisual (_unit selectionPosition ["osahlavne", "Memory"]);
							_icon = DEF_ICON_EMPLACEMENT;
							_size = (DEF_ICON_EMPLACEMENT_SIZE / tan(_fov /2) / _distance) max 0.5;
						}
						else
						{
							_pos = _unit modelToWorldVisual (_unit selectionPosition ["zamerny", "Memory"]);
							_icon = DEF_ICON_VEHICLE;
							_size = (DEF_ICON_VEHICLE_SIZE / tan(_fov /2) / _distance) max 0.5;
						};
					};
					drawIcon3D [_icon,_color,_pos,_size,_size,0,"",0,0.04,"RobotoCondensed","center",false];
				};
			}
			forEach DEF_NEAR_UNITS_VAR;
			
			private _grenades = nearestObjects [DEF_CURRENT_PLAYER, ["Grenade"], 30];
			private _allColliders = missionNameSpace getVariable [DEF_LOCAL_GRENADE_COLLIDERS_VAR, []]; 
			
			private _newColliders = [];
			
			{
				private _thisGrenade = _x;
				private _missingCollider = (attachedObjects _thisGrenade select { typeOf _x == DEF_LOCAL_GRENADE_COLLIDER_OBJECT_CLASS }) isEqualTo [];
				
				if (_missingCollider) then 
				{
					private _collider = DEF_LOCAL_GRENADE_COLLIDER_OBJECT_CLASS createVehicleLocal [0,0,0];
					
					_collider disableCollisionWith DEF_CURRENT_PLAYER;
					
					_collider addEventHandler ["HandleDamage", {
						params ["_collider", "_selection", "_damage", "_source", "_projectile", "_hitPartIndex", "_instigator", "_hitPoint", "_directHit", "_context"];
						
						if (_instigator != DEF_CURRENT_PLAYER || !_directHit) exitWith {0};
						private _grenade = attachedTo _collider;
						if (_grenade isNotEqualTo []) then 
						{
							_collider removeAllEventHandlers "HandleDamage";
							
							deleteVehicle _grenade;
							deleteVehicle _collider;
						};
					}];
					
					_collider attachTo [_thisGrenade, [0,0,0]];
					_newColliders pushBack _collider;
				};
				
				drawIcon3D [DEF_ICON_GRENADE, DEF_ICON_COLOR_RED, getPosATLVisual _thisGrenade, DEF_ICON_GRENADE_SIZE, DEF_ICON_GRENADE_SIZE, 0,"",0,0.04,"RobotoCondensed","center",true];
				
			} forEach _grenades;
			
			// delete colliders from despawned grenades, replace them with objNulls
			_allColliders apply
			{
				private _grenade = attachedTo _x;
				if (isNull _grenade) then 
				{
					deleteVehicle _x;
				};
			};
			// remove objNulls from array
			_allColliders = _allColliders select {!(isNull _x)}; 
			
			_allColliders = _allColliders + _newColliders;
			
			missionNameSpace setVariable [DEF_LOCAL_GRENADE_COLLIDERS_VAR, _allColliders];
		};
		
	}] call BIS_fnc_addStackedEventHandler; 
};