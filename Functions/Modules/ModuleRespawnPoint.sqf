
/* ----------------------------------------------------------------------------
Function: FS_fnc_ModuleRespawnPoint

Description:
	This module essentually creates marker(s) named 'respawn_side_xxxxxx'. 
	Marker(s) only exist as long as the condition is true. Side is defined by a 
	synced Side logic. Synced vehicles have markers attached to them. If no 
	vehicles are synced, module's position is used instead. It is possible to 
	activate this module with a trigger.
	
	If "spawn as passenger" is enabled, and more than 2 vehicles with spawn points on them 
	are very close to each other at the moment of player's respawn, mishups could happen,
	e.g. player will be put in the wrong vehicle. 
	
	Also when using this module please don't create respawn markers manually or use any 
	other addons that do that, it may lead to wrong module being assigned as the owner 
	of the chosen respawn point. 
	
Synced objects:

    "SideXXX_F":				Side this base belongs to. Must be an object with type 
								"SideBLUFOR_F", "SideOPFOR_F" or "SideResistance_F".
								
	Vehicles:					(OPTIONAL) If no vehicles are synced, module will use its own position 
								as a spawn point. If vehicles are synchronized, respawn markers will be 
								attached to them instead. It should be possible to use module with any object
								except "MAN", but the module was only tested with vehicles of kind CAR, TANK, AIR, SEA.
								
	"LocationRespawnPoint_F":	(OPTIONAL) If no vehicles are synced (so the module's own position is used)
								and "LocationRespawnPoint_F" are synced to the module, after spawning on the
								module's marker the unit will be teleported to a randomly chosen 
								"LocationRespawnPoint_F". It is presumed that synced objects of type 
								"LocationRespawnPoint_F" are always on Land (not placed in water),
								so searching for the nearest land and teleporting there is disabled.
								Also the unit will always play a respawn animation, if any.
								
	Triggers:					(OPTIONAL) You can activate the module with triggers.
	

Parameters:
    _module - The module with a side synced to it.
	
Returns:
    Nothing.

Author:
    kaydol
---------------------------------------------------------------------------- */

#include "..\..\definitions.h"

#define DEF_FILTER_CONDITION  { !(_x isKindOf "Man") && !(_x isKindOf "Logic") && !(_x isKindOf "EmptyDetector")}

params ["_logic", ["_units", []], ["_activated", false]];

/* The first iterated synchronyzed Side will define the side of this base. 
If no Side is synced, the base is unavailable to everyone. */

private _synced = synchronizedObjects _logic; 
private _side = sideLogic;
{
	_side = _x call FS_fnc_GetModuleOwner;
	if !( _side isEqualTo sideLogic ) exitWith { };
} 
forEach _synced;

if ( _side isEqualTo sideLogic ) exitWith {
	["[Respawn Point] No Side has been synced, please sync a Side that will get access to this module"] call BIS_fnc_error;
};

_logic setVariable ["Side", _side, true];

if !(_activated) exitWith {};

/* Retreiving variables stored in the module */
private _startCondition = compile ( _logic getVariable ["StartCondition", "true"] );
private _stopCondition = compile ( _logic getVariable ["StopCondition", "false"] );
private _loopConditions = _logic getVariable "LoopConditions";

private _sleep = _logic getVariable "Sleep";

