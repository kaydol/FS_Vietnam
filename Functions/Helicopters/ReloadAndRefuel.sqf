
#include "..\..\definitions.h"

#define DEF_TIMEOUT 180


params ["_aircraft", "_debug"];

/*
	First, updating the stations to indicate that this aircraft
	has left its station 
*/
private _side = _aircraft getVariable ["initSide", side _aircraft];
[_side, "AIRSTATIONS", _aircraft] call FS_fnc_UpdateSideVariable;

private _group = group _aircraft;
private _bases = [];

private _needsMaintenance = _aircraft call FS_fnc_IsMaintenanceNeeded;
private _hasDead = {!alive _x} count crew _aircraft > 0;
private _hasAlive = {alive _x} count crew _aircraft > 0;

/* Send radio message */ 
if ( _hasAlive ) then 
{
	if ( _hasDead ) then 
	{
		switch (true) do {
			case (!alive driver _aircraft): {
				[_side, _aircraft getVariable DEF_RADIO_TRANSMISSION_PREFIX_VAR, "Injured"] remoteExec ["FS_fnc_TransmitOverRadio", 2];
			};
			case (!alive gunner _aircraft): {
				[_side, _aircraft getVariable DEF_RADIO_TRANSMISSION_PREFIX_VAR, "InjuredCrewChief"] remoteExec ["FS_fnc_TransmitOverRadio", 2];
			};
			default {
				[_side, _aircraft getVariable DEF_RADIO_TRANSMISSION_PREFIX_VAR, "InjuredCopilot"] remoteExec ["FS_fnc_TransmitOverRadio", 2];
			};
		};
	}
	else 
	{
		if (_needsMaintenance) then 
		{
			// Getting repairs, ammo or fuel 
			if ("DAMAGE" in (_aircraft call FS_fnc_GetProblems)) then {
				[_side, _aircraft getVariable DEF_RADIO_TRANSMISSION_PREFIX_VAR, "Damaged"] remoteExec ["FS_fnc_TransmitOverRadio", 2];
			} else {
				[_side, _aircraft getVariable DEF_RADIO_TRANSMISSION_PREFIX_VAR, "RefuelAndResupply"] remoteExec ["FS_fnc_TransmitOverRadio", 2];
			};
		}
		else 
		{
			// Crew member injured
			private _mostDammaged = driver _aircraft;
			{
				if (getDammage _x > getDammage _mostDammaged) then { _mostDammaged = _x };
			} forEach crew _aircraft;
			
			switch (_mostDammaged) do {
				case (driver _aircraft): {
					[_side, _aircraft getVariable DEF_RADIO_TRANSMISSION_PREFIX_VAR, "Injured"] remoteExec ["FS_fnc_TransmitOverRadio", 2];
				};
				case (gunner _aircraft): {
					[_side, _aircraft getVariable DEF_RADIO_TRANSMISSION_PREFIX_VAR, "InjuredCrewChief"] remoteExec ["FS_fnc_TransmitOverRadio", 2];
				};
				default {
					[_side, _aircraft getVariable DEF_RADIO_TRANSMISSION_PREFIX_VAR, "InjuredCopilot"] remoteExec ["FS_fnc_TransmitOverRadio", 2];
				};
			};
		};
	
	};
};

/* 
	In case this aircraft has both wounded and needs maintenance
	Attempt to find a base both with crew replacements and maintenance 
*/
if ( _hasDead && _needsMaintenance ) then {
	_bases = FS_REINFORCEMENT_BASES arrayIntersect FS_REFUELRELOAD_BASES;
};

/* If attempt failed, go for reinforcements first */
if ( _bases isEqualTo [] && _hasDead ) then {
	_bases = FS_REINFORCEMENT_BASES;
} else {
	_bases = FS_REFUELRELOAD_BASES;
};

/* If we just want to land for the night */
if ( !_hasDead && !_needsMaintenance ) then {
	_bases = FS_REFUELRELOAD_BASES + FS_REINFORCEMENT_BASES;
};

/* Select the closest base */

private _distance = 999999999999;
private _closest_base = objNull;

