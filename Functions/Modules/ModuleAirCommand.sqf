/* ----------------------------------------------------------------------------
Function: FS_fnc_ModuleAirCommand

Description:
	Right now all this really does is running behaviour scripts on the synced helicopters.
	I may or may not expand this module with additional features if I decide to *go deeper*.
	
Synced objects:
    Helicopters:	Only sync helicopters, not planes. Can sync many.
	Triggers:		(OPTIONAL) You can activate the module with triggers.

Parameters:
    _module - The module with helicopters synced to it. 
	
Returns:
    Nothing.

Author:
    kaydol
---------------------------------------------------------------------------- */

#include "..\..\definitions.h"

if !(isServer) exitWith {};

params ["_module", ["_units", []], ["_activated", false], ["_firstRun", true]];

if !(_activated) exitWith {};

private _respawnDestroyedAircrafts = _module getVariable "RespawnDestroyedAircrafts";
private _respawnDelay = _module getVariable "RespawnDelay";

private _hunterClasses = _module getVariable "HunterClasses";
if (_hunterClasses isEqualType "") then { _hunterClasses = call compile _hunterClasses; };

private _killerClasses = _module getVariable "KillerClasses";
if (_killerClasses isEqualType "") then { _killerClasses = call compile _killerClasses; };

private _radioTransmissionPrefix = _module getVariable "CallSign";
private _assessmentRate = _module getVariable "assessmentRate";
private _artilleryThreshold = _module getVariable "artilleryThreshold";
private _artilleryCD = _module getVariable "artilleryCooldown";
private _napalmThreshold = _module getVariable "napalmThreshold";
private _napalmCD = _module getVariable "napalmCooldown";
private _ambientRadio = _module getVariable "AmbientRadio";
private _enableIntroduction = _module getVariable "EnableIntroduction";

private _markersToMarkWith = _module getVariable "MarkersToMarkWith";
if (_markersToMarkWith isEqualType "") then { _markersToMarkWith = call compile _markersToMarkWith; };

private _minClusterSizeToMark = _module getVariable "MinClusterSizeToMark";
private _makeCaptive = _module getVariable "MakeCaptive";
private _godmode = _module getVariable "Godmode";
private _debug = _module getVariable "debug";

if (_debug) then {
	diag_log "Air Command Module: Initializing";
};

// Used in FS_fnc_AssignFireTask
SUPPORT_MINDISTANCE_ARTILLERY = _module getVariable "artilleryMinDist"; 
SUPPORT_MINDISTANCE_NAPALM = _module getVariable "napalmMinDist";

// For some reason when using synchronizedObjectsAdd [heli] mid mission, 
// it only syncs it's effective commander, and I need it to sync the actual vehicle  
// So here I sync in 2 steps, first I gather the vehicles of all synced objects, and then
// I do the actual thing on the gathered vehicles

// Step 1. Gather aircrafts of all synced objects
private _synced = synchronizedObjects _module; 
private _aircrafts = [];
{
	if ( typeOf _x isKindOf "Air" || vehicle _x isKindOf "Air" ) then 
	{ 
		_aircrafts pushBackUnique vehicle _x;
		if (_godmode) then {
			[_x, 99999999] remoteExec ["FS_fnc_AddGodmodeTimespan", _x];
		};
	};
}
forEach _synced;

// The side has to be saved to find out which side this aircraft served to before it got destroyed
// Important to save side before setCaptive, because setCaptive makes them civillians
{
	private _aircraft = _x;
	_aircraft setVariable ["initSide", side _aircraft]; 
} 
forEach _aircrafts;