private _vehicleMustBeAlive = _logic getVariable "VehicleMustBeAlive";
private _overrideStopCondition = _logic getVariable "OverrideStopCondition";
private _spawnAsPassenger = _logic getVariable "SpawnAsPassenger";
private _deleteOldBody = _logic getVariable "DeleteOldBody";
private _landSearchRadius = _logic getVariable "LandSearchRadius";
private _respawnAnimations = _logic getVariable "RespawnAnimations";
if (_respawnAnimations isEqualType "") then {
	_respawnAnimations = call compile _respawnAnimations;
	_logic setVariable ["RespawnAnimations", _respawnAnimations, true];
};
private _vfxCustom = _logic getVariable "VFXCustom";
if (_vfxCustom isEqualType "") then {
	_vfxCustom = call compile _vfxCustom;
	_logic setVariable ["VFXCustom", _vfxCustom, true];
};
private _vfxPreset = _logic getVariable "VFXPreset";
if (_vfxPreset isEqualType "") then {
	_vfxPreset = call compile _vfxPreset;
	_logic setVariable ["VFXPreset", _vfxPreset, true];
};
private _vfxLength = _logic getVariable "VFXLength";
private _godModeLength = _logic getVariable "GodModeLength";
private _respawnFromDarkness = _logic getVariable "RespawnFromDarkness";
private _activationNotification = _logic getVariable "ActivationNotification";
private _deactivationNotification = _logic getVariable "DeactivationNotification";

_synced = synchronizedObjects _logic select DEF_FILTER_CONDITION;

//-- Use module itself as fallback if no vehicles was synced 
if (_synced isEqualTo []) then { _synced pushBack _logic; };

_synced = _synced apply {[_x, ""]};