{
	/* Only bases of the same side are taken into consideration */
	
	if ( ( _x call FS_fnc_GetModuleOwner ) == _side ) then 
	{
		private _dist =  _x distance _aircraft;
		if ( _dist < _distance ) then {
			_distance = _dist;
			_closest_base = _x;
		};
	};
}
forEach _bases;

if ( _closest_base isEqualTo objNull ) then 
{
	// No airports defined in the editor
	if ( _debug ) then {
		diag_log "Pilot: No places to refuel & reload at";
	};
	// TODO make the helicopter fly off the map and then get deleted
}
else
{
	private _providesMaintenance = _closest_base getVariable ["providesMaintenance", False];
	private _refuelRearmTime = _closest_base getVariable ["refuelRearmTime", 60];
	
	private _providesCrew = _closest_base getVariable ["providesCrew", False];
	private _respawn_points = _closest_base getVariable ["respawn_points", []];
	
	private _pos = getPos _closest_base;
	
	[_group, currentWaypoint _group] setWaypointPosition [getPosASL ((units _group) select 0), -1];
	sleep 0.1; // Delay added as per recommendation from https://community.bistudio.com/wiki/deleteWaypoint
	{ deleteWaypoint _x } forEachReversed waypoints _group;
	
	private _NewWP = _group addWaypoint [_pos, 0];
	_NewWP setWaypointType "MOVE";
	_NewWP setWaypointDescription "LAND AT BASE";
	_NewWP setWaypointSpeed "FULL";	
	_NewWP setWaypointBehaviour "CARELESS";	
	_NewWP setWaypointCombatMode "BLUE";	
	_NewWP setWaypointCompletionRadius 50;
	
	//_group setCurrentWaypoint [_group, 1];
	
	/* 
		Set reached_the_area to False to indicate leaving the scouting area.
		When the aircraft reaches one of its regular waypoint assigned by FS_fnc_AssignWaypoints, 
		reached_the_area will be set back to True by waypoint's activation statement.
	*/
	_aircraft setVariable ["reached_the_area", False];
	_NewWP setWaypointStatements ["true", "vehicle this land 'LAND'; deleteWaypoint [group this, currentWaypoint (group this)]"];
	
	// A short godmode to negate hard landings performed by AI 
	private _softLanding = [_aircraft, _debug] spawn 
	{
		params ["_aircraft", "_debug"];
		private _softLandingEnabled = missionNamespace getVariable ["MAINTENANCE_AI_SOFT_LANDING", true];
		if !(_softLandingEnabled) exitWith {};
		
		private _time = time;
		waitUntil {
			sleep 1;
			if (_aircraft call FS_fnc_IsScrambleNeeded) exitWith { true };
			private _height = (getPos _aircraft) # 2;
			_height < 20 || time - _time > DEF_TIMEOUT
		};
		
		// Only provide soft landings for AI controlled pilots
		if (isPlayer (currentPilot _aircraft)) exitWith {}; 
		
		if !(_aircraft call FS_fnc_IsScrambleNeeded) then {
			[_aircraft, 10] remoteExec ["FS_fnc_AddGodmodeTimespan", _aircraft]; // 10 sec of god mode
			if (_debug) then {
				diag_log "Pilot: SOFT LANDING - GODMODE ON";
			};
		};
	};
	
	if (_debug) then {
		diag_log format ["Pilot: crew damage before landing is %1", crew _aircraft apply {damage _x}];
	};
	
	while {((getPos _aircraft select 2) > 1 || _aircraft distance _pos > 200 || !(unitReady _aircraft)) && !(_aircraft call FS_fnc_IsScrambleNeeded)} do {
		sleep 1;
	};
	
	// Terminating soft landing script if it hasn't finished
	if !( scriptDone _softLanding ) then {
		if (_debug) then {
			diag_log "Pilot: SOFTLANDING IS NOT DONE, TERMINATING BY FORCE";
		};
		terminate _softLanding;
	};
	
	if (_debug) then {
		diag_log format ["Pilot: crew damage after landing is %1", crew _aircraft apply {damage _x}];
	};
	
	if !( _aircraft call FS_fnc_IsScrambleNeeded ) then 
	{
		if ( _needsMaintenance && _providesMaintenance ) then 
		{
			private _msg = "Conducting maintenance...";
			[[effectiveCommander _aircraft, _msg], {
				params ["_speaker", "_msg"];
				4 enableChannel [true, true]; 
				_speaker sideChat _msg;
			}] remoteExec ["call", 0];
			
			// Disallow the fuckers from flying until the maintenance is done.
			private _oldBeh = if ({alive _x} count crew _aircraft > 0) then [{ behaviour ((crew _aircraft select {alive _x}) # 0) },{"CARELESS"}];
			{ [_x, "CARELESS"] remoteExec ["setBehaviour", _x] } forEach crew _aircraft;
			
			sleep _refuelRearmTime;
			
			// Allow the fuckers to move again.
			{ [_x, _oldBeh] remoteExec ["setBehaviour", _x] } forEach crew _aircraft;
			
			/* Refueling */
			[_aircraft, 1] remoteExec ["setFuel", _aircraft];
			
			/* 
				Reloading all turrets and the vehicle's gunner (usually, co-pilot)
				running this globally, bc only ammo of the local turrets is ressuplied, and turrets may be owned by clients 
			*/
			[_aircraft, 1] remoteExec ["setVehicleAmmoDef", 0];
			
			/* Partially fixing all broken parts */
			private _repairTo = 1 - (missionNameSpace getVariable ["MAINTENANCE_REPAIR_EFFECTIVENESS", 0.75]);
			getAllHitPointsDamage _aircraft params ["_names", "_selections", "_damage"];
			
			if (_debug) then {
				diag_log format ["Pilot: aircraft damage before repair is %1", _damage];
			};
			
			for [{_i = 0},{_i < count _damage},{_i = _i + 1}] do {
				if ( ( _damage select _i ) > 0 ) then {
					// Just reshuffled this code a bit because the previous version suddenly 
					// stopped working after I haven't touched the code for a year 
					[[_aircraft, _names select _i, _repairTo min (_damage select _i)], {
						_this # 0 setHitPointDamage [_this # 1, _this # 2];
					}] remoteExec ["call", _aircraft];
				};
			};
			
			_msg = "Maintenance is finished, all critical systems operational.";
			[[effectiveCommander _aircraft, _msg], {
				params ["_speaker", "_msg"];
				4 enableChannel [true, true]; 
				_speaker sideChat _msg;
			}] remoteExec ["call", 0];
			
			if (_debug) then {
				diag_log format ["Pilot: aircraft damage after repair is %1", _damage];
			};
		};
		
		/* Healing the crew */
		if (_debug) then {
			diag_log format ["Pilot: crew damage before healing is %1", crew _aircraft apply {damage _x}];
		};
		
		{ if (alive _x) then { _x setDamage 0; }; } forEach crew _aircraft;
		
		if (_debug) then {
			diag_log format ["Pilot: crew damage after healing is %1", crew _aircraft apply {damage _x}];
		};
		
		/* Getting replacement crew */
		if ( _hasDead && _providesCrew ) then 
		{
			if (_debug) then {
				diag_log "Pilot: getting replacement crew";
			};
			
			private _crewCount = count crew _aircraft;
			private _deadBodies = (crew _aircraft) select {!alive _x};
			private _deadClasses = _deadBodies apply {typeOf _x}; // Known issue: class of the replacement unit the may differ from the actual class of the dead unit 
			{
				[_aircraft, _x] remoteExec ["deleteVehicleCrew", _aircraft];
			}
			forEach _deadBodies;
			
			[side _aircraft, _aircraft getVariable DEF_RADIO_TRANSMISSION_PREFIX_VAR, "BoardingStarted", _aircraft] remoteExec ["FS_fnc_TransmitOverRadio", 2];
			sleep 4;
			
			while {{alive _x} count crew _aircraft < _crewCount} do 
			{
				private _respawn_at = [0,0,0];
				if ( count _respawn_points > 0 ) then {
					_respawn_at = selectRandom _respawn_points;
				};
				
				private _class = _deadClasses # 0; // Known issue: class of the replacement unit the may differ from the actual class of the dead unit 
				
				_class createUnit [_respawn_at, _group, "", random 1, "PRIVATE"];
				private _newMan = units _group select ( units _group findIf { vehicle _x != _aircraft } );
				
				if (_debug) then {
					diag_log format ["Pilot: unit created %1 (%2)", _newMan, typeOf _newMan];
				};
				
				if (isClass (configFile >> "CfgPatches" >> "RNG_mod")) then {
					_newMan setVariable ["RNG_disabled",true,true]; 
				};
				
				[_newMan] orderGetIn true; 
				
				/* 
					If no respawn points were provided, teleport the replacement 
					directly into the helicopter, otherwise make him run and board it
				*/
				if ( _respawn_at isEqualTo [0,0,0] ) then 
				{
					if (_debug) then {
						diag_log "Pilot: no Respawn Point synced to Air Base, teleport new crew members inside";
					};
					
					//-- Seat assignment seems to use the following priority logic:
					//-- driver (moveInDriver) → commander (moveInCommander) → gunner (moveInGunner) → turrets (moveInTurret) → cargo (moveInCargo).
					_newMan moveInAny _aircraft;
				}
				else
				{
					if (_debug) then {
						diag_log "Pilot: waiting for crew to get inside";
					};
					
					private _time = time;
					waitUntil { sleep 0.5; 
						if (isNil{ _newMan } || isNil{ _aircraft }) exitWith {true};
						if (!alive _newMan || !alive _aircraft) exitWith {true};
						if (time - _time > DEF_TIMEOUT) exitWith {true};
						{ alive _x } count units _group == {alive _x} count crew _aircraft // all alive units are inside the aircraft 
					};
					
					if (!isNil{ _newMan } && !isNil{ _aircraft }) then {
						if (alive _newMan && alive _aircraft && vehicle _newMan != _aircraft) then {
							if (_debug) then {
								diag_log "Pilot: somehow replacement crew is still not inside. Teleporting...";
							};
							sleep 1;
							
							//-- Seat assignment seems to use the following priority logic:
							//-- driver (moveInDriver) → commander (moveInCommander) → gunner (moveInGunner) → turrets (moveInTurret) → cargo (moveInCargo).
							_newMan moveInAny _aircraft;		
						};
					};
				};
				
				sleep 2;
			};
			
			if ( alive _aircraft ) then {
				[side _aircraft, _aircraft getVariable DEF_RADIO_TRANSMISSION_PREFIX_VAR, "BoardingEnded", _aircraft] remoteExec ["FS_fnc_TransmitOverRadio", 2];
			};
			sleep 4;
			
			if (_debug) then {
				diag_log "Pilot: crew replacement is finished successfully";
			};
		};
		
		/* Waiting for daytime */
		if ( !_hasDead && !_needsMaintenance ) then {
			if ( _debug && !(call FS_fnc_IsEnoughDaylight) ) then {
				diag_log "Pilot: Landed for the night"
			};
			waitUntil { sleep 5; _aircraft call FS_fnc_IsScrambleNeeded || call FS_fnc_IsEnoughDaylight };
		};
		if (_aircraft call FS_fnc_IsScrambleNeeded) exitWith {};
		
		_aircraft engineOn True;
	} 
	else 
	{
		// Aircraft was destroyed
	};
	
	// Restarting the loop that was canceled by FS_fnc_CanPerformDuties check inside FS_fnc_LoachInit
	if (_aircraft call FS_fnc_CanPerformDuties) then 
	{
		[_aircraft, _debug] spawn FS_fnc_LoachInit;
		
		/* 	Once the first waypoint is reached send a radiomessage to 
			inform ground troops about a new air-asset coming on-line */
		_aircraft spawn {
			params ["_aircraft"];
			private _time = time;
			waitUntil { sleep 1; 
				if (isNil{ _aircraft }) exitWith {true};
				if (time - _time > DEF_TIMEOUT) exitWith {true};
				_aircraft getVariable ["reached_the_area", false] || !(_aircraft call FS_fnc_CanPerformDuties) 
			};
			if ( _aircraft call FS_fnc_CanPerformDuties ) then {
				[side _aircraft, _aircraft getVariable DEF_RADIO_TRANSMISSION_PREFIX_VAR, "Returned"] remoteExec ["FS_fnc_TransmitOverRadio", 2];
			};
		};
	}
	else 
	{
		// Aircraft destroyed or can not move 
		// Aircraft got damaged 
		// One of the crew members is too injured or a dead body is inside    
		// Nighttime 
	};
};

