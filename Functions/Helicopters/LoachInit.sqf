
#define DEF_SLEEP 3
#define DEF_STEPS 30
#define DEF_TIME_BETWEEN_COURSE_CORRECTIONS 30 

params ["_aircraft", ["_debug", false]];

private _group = group _aircraft;
_group allowFleeing 0; // 1 is maximum cowardice and 0 minimum. A value of 0 will disable fleeing all together

_aircraft flyInHeight 65;
_aircraft flyInHeightASL [65, 65, 65];


{
	if !(isPlayer _x) then 
	{
		_x setSpeaker "NoVoice"; // Disable radio spam
		
		if (isClass (configFile >> "CfgPatches" >> "RNG_mod")) then {
			_x setVariable ["RNG_disabled",true,true]; 
		};
	};
}
forEach crew _aircraft;


// Draw arrow to the next waypoint on map
if (_debug) then {
	
	private _code = compile format [" 
	
	private _aircraft = %1 ;
	private _group = group _aircraft;
	
	if (!isNull _aircraft && count waypoints _group > 0) then {
		_this select 0 drawArrow [_aircraft, waypointPosition [_group, currentWaypoint _group], [0,0,1,1]] 
	};
	
	", _aircraft call BIS_fnc_objectVar];
	
	waitUntil { sleep 1; !isNull findDisplay 12 };
	
	_handler = findDisplay 12 displayCtrl 51 ctrlAddEventHandler ["Draw", _code];
	
};


//driver _aircraft disableAI "AUTOCOMBAT";

private _last_course_correction_time = 0;
private _friendly_aircrafts = [];
private _k = 0;

while { _aircraft call FS_fnc_CanPerformDuties } do 
{
	if ( _k == 0 ) then 
	{
		_friendly_aircrafts = [];
		private _aircrafts = getPos _aircraft nearEntities ["Air", 1500];
		{
			if ([side _x, _aircraft getVariable ["initSide", side _aircraft]] call BIS_fnc_sideIsFriendly ) then 
			{
				_friendly_aircrafts pushBack _x;
			};
		} forEach _aircrafts;
		
		if (_debug) then {
			diag_log format ["Pilot: Friendly aircrafts %1", _friendly_aircrafts];
		};
	};
	_k = ( _k + 1 ) % 10;
	
	
	/* Adding crews of known friendly aircrafts */
	private _friendlyGroups = allGroups select { [side _x, side _aircraft] call BIS_fnc_SideIsFriendly };
	//{
	//	_friendlyGroups pushBackUnique group _x;
	//}
	//forEach _friendly_aircrafts;
	
	
	private _objectsToReveal = [];
	
	// Version 1: Fair but the aircraft it almost blind 
	//_objectsToReveal = _aircraft targets [False, 300]; // More Fair as it only returns known objects
	
	// Version 2: Wallhack 
	// Reveal units to the aircraft
	_objectsToReveal = getPos _aircraft nearEntities ["Land", 300] select { !(_x isKindOf "Animal") && !(isObjectHidden _x) && ((getPosATL _x) select 2) < 2 }; // WallHack but only reveal objects on Land (not snipers on trees)
	if (count crew _aircraft > 0) then {
		private _grp = group ((crew _aircraft) select 0);
		{_grp reveal [_x, 3]} forEach _objectsToReveal;
	};
	
	
	{
		/* Informing friendlies */
		_grp = _x;
		{
			for [{_i = 0}, {_i < count _objectsToReveal}, {_i = _i + 1}] do { 
				if ( _x call FS_fnc_CanReceive ) then 
				{
					// Increasing knowledge of friendly units about the enemy 
					[[_x, _objectsToReveal # _i, _aircraft knowsAbout _objectsToReveal # _i], {
						params ["_friend", "_foe", "_helisOwnKnowledge"];
						_knowledge = _friend knowsAbout _foe;
						_knowledge = ( _knowledge + 0.1 ) min 4;
						//_knowledge = ( _knowledge + 0.2 ) min _helisOwnKnowledge;
						_friend reveal [_foe, _knowledge];
					}] remoteExec ["call", _x];
				};
			};
		}
		forEach units _grp;
	}
	forEach _friendlyGroups;
	
	// Pushing the aircrafts towards current waypoing to make him HAUL ASS 
	// because this RETARD flies 2 FUCKING kilometers away from his waypoint 
	// and then takes his SWEET time getting back
	private _group = group _aircraft;
	private _time = time;
	private _isPosHidden = [getPosASL _aircraft, [] call BIS_fnc_listPlayers, _aircraft] call FS_fnc_IsPosHidden;
	
	if (_isPosHidden && count waypoints _group > 0 && getPos _aircraft select 2 > 30 && time - _last_course_correction_time > DEF_TIME_BETWEEN_COURSE_CORRECTIONS) then 
	{
		_last_course_correction_time = time;
		
		private _wpPos = waypointPosition [_group, currentWaypoint _group];
		private _maxSpeed = 50;
		private _i = 0;
		for [{_i = 0},{_i < DEF_STEPS},{_i = _i + 1}] do 
		{
			sleep (DEF_SLEEP/DEF_STEPS);
			
			private _velocity = velocity _aircraft;
			private _dirAlpha = linearConversion [_time, _time + DEF_SLEEP, time, 0, 1];
			private _velocityAlpha = linearConversion [_time, _time + DEF_SLEEP, time, 0, 1];
			
			//-- lerp dir
			private _dir = vectorDirVisual _aircraft;
			_dir set [2, 0];
			_dir = vectorNormalized _dir;
			private _p1 = position _aircraft;
			private _p2 = _wpPos;
			private _dirToTarget = vectorNormalized [_p2 # 0 - _p1 # 0, _p2 # 1 - _p1 # 1, 0];
			private _newDir = [_dir, _dirToTarget, _dirAlpha] call BIS_fnc_slerp;
			
			//-- lerp velocity
			private _vectorToTarget = vectorNormalized ((getPosATL _aircraft) vectorFromTo _wpPos);
			private _newVelocity = _vectorToTarget vectorMultiply _maxSpeed;
			
			_newVelocity set [2, 0];
			
			private _lerp = [_velocity, _newVelocity, _velocityAlpha] call BIS_fnc_lerpVector;
			
			//-- lerp pitch bank
			//private _pitchBank = (_aircraft call BIS_fnc_getPitchBank) params ["_pitch", "_bank"];
			//private _newPitch = linearConversion [0, 1, _dirAlpha, _pitch, -35, true];
			//private _newBank = linearConversion [0, 1, _dirAlpha, _bank, 0, true];
			
			_aircraft setVectorDir _newDir;
			//[_aircraft, _newPitch, _newBank] call BIS_fnc_setPitchBank;
			_aircraft setVelocity _lerp;
		};
	};
	
	sleep DEF_SLEEP;
};

