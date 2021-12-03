
params ["_aircraft", "_debug"];

/*
	First, updating the stations to indicate that this aircraft
	has left its station 
*/
_side = _aircraft getVariable ["initSide", side _aircraft];
[_side, "AIRSTATIONS", _aircraft] call FS_fnc_UpdateSideVariable;

_group = group _aircraft;
_bases = [];

_needsMaintenance = _aircraft call FS_fnc_IsMaintenanceNeeded;
_hasDead = {!alive _x} count crew _aircraft > 0;
_hasAlive = {alive _x} count crew _aircraft > 0;

if ( _hasDead && _hasAlive ) then {
	[side _aircraft, "CrewMemberDown", nil, _aircraft] remoteExec ["FS_fnc_TransmitOverRadio", 2];
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

_distance = 999999999999;
_closest_base = objNull;

{
	_synced = synchronizedObjects _x; 
	
	/* Only bases of the same side are taken into consideration */
	
	if ( ( _x call FS_fnc_GetModuleOwner ) == side _aircraft ) then 
	{
		_dist =  _x distance _aircraft;
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
	_providesMaintenance = _closest_base getVariable ["providesMaintenance", False];
	_refuelRearmTime = _closest_base getVariable ["refuelRearmTime", 60];
	
	_providesCrew = _closest_base getVariable ["providesCrew", False];
	_respawn_points = _closest_base getVariable ["respawn_points", []];
	
	_pos = getPos _closest_base;
	
	while { count waypoints _group > 1 } do {
		deleteWaypoint [_group, 1];
	};
	
	_NewWP = _group addWaypoint [_pos, 0];
	_NewWP setWaypointType "MOVE";
	_NewWP setWaypointDescription "LAND AT BASE";
	_NewWP setWaypointSpeed "FULL";	
	_NewWP setWaypointBehaviour "AWARE";	
	_NewWP setWaypointCombatMode "RED";	
	_NewWP setWaypointCompletionRadius 50;
	
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
	
		waitUntil {
			sleep 1;
			if (_aircraft call FS_fnc_IsScrambleNeeded) exitWith { true };
			private _height = (getPos _aircraft) # 2;
			_height < 20
		};
		
		// Only provide soft landings for AI controlled pilots
		if (isPlayer (currentPilot _aircraft)) exitWith {}; 
		
		if !(_aircraft call FS_fnc_IsScrambleNeeded) then {
			[_aircraft, false] remoteExec ["allowDamage", _aircraft];
			if (_debug) then {
				systemChat format ["(%1) SOFT LANDING: GODMODE ON", time];
			};
		};
		
		sleep 10; // 10 sec of god mode
		
		if !(_aircraft call FS_fnc_IsScrambleNeeded) then {
			[_aircraft, true] remoteExec ["allowDamage", _aircraft];
			if (_debug) then {
				format ["(%1) SOFT LANDING: GODMODE OFF", time];
			};
		};
	};
	
	while {((getPos _aircraft select 2) > 1 || _aircraft distance _pos > 200 || !(unitReady _aircraft)) && !(_aircraft call FS_fnc_IsScrambleNeeded)} do {
		sleep 1;
	};
	
	// Terminating soft landing script if it hasn't finished
	if !( scriptDone _softLanding ) then {
		systemchat format ["(%1) SOFTLANDING IS NOT DONE, TERMINATING BY FORCE", time];
		terminate _softLanding;
		if !(_aircraft call FS_fnc_IsScrambleNeeded) then {
			[_aircraft, false] remoteExec ["allowDamage", _aircraft];
		};
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
			
			/* Healing the crew */
			{ if (alive _x) then { [_x, 0] remoteExec ["setDamage", _x]; }; } forEach crew _aircraft;
			 
			/* Partially fixing all broken parts */
			private _repairTo = 1 - (missionNameSpace getVariable ["MAINTENANCE_REPAIR_EFFECTIVENESS", 0.75]);
			getAllHitPointsDamage _aircraft params ["_names", "_selections", "_damage"];
			
			for [{_i = 0},{_i < count _damage},{_i = _i + 1}] do {
				if ( ( _damage select _i ) > 0 ) then {
					// Just reshuffled this code a bit because the previous version suddenly 
					// stopped working after I haven't touched the code for a year 
					[[_aircraft, _names select _i, _repairTo min (_damage select _i)], {
						_this # 0 setHitPointDamage [_this # 1, _this # 1];
					}] remoteExec ["call", _aircraft];
				};
			};
			
			_msg = "Maintenance is finished, all critical systems operational.";
			[[effectiveCommander _aircraft, _msg], {
				params ["_speaker", "_msg"];
				4 enableChannel [true, true]; 
				_speaker sideChat _msg;
			}] remoteExec ["call", 0];
		};
		
		/* Getting replacement crew */
		if ( _hasDead && _providesCrew ) then 
		{
			[side _aircraft, "BoardingStarted", _aircraft] remoteExec ["FS_fnc_TransmitOverRadio", 2];
			sleep 4;
			
			while {{!alive _x} count crew _aircraft > 0} do 
			{
				_respawn_at = [0,0,0];
				if ( count _respawn_points > 0 ) then {
					_respawn_at = selectRandom _respawn_points;
				};
				
				_index = crew _aircraft findIf {!alive _x};
				_dead_unit = crew _aircraft select _index;
				
				_class = typeOf _dead_unit;
				_class createUnit [_respawn_at, _group, "", random 1, "PRIVATE"];
				_newMan = units _group select ( units _group findIf { vehicle _x != _aircraft } );

				[_newMan] orderGetIn true; 
				
				/* 
					If no respawn points were provided, teleport the replacement 
					directly into the helicopter, otherwise make him run and board it
				*/
				if ( _respawn_at isEqualTo [0,0,0] ) then 
				{
					_newMan moveInAny _aircraft;
				}
				else 
				{
					waitUntil { sleep 0.5; { _x in _aircraft } count units _group == count crew _aircraft || !alive _aircraft };
				};
				
				[_dead_unit, _aircraft] remoteExec ["deleteVehicleCrew", _aircraft];
				
				sleep 2;
			};
			
			if ( alive _aircraft ) then {
				[side _aircraft, "BoardingEnded", _aircraft] remoteExec ["FS_fnc_TransmitOverRadio", 2];
			};
			sleep 4;
		};
		
		/* Waiting for daytime */
		if ( !_hasDead && !_needsMaintenance ) then {
			if ( _debug ) then {
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
			waitUntil { sleep 1; _this getVariable ["reached_the_area", false] || !(_this call FS_fnc_CanPerformDuties) };
			if ( _this call FS_fnc_CanPerformDuties ) then {
				[side _this, "NewPilot"] remoteExec ["FS_fnc_TransmitOverRadio", 2];
			};
		};
	};
};

