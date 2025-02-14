
params ["_aircraft", ["_debug", false]];

_aircraft flyInHeight 65;
_aircraft flyInHeightASL [65, 65, 65];

// Disable radio spam
{
	if !(isPlayer _x) then {
		_x setSpeaker "NoVoice";
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
	
	if (!isNull _aircraft && count waypoints _group > 1) then {
		_this select 0 drawArrow [_aircraft, waypointPosition [_group, currentWaypoint _group], [0,0,1,1]] 
	};
	
	", _aircraft call BIS_fnc_objectVar];
	
	_handler = findDisplay 12 displayCtrl 51 ctrlAddEventHandler ["Draw", _code];
	
};


//driver _aircraft disableAI "AUTOCOMBAT";

// The side has to be saved to find out which side this aircraft served to before it got destroyed
_aircraft setVariable ["initSide", side _aircraft]; 

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
	
	
	private _objectsToReveal = getPos _aircraft nearEntities ["Land", 300] select { !(_x isKindOf "Animal") }; // WallHack
	
	// Version 1: Fair but the aircraft it almost blind 
	//_objectsToReveal = _aircraft targets [False, 300]; // More Fair as it only returns known objects
	
	// Version 2: Wallhack 
	// Reveal units to the aircraft
	_objectsToReveal = _objectsToReveal select { getPosATL _x select 2 < 3 }; // Only reveal objects on Land (not snipers on trees)
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
	
	sleep 3;
	
};

