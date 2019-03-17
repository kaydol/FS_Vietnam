
params ["_aircraft"];

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
	systemChat "Pilot: No places to refuel & reload at";
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
	
	
	while {((getPos _aircraft select 2) > 1 || _aircraft distance _pos > 200 || !(unitReady _aircraft)) && !(_aircraft call FS_fnc_IsScrambleNeeded)} do {
		sleep 1;
	};
	
	if !( _aircraft call FS_fnc_IsScrambleNeeded ) then 
	{
		if ( _needsMaintenance && _providesMaintenance ) then 
		{
			sleep _refuelRearmTime;
			
			/* Refueling */
			[_aircraft, 1] remoteExec ["setFuel", 0];
			
			/* Reloading turrets */
			[_aircraft, 1] remoteExec ["setVehicleAmmo", 0];
			
			/* Healing the crew */
			{ if (alive _x) then { [_x, 0] remoteExec ["setDamage", _x]; }; } forEach crew _aircraft;
			 
			/* Partially fixing all broken parts */
			getAllHitPointsDamage _aircraft params ["_names", "_trash", "_damage"];
			
			for [{_i = 0},{_i < count _damage},{_i = _i + 1}] do {
				if ( ( _damage select _i ) > 0 ) then {
					[_aircraft, [_names select _i, 0.5 min (_damage select _i)]] remoteExec ["setHitPointDamage", _aircraft];
				};
			};
		};
		
		/* Getting replacement crew */
		if ( _hasDead && _providesCrew ) then 
		{
			_k = 0;
			
			[side _aircraft, "BoardingStarted", _aircraft] remoteExec ["FS_fnc_TransmitOverRadio", 2];
			sleep 4;
			
			while {{!alive _x} count crew _aircraft > _k} do 
			{
				_k = _k + 1;
				
				_respawn_at = [0,0,0];
				if ( count _respawn_points > 0 ) then {
					_respawn_at = selectRandom _respawn_points;
				};
				
				_index = crew _aircraft findIf {!alive _x};
				_dead_unit = crew _aircraft select _index;
				//_role = assignedVehicleRole _dead_unit;
				_role = _dead_unit getVariable "role";
				_class = typeOf _dead_unit;
				_class createUnit [_respawn_at, _group, "", random 1, "PRIVATE"];
				_newMan = units _group select ( units _group findIf { vehicle _x != _aircraft } );
				
				/*
					This command attempts to move the given crew member out before deleting it. Made especially for deleting dead crew members, as using conventional deleteVehicle leads to all sorts of bugs and ghost objects. While the argument is global, you should take extra steps and execute this where vehicle is local as moving units out of the vehicle happens where vehicle is local and you want this to always precede deletion.
				*/
				_dead_unit remoteExec ["deleteVehicleCrew", _aircraft];
				
				switch ( _role select 0 ) do {
					case "Turret": { _newMan assignAsTurret [_aircraft, _role select 1]; };
					case "Driver": { _newMan assignAsDriver _aircraft; };
					case "Cargo": { _newMan assignAsCargo _aircraft; };
					default {}
				};
				
				[_newMan] orderGetIn true; 
				
				/* 
					If no respawn points were provided, teleport the replacement 
					directly into the helicopter, otherwise make him run and board it
				*/
				if ( _respawn_at isEqualTo [0,0,0] ) then 
				{
					waitUntil { sleep 0.5; { _x in _aircraft } count units _group == count crew _aircraft || !alive _aircraft };
				}
				else 
				{
					switch ( _role select 0 ) do {
						case "Turret": { _newMan moveInTurret [_aircraft, _role select 1]; };
						case "Driver": { _newMan moveInDriver _aircraft; };
						case "Cargo": { _newMan moveInCargo _aircraft; };
						default {}
					};
				};
				
				sleep 2;
			};
			
			if ( alive _aircraft ) then {
				[side _aircraft, "BoardingEnded", _aircraft] remoteExec ["FS_fnc_TransmitOverRadio", 2];
			};
			sleep 4;
		};
		
		_aircraft engineOn True;

	} 
	else 
	{
		// Aircraft was destroyed
	};
	
	// Restarting the loop that was canceled by FS_fnc_CanPerformDuties check inside FS_fnc_LoachInit
	if (_aircraft call FS_fnc_CanPerformDuties) then 
	{
		_aircraft spawn FS_fnc_LoachInit;
		
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

