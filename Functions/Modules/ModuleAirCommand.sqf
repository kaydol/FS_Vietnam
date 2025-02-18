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

if !(isServer) exitWith {};

params ["_module", ["_units", []], ["_activated", false]];

if !(_activated) exitWith {};

private _respawnDestroyedAircrafts = _module getVariable "RespawnDestroyedAircrafts";
private _respawnDelay = _module getVariable "RespawnDelay";
private _hunterClasses = _module getVariable "HunterClasses";
if (_hunterClasses isEqualType "") then { _hunterClasses = call compile _hunterClasses; };

private _killerClasses = _module getVariable "KillerClasses";
if (_killerClasses isEqualType "") then { _killerClasses = call compile _killerClasses; };

private _assessmentRate = _module getVariable "assessmentRate";
private _artilleryThreshold = _module getVariable "artilleryThreshold";
private _artilleryCD = _module getVariable "artilleryCooldown";
private _napalmThreshold = _module getVariable "napalmThreshold";
private _napalmCD = _module getVariable "napalmCooldown";
private _ambientRadio = _module getVariable "AmbientRadio";
private _announceOnInit = _module getVariable "AnnounceOnInit";
private _markersToMarkWith = _module getVariable "MarkersToMarkWith";
if (_markersToMarkWith isEqualType "") then { _markersToMarkWith = call compile _markersToMarkWith; };
private _minClusterSizeToMark = _module getVariable "MinClusterSizeToMark";

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
	};
}
forEach _synced;

// Step 2. Run scripts on synced aircrafts
{
	private _fsmInProgress = false;
	
	if (!isNil{_x getVariable "AirCommandFSMHandle"}) then {
		_fsmInProgress = !completedFSM (_x getVariable "AirCommandFSMHandle");
	};
	
	if !(_fsmInProgress) then 
	{
		private _target = objNull;
		private _fsmHandle = [_x, _assessmentRate, [_artilleryThreshold, _artilleryCD, _napalmThreshold, _napalmCD], _target, _markersToMarkWith, _minClusterSizeToMark, _debug] execFSM "\FS_Vietnam\FSM\Loach.fsm";
		
		_x setVariable ["AirCommandFSMHandle", _fsmHandle, true];
		
		if (_respawnDestroyedAircrafts) then 
		{
			[_x, _module, _respawnDelay, _hunterClasses, _debug] spawn 
			{
				params ["_aircraft", "_module", "_respawnDelay", "_hunterClasses", "_debug"];
				waitUntil { sleep 1; completedFSM (_aircraft getVariable "AirCommandFSMHandle") };
				
				sleep _respawnDelay;
				
				if (isNull _module) exitWith {
					"Air Command Module: could not respawn aircraft, because the module was deleted" call BIS_fnc_Error;
				};
				
				//_module synchronizeObjectsRemove [_aircraft];
				
				if (_debug) then {
					diag_log "Air Command Module: Spawning new aircraft...";
				};
				
				/* Aircraft destroyed, spawn a new one at the closest base */ 
				/* Select the closest base */
				
				private _side = _aircraft getVariable ["initSide", side _aircraft];
				private _bases = FS_REFUELRELOAD_BASES;
				private _distance = 999999999999;
				private _closest_base = objNull;

				{
					/* Only bases of the same side are taken into consideration */
					
					if ( ( _aircraft call FS_fnc_GetModuleOwner ) == _side ) then 
					{
						private _dist =  _x distance _aircraft;
						if ( _dist < _distance ) then {
							_distance = _dist;
							_closest_base = _x;
						};
					};
				}
				forEach _bases;
				
				private _spawnPos = [0,0,1000];
				private _specialState = "FLY";
				
				if ( _closest_base isEqualTo objNull ) then 
				{
					// No airports defined in the editor
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
				[_module, [], true] spawn FS_fnc_ModuleAirCommand;
			};
		};
	};
}
forEach (_aircrafts select { _x call FS_fnc_CanPerformDuties });


// Step 3. Announce if needed 
if ( _announceOnInit ) then 
{
	private _sides = _synced apply { side _x } select { _x isEqualType WEST };
	_sides = _sides arrayIntersect _sides; // get unique elements 

	{ [_x, "NewPilot"] remoteExec ["FS_fnc_TransmitOverRadio", 2]} forEach _sides;
};




