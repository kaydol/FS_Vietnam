
params [["_pos", [], [[]]], ["_target",[]], ["_gookSensesRadius", 200], ["_groupSize", 5 + ceil random 6, [0]], ["_groupsCount", 1, [0]], ["_customClasses", [], [[]]], ["_assignedCurator", objNull], ["_debug", false, [true]]];

private _baseclass = "O_T_Soldier_F"; // Chinese speaking asian
private _pool = [];

if !( _customClasses isEqualTo [] ) then {
	_pool = _customClasses;
}
else {
	private _pools = [];
	{
		if (isClass (ConfigFile >> "CfgPatches" >> _x)) then {
			private _units = ((getArray( ConfigFile >> "CfgPatches" >> _x >> "units")) apply {toLowerANSI _x}) select {_x find "vn_o_men_" >= 0};
			if !( _units isEqualTo [] ) then { _pools pushBack _units };
		};
	}
	forEach ["characters_f_vietnam_c"];
	
	_pool = selectRandom _pools;
};

if (_debug) then {
	diag_log format ["Gook Manager: Spawning %1 Gooks", _groupsCount * _groupSize, time];
};

private _validCurator = false;
//-- If _assignedCurator is given as a string, try to get the global variable out of it 
if (_assignedCurator isEqualType "" && !(_assignedCurator isEqualTo "")) then {
	_assignedCurator = missionNameSpace getVariable [_assignedCurator, objNull];
};
if (_assignedCurator isEqualType objNull && alive _assignedCurator) then {
	_validCurator = true;
};

private _side = EAST;
private _i = 0;
for [{_i=0},{_i < _groupsCount},{_i=_i+1}] do 
{
	private _NewGrp = createGroup _side;
	
	if ( isNull _NewGrp ) exitWith {
		/* The group limit has been reached */
	};
	
	private _j = 0;
	for [{_j=0},{_j < _groupSize},{_j=_j+1}] do {
		if ( count _pool > 0 ) then {
			_baseclass = selectRandom _pool;
		};
		_baseclass createUnit [ASLToAGL _pos, _NewGrp, "", 0, "PRIVATE"];
		sleep 0.5;
	};
	
	if (_validCurator || count _pool == 0) then {
		for [{_j=0},{_j < count units _NewGrp},{_j=_j+1}] do {
			private _unit = units _NewGrp select _j;
			if ( count _pool == 0 ) then {
				//-- Try to substitute Gook equpment with Tanoa assets 
				_unit spawn FS_fnc_AuthenticLoadout;
			};
			if (_validCurator) then {
				_assignedCurator addCuratorEditableObjects [[_unit], false];
			};
			
			//-- Remove toolkit to prevent players from defusing traps easily  
			_unit removeItem "vn_b_item_toolkit";
			
			sleep 0.5;
		};
	};
	
	[_NewGrp, _target, _gookSensesRadius, _debug] execFSM "\FS_Vietnam\FSM\GookGroup.fsm";
	
	if ( _debug ) then {
		// Group markers
		[_NewGrp, 'o_inf'] spawn FS_fnc_GrpAttachDebugMarkers;
	};
};