//-- Execute code on clients 
//-- Add ONE event handler that will serve multiple modules 
{
	if !(hasInterface) exitWith {};
	private _respawnEH = DEF_CURRENT_PLAYER getVariable "ModuleRespawnPoint_RespawnEH";
	if !(isNil{_respawnEH}) exitWith {};
	
	//-- "Respawn" EH is persisted across multiple respawns
	//-- We do not indulge in wasting resources 
	_respawnEH = DEF_CURRENT_PLAYER addEventHandler ["Respawn", {
		_this spawn 
		{
			params ["_unit", "_corpse"];
			
			//-- Only look at modules with the same side 
			private _modules = (allMissionObjects "FS_RespawnPoint_Module") select {(_x getVariable "Side") isEqualTo (side _unit)};
			
			//-- Delete respawn EH if all modules were deleted 
			if (_modules isEqualTo []) exitWith {
				private _respawnEH = _unit getVariable "ModuleRespawnPoint_RespawnEH";
				if (!isNil{_respawnEH}) then {
					_unit removeEventHandler ["Respawn", _respawnEH];
				};
			};
			
			//-- How to detect the module on which the person respawned?
			//-- I will choose the parent module of the closest spawn point relative to where _unit is.
			//-- if you have any ideas on how to do it more precisely, let me know.
			
			//-- Take the first possible module to use it as a point of reference
			private _module = _modules # 0;
			private _distance = _unit distance _module;
			private _vehicle = _module;
			private _synced = synchronizedObjects _module select DEF_FILTER_CONDITION;
			if !(_synced isEqualTo []) then {
				_distance = _unit distance (_synced select 0); 
				_vehicle = _synced select 0;
			};
			
			//-- Now loop through all synced objects of all modules to find what module is closest to where the unit actually spawned
			{
				_synced = synchronizedObjects _x select DEF_FILTER_CONDITION;
				if (_synced isEqualTo []) then { _synced = [_x]; };
				
				([[_unit], _synced, true] call FS_fnc_DistanceBetweenArrays) params ["_newMinDistance", "_closestArray"];
				_closestArray params ["_closestFromArray1", "_closestFromArray2"];
				
				if (_newMinDistance < _distance) then {
					_distance = _newMinDistance;
					_module = _x;
					_vehicle = _closestFromArray2;
				};
			} forEach _modules;
			
			//-- If the distance is too big, it's possible that additional respawn markers were placed by mission maker or by some other addon.
			//-- It's also possible that a very fast moving vehicle was synced to the module and the marker can't quite keep up with the speed of the vehicle 		
			//-- Let's just pretend that a mission maker will never do such shit.
			//if (_distance > 100) exitWith {};
			
			//-- It looks like player respawned on a spawn position provided by the module _module 
			//-- Now we read this module's properties 
			private _spawnAsPassenger = _module getVariable "SpawnAsPassenger";
			private _deleteOldBody = _module getVariable "DeleteOldBody";
			private _respawnAnimations = _module getVariable "RespawnAnimations";
			private _respawnFromDarkness = _module getVariable "RespawnFromDarkness";
			private _vfxLength = _module getVariable "VFXLength";
			private _godModeLength = _module getVariable "GodModeLength";
			private _landSearchRadius = _module getVariable "LandSearchRadius";
			
			if ( _godModeLength > 0 ) then {
				_unit allowDamage false;
				
				// ["RespawnAdded", [localize "STR_FS_PERK_EFFECT", format ["%1 : %2 %3", localize "STR_FS_LvlFeatures_SpawnProtection", CONST_RESPAWN_GODMODETIME, localize "STR_FS_PERK_seconds"],"\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\instructor_ca.paa"]] call BIS_fnc_showNotification;
			};
			
			if (_respawnFromDarkness > 0) then {
				0 cutText ["", "BLACK IN", _respawnFromDarkness, true, true]; 
			};
			
			if (_vfxLength > 0) then {
				[_unit, _module] spawn {
				
					params ["_unit", "_module"];
					
					private _vfxPreset = _module getVariable "VFXPreset";
					private _vfxCustom = _module getVariable "VFXCustom";
					private _vfxLength = _module getVariable "VFXLength";
					
					private _ppCol = -1;
					private _ppCCBase = [0.199, 0.587, 0.114, 0.0];
					private _ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.0], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
					
					if !(_vfxPreset isEqualTo []) then {
						_vfxCustom = _vfxPreset;
					};
					
					private _ppCCIn = [1, 1, 0, [0.0, 0.0, 0.0, 0.5], _vfxCustom, _ppCCBase];
					private _name = "colorCorrections";
					private _priority = 1550;
					while {
						_ppCol = ppEffectCreate [_name, _priority]; 
						_ppCol < 0 
					} do {
						_priority = _priority + 1; 
					};
					_ppCol ppEffectAdjust _ppCCIn;
					_ppCol ppEffectCommit 0;
					_ppCol ppEffectEnable true;
					
					private _i = 0;
					private _steps = 10;
					for "_i" from 1 to _steps do {
						if !(alive _unit) exitWith {};
						sleep (_vfxLength / 2 / _steps);
					};
					
					if !(_ppCol isEqualTo -1) then {
						_ppCol ppEffectAdjust _ppCCOut;
						_ppCol ppEffectCommit (_vfxLength / 2);
						if (alive _unit) then {
							sleep (_vfxLength / 2);
						};
						ppEffectDestroy _ppCol;
					};
				};
			};
			
			if (!isNull _corpse && _deleteOldBody) then {
				if (vehicle _corpse != _corpse) then {
					// "You should take extra steps and execute this where vehicle is local as moving units out 
					// of the vehicle happens where vehicle is local and you want this to always precede deletion."
					if !(local vehicle _corpse) then {
						[vehicle _corpse,  _corpse] remoteExec ["deleteVehicleCrew", vehicle _corpse];
					} else {
						(vehicle _corpse) deleteVehicleCrew _corpse;
					};
				} else {
					deleteVehicle _corpse;
				};
			};
			
			if (_spawnAsPassenger && alive _vehicle && !(_vehicle isKindOf "Module_F")) then 
			{
				//-- I've had it with this motherfucker 
				[_unit, _vehicle] spawn {
					params ["_unit", "_vehicle"];
					private _i = 0;
					for [{_i = 0},{_i < 10},{_i = _i + 1}] do {
						if (vehicle DEF_CURRENT_PLAYER == _vehicle || !alive _vehicle) exitWith {}; 
						_unit moveInCargo _vehicle;
						sleep 0.1;
					};
					//-- One last try 
					if (vehicle DEF_CURRENT_PLAYER != _vehicle && alive _vehicle) then {
						_unit moveInAny _vehicle;
					};
				};
			} else {
			
				private _posInWater = false;
			
				//-- If no vehicles are synced to the module (module itself is used as a spawn point)
				//-- And "LocationRespawnPoint_F" are synced to the module, select a random "LocationRespawnPoint_F"
				//-- to spawn player at that location
				if (_vehicle == _module && (synchronizedObjects _module findIf {typeOf _x == "LocationRespawnPoint_F"}) > 0) then {
					private _syncedRespawnPoints = synchronizedObjects _module select {typeOf _x == "LocationRespawnPoint_F"};
					private _randomRespawnPoint = selectRandom _syncedRespawnPoints;
					_unit setPosATL getPosATL _randomRespawnPoint;
					
					_posInWater = false;
				}
				else 
				{
					//-- Custom water check because "underwater _unit" and "eyePos _unit select 2 < 0" suck
					private _isPosInWater = {
						((selectBestPlaces [_this, 1, "waterDepth", 1, 1]) findIf { _x # 1 < 0.5}) < 0
					};
				
					_posInWater = (position _unit) call _isPosInWater;
				
					if (_landSearchRadius > 0 && _posInWater) then 
					{
						private _maxNumberOfPlaces = 200;
						private _precision = 1;
						//-- Search for places on land, filter out places with depth > 0.5 meters
						private _places = (selectBestPlaces [position _unit, _landSearchRadius, "1-(waterDepth interpolate [0,1,0,1])", _precision, _maxNumberOfPlaces min (2 * (_landSearchRadius / _precision))]) select {_x # 1 > 0.5};
						if !(_places isEqualTo []) then 
						{
							//-- Find the closest place on land 
							([[_unit], _places apply {_x # 0}, true] call FS_fnc_DistanceBetweenArrays) params ["_minDistance", "_closestElements", "_closestElementIndexes"];
							
							//-- Teleport player to that place 
							if !((_closestElements # 1) isEqualTo objNull) then {
								_unit setPos (_closestElements # 1);
								_posInWater = (_closestElements # 1) call _isPosInWater;
							};
						};
					};
				};
			
				if (count _respawnAnimations > 0 && !_posInWater) then {
					private _anim = selectRandom _respawnAnimations; 
					[DEF_CURRENT_PLAYER, _anim] remoteExec ["switchMove", 0]; 
				};
			};
			
			if (_godModeLength > 0) then {
				[_unit, _godModeLength] spawn {
					sleep (_this # 1);
					(_this # 0) allowDamage true;
				};
			};
		};
	}];
	player setVariable ["ModuleRespawnPoint_RespawnEH", _respawnEH];

} remoteExec ["call", 0, true];


while { true } do 
{
	/* Wait until a user-defined condition is true */
	WaitUntil { sleep _sleep; call _startCondition }; 
	
	while {sleep _sleep; ! call _stopCondition || (_overrideStopCondition && _synced isEqualTo []) || isNull _logic } do {
		
		if (isNull _logic) exitWith {};
		
		//-- Get freshly synchronized vehicles
		private _currentSynced = (synchronizedObjects _logic) select DEF_FILTER_CONDITION;
		
		//-- Delete spawn points on vehicles that are no longer synced 
		private _i = 0;
		for [{_i = count _synced - 1},{_i >= 0},{_i = _i - 1}] do
		{
			(_synced # _i) params ["_veh", "_marker"];
			
			//-- Do not delete the module here (obviously it's not synced to itself)
			if (!(_veh isEqualTo _logic) && !(_veh in _currentSynced) && _marker != "") then 
			{
				deleteMarker _marker;
				
				if (_deactivationNotification) then {
					[["RespawnAdded",["Respawn lost","Respawn Point no longer available","\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\instructor_ca.paa"]],"BIS_fnc_showNotification",_side] call bis_fnc_mp;
				};
				
				_synced deleteAt _i;
				_logic setVariable ["SpawnPoints", _synced, true]; //-- Provide interface to mission maker
			};
		};
		
		//-- Add freshly synchronized vehicles
		//-- keeping in mind that _synced = [[_veh, _mar], ...] and _currentSynced = [_veh1, _veh2, ...]
		private _oldSynced = [];
		if (count _synced > 0) then { _oldSynced = _synced apply {_x # 0}; };
		{
			private _iterable = _x;
			if !(_iterable in _oldSynced) then {
				_synced pushBack [_iterable, ""];
			};
		} forEach _currentSynced;
		
		//-- Delete module from the list if vehicles are synced 
		if (count _synced > 1) then {
			private _index = _synced findIf { (_x # 0) isEqualTo _logic };
			if (_index > 0) then {
				private _marker = (_synced # _index) select 1;
				if (_marker != "") then 
				{
					deleteMarker _marker;
					
					if (_deactivationNotification) then {
						[["RespawnAdded",["Respawn lost","Respawn Point no longer available","\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\instructor_ca.paa"]],"BIS_fnc_showNotification",_side] call bis_fnc_mp;
					};
				};
				_synced deleteAt _index;
			};
			_logic setVariable ["SpawnPoints", _synced, true]; //-- Provide interface to mission maker
		};
		
		//-- Delete spawns associated with dead vehicles 
		if (_vehicleMustBeAlive && {!alive (_x # 0)} count _synced > 0) then {
			{
				_x params ["_veh", "_marker"];
				if (!alive _veh) then 
				{
					_logic synchronizeObjectsRemove [_veh];
					if (_marker != "") then 
					{
						deleteMarker _marker; 
						
						if (_deactivationNotification) then {
							[["RespawnAdded",["Respawn lost","Respawn Point no longer available","\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\instructor_ca.paa"]],"BIS_fnc_showNotification",_side] call bis_fnc_mp;
						};
					};
				};
				
			} forEach _synced;
			_synced = _synced select { alive (_x # 0) };
			_logic setVariable ["SpawnPoints", _synced, true]; //-- Provide interface to mission maker
		};
		
		//-- Create new markers and store them in _synced 
		{
			if (_x # 1 == "") then 
			{
				_x params ["_veh", "_marker"];
				
				private _name = gettext (configfile >> "cfgvehicles" >> (typeof _veh) >> "displayname");
				
				//-- Only add "+grid+ - near +locationName+" to static spawns, 
				//-- do not add to vehicles that can move to some other place and invalidate the name
				if (_veh isEqualTo _logic) then {
					_name = format [localize "str_a3_bis_fnc_respawnmenuposition_grid",mapgridposition _veh] + " - " + ((position _veh) call bis_fnc_locationdescription);
				};
				_marker = createMarkerLocal [format["respawn_%1_%2", _side, str(round random(1000000))], getPos _veh];
				_marker setMarkerTypeLocal "EmptyIcon";
				_marker setMarkerText _name;
				_marker setMarkerAlpha 0;
				
				_x set [1, _marker];
				
				//--- Show notifications
				if (_marker != "" ) then 
				{
					_logic setVariable ["SpawnPoints", _synced, true]; //-- Provide interface to mission maker
					
					if (_activationNotification) then {
						[["RespawnAdded",["Respawn added",_name,"\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\instructor_ca.paa"]],"BIS_fnc_showNotification",_side] call bis_fnc_mp;
					};
				};
			};
		} forEach _synced;
		
		//-- Attach markers to vehicles
		{
			_x params ["_veh", "_marker"];
			if (!isNull(_veh) && _marker != "") then {
				_marker setMarkerPos getPos _veh;
			};
		} forEach _synced;
	};

	//-- Delete created markers
	{
		_x params ["_veh", "_marker"];
		if (_marker != "") then 
		{
			deleteMarker _marker;
			
			if (_deactivationNotification) then {
				[["RespawnAdded",["Respawn lost","Respawn Point no longer available","\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\instructor_ca.paa"]],"BIS_fnc_showNotification",_side] call bis_fnc_mp;
			};
		};
	} forEach _synced;
	_synced = [];
	_logic setVariable ["SpawnPoints", _synced, true]; //-- Provide interface to mission maker
	
	if ( !_loopConditions || isNull _logic ) exitWith {};

};

if !(isNull _logic) then {
	deleteVehicle _logic;
};
