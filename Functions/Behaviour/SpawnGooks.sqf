
params ["_ailimit", "_groupSize", "_groupsCount", "_debug"];

private _allPlayers = call BIS_fnc_listPlayers;

_allPlayers = _allPlayers select { side _x != EAST }; // Filter out Gook players
_allPlayers = [_allPlayers] call FS_fnc_FilterObjects; // Filter out players who use Arsenal Room

if ( {alive _x} count _allPlayers == 0 ) exitWith {
	// All players are dead, so nobody to spawn around
};

private _target = selectRandom _allPlayers;

/* 
	If The Unsung Vietnam War Mod is not enabled, try to substitute 
	real Gooks with Chinese speaking asians with Tanoa weapons 
*/
private _baseclass = "O_T_Soldier_F"; 

/* 
	If The Unsung Vietnam War Mod is enabled, select a random
	pool of classes corresponding with a vietnamese regiment
*/
private _TheUnsungVietnamWarModEnabled = isClass( ConfigFile >> "CfgPatches" >> "uns_men_NVA_daccong" );
private _pools = [];
private _pool = [];
if ( _TheUnsungVietnamWarModEnabled ) then {
	{
		if (isClass (ConfigFile >> "CfgPatches" >> _x)) then {
			private _units = getArray ( ConfigFile >> "CfgPatches" >> _x >> "units" );
			if !( _units isEqualTo [] ) then { _pools pushBack _units };
		};
	}
	forEach ["uns_men_NVA_daccong", "uns_men_NVA_65", "uns_men_NVA_68", "uns_men_VC_mainforce", "uns_men_VC_mainforce_68", "uns_men_VC_recon", "uns_men_VC_regional", "uns_men_VC_local"];
	_pool = selectRandom _pools;
};

private _side = EAST;

for [{_i=0},{_i < _groupsCount},{_i=_i+1}] do 
{
	// To prevent EPIC FPS DROP; waiting before spawning next portion of soldiers
	if (({side _x == _side && alive _x} count allUnits) >= _ailimit) then 
	{
		WaitUntil {sleep 0.5; ({side _x == _side && alive _x} count allUnits) <= ( _ailimit - _groupSize * _groupsCount )};
	};
	
	private _result = [_allPlayers, 200, True] call FS_fnc_GetHiddenPos;
	_result params ["_pos", "_target"];
	
	if ( _pos isEqualTo [] && _debug ) exitWith { systemChat "GookManager couldn't find a spot to spawn gooks"; };
	systemChat "GookManager has found a spot";
	
	private _NewGrp = createGroup _side;
	
	if ( isNull _NewGrp ) exitWith {
		/* The group limit has been reached */
	};
	
	for [{_j=0},{_j < _groupSize},{_j=_j+1}] do {
		if ( _TheUnsungVietnamWarModEnabled ) then {
			_baseclass = selectRandom _pool;
		};
		_baseclass createUnit [ASLToAGL _pos, _NewGrp, "", 0.3, "PRIVATE"];
		sleep 0.75;
	};
	
	if !( _TheUnsungVietnamWarModEnabled ) then {
		for [{_j=0},{_j < _groupSize},{_j=_j+1}] do {
			private _unit = units _NewGrp select _j;
			_unit spawn FS_fnc_AuthenticLoadout;
			sleep 0.5;
		};
	};
	/*
	_NewWP = _NewGrp addWaypoint [getPos _target, 5];
	_NewWP setWaypointType "SAD";
	_NewWP setWaypointSpeed "NORMAL";	
	_NewWP setWaypointBehaviour "STEALTH";	
	_NewWP setWaypointCombatMode "RED";	
	_NewGrp allowFleeing 0;
	*/
	
	/* Supply _target to make the group move towards it */
	[_NewGrp, _target] execFSM "\FS_Vietnam\FSM\GookGroup.fsm";
	
	/* Do not supply target to make the group stay where it is and wait for enemies */
	//[_NewGrp] execFSM "\FS_Vietnam\FSM\GookGroup.fsm";
	
	if (_debug) then {
		// Group markers
		[_NewGrp, 'o_inf'] spawn FS_fnc_GroupMarkers;
	};
};