{
	private _aircraft = _x;
	
	if (_radioTransmissionPrefix != DEF_RADIO_TRANSMISSION_PREFIX_NONE) then {
		_aircraft setVariable [DEF_RADIO_TRANSMISSION_PREFIX_VAR, _radioTransmissionPrefix, true];
	};
	
	//-- There must be a better place to put this in. This place does not account for empty vehicles...
	if ((driver _aircraft) isNotEqualTo objNull) then {
		[group driver _aircraft, [_radioTransmissionPrefix splitString "_" select 0]] remoteExec ["setGroupId", 0];
	};
	
	_x spawn 
	{
		params ["_aircraft"];
		
		//-- "Contact!"
		[[_aircraft], {
			params ["_aircraft"]; 
			_aircraft addEventHandler ["Fired", {
				params ["_aircraft", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
				_aircraft removeEventHandler [_thisEvent, _thisEventHandler];
				private _side = _aircraft getVariable ["initSide", side _aircraft];
				[_side, _aircraft getVariable DEF_RADIO_TRANSMISSION_PREFIX_VAR, "Engaging"] remoteExec ["FS_fnc_TransmitOverRadio", 2];
			}];
		}] remoteExec ["call", _aircraft];
		
		//-- "I've got a visual on you"
		private _time = time;
		private _isPosHidden = false;
		waitUntil {
			sleep 1;
			_isPosHidden = ([eyePos driver _this, [] call BIS_fnc_listPlayers, _this] call FS_fnc_IsPosHidden); 
			time - _time > 60 || !_isPosHidden 
		};
		if (!_isPosHidden) then {
			private _side = _aircraft getVariable ["initSide", side _aircraft];
			[_side, _aircraft getVariable DEF_RADIO_TRANSMISSION_PREFIX_VAR, "Visual"] remoteExec ["FS_fnc_TransmitOverRadio", 2];
		};
	};
}
forEach _aircrafts;

if (_makeCaptive) then 
{
	{
		private _crew = crew _x;
		{
			_x setCaptive true; 
			if (_debug) then {
				diag_log format ["Air Command Module: Made %1 captive", _x];
			};
		} forEach _crew;
	} forEach _aircrafts;
};


// Step 2. Run scripts on synced aircrafts
{
	private _aircraft = _x;
	private _fsmInProgress = false;
	
	if (!isNil{_aircraft getVariable "AirCommandFSMHandle"}) then {
		_fsmInProgress = !completedFSM (_aircraft getVariable "AirCommandFSMHandle");
	};
	
	if !(_fsmInProgress) then 
	{
		private _target = objNull;
		private _fsmHandle = [_aircraft, _assessmentRate, [_artilleryThreshold, _artilleryCD, _napalmThreshold, _napalmCD], _target, _markersToMarkWith, _minClusterSizeToMark, _debug] execFSM "\FS_Vietnam\FSM\Loach.fsm";
		
		_aircraft setVariable ["AirCommandFSMHandle", _fsmHandle, true];
		
		// Step 3. Announce if needed 
		if ( _firstRun && _enableIntroduction ) then 
		{
			[_aircraft getVariable ["initSide", side _aircraft], _aircraft getVariable DEF_RADIO_TRANSMISSION_PREFIX_VAR, "Introduction"] remoteExec ["FS_fnc_TransmitOverRadio", 2];
		};
		
		if (!_firstRun) then {
			[_aircraft getVariable ["initSide", side _aircraft], _aircraft getVariable DEF_RADIO_TRANSMISSION_PREFIX_VAR, "Replacement"] remoteExec ["FS_fnc_TransmitOverRadio", 2];
		};
		
		if (_respawnDestroyedAircrafts) then 
		{
			// All aircrafts are considered HUNTERS for now and will use _hunterClasses
			[_aircraft, _module, _respawnDelay, _hunterClasses, _aircraft getVariable ["initSide", side _aircraft], getPos _aircraft, _debug] spawn 
			{
				params ["_aircraft", "_module", "_respawnDelay", "_hunterClasses", "_side", "_posOfDeath", "_debug"];
				waitUntil {
					sleep 1; 
					private _check = false;
					if (!_check) then { _check = isNil {_aircraft}; };
					if (!_check) then { _check = isNull _aircraft; };
					if (!_check) then { _check = completedFSM (_aircraft getVariable "AirCommandFSMHandle"); };
					_posOfDeath = getPos _aircraft;
					_check
				};
				
				sleep _respawnDelay;
				
				if (isNull _module) exitWith {
					"Air Command Module: could not respawn aircraft, because the module was deleted" call BIS_fnc_Error;
				};
				
				if (_debug) then {
					diag_log "Air Command Module: Spawning new aircraft...";
				};
				
				/* Aircraft destroyed, spawn a new one at the closest base */ 
				/* Select the closest base */
				
				private _bases = FS_REFUELRELOAD_BASES;
				private _distance = 999999999999;
				private _closest_base = objNull;

				{
					/* Only bases of the same side are taken into consideration */
					private _baseModule = _x;
					if ( ( _baseModule call FS_fnc_GetModuleOwner ) == _side ) then 
					{
						private _dist =  _baseModule distance _posOfDeath;
						if ( _dist < _distance ) then {
							_distance = _dist;
							_closest_base = _baseModule;
						};
					};
				}
				forEach _bases;
				
				private _spawnPos = [0,0,1000];
				private _specialState = "FLY";
				
				if ( _closest_base isEqualTo objNull ) then 
				{
					// No air bases defined in the editor
					if ( _debug ) then {
						diag_log "Air Command Module: No bases to spawn a new aircraft";
					};
				}
				else
				{
					_spawnPos = getPos _closest_base; 
					_specialState = "NONE";
				};
				
				if (_debug) then {
					diag_log format ["Air Command Module: Spawning aircraft at %1", _spawnPos];
				};
				
				private _newAircraft = createVehicle [selectRandom _hunterClasses, _spawnPos, [], 10, "NONE"];
				[_newAircraft, createGroup WEST] call BIS_fnc_spawnCrew;
				
				sleep 5;
				
				if (_debug) then {
					diag_log format ["Air Command Module: New aircraft is %1", group _newAircraft];
				};
				
				_module synchronizeObjectsAdd [_newAircraft];
				[_module, [], true, false] spawn FS_fnc_ModuleAirCommand;
			};
		};
	};
}
forEach (_aircrafts select { _x call FS_fnc_CanPerformDuties });
