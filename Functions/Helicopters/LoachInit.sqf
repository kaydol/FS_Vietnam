
params ["_aircraft", "_debug"];

_aircraft flyInHeight 65;
_aircraft flyInHeightASL [65, 65, 65];

// Disable radio spam
{
	if !(isPlayer _x) then {
		_x setSpeaker "NoVoice";
	};
}
forEach crew _aircraft;

//driver _aircraft disableAI "AUTOCOMBAT";

/* Storing the vehicle role is needed because the unit's vehicle role is lost after unit is dead, so we have to save his role before that happens in order to be able to correctly reinforce lost crewmates at base */
{
	_x setVariable ["role", assignedVehicleRole _x];
} forEach crew _aircraft;

// The side has to be saved to find out which side this aircraft served to before it got destroyed
_aircraft setVariable ["initSide", side _aircraft]; 


_friendly_aircrafts = [];
_k = 0;

while { _aircraft call FS_fnc_CanPerformDuties } do 
{
	if ( _k == 0 ) then 
	{
		_friendly_aircrafts = [];
		_aircrafts = getPos _aircraft nearEntities ["Air", 1500];
		{
			if ([side _x, side _aircraft] call BIS_fnc_sideIsFriendly ) then 
			{
				_friendly_aircrafts pushBack _x;
			};
		} forEach _aircrafts;
		
		if (_debug) then {
			diag_log format ["Friendly aircrafts %1", _friendly_aircrafts];
		};
	};
	_k = ( _k + 1 ) % 10;
	
	
	/* Adding crews of known friendly aircrafts */
	_friendlyGroups = allGroups select { [side _x, side _aircraft] call BIS_fnc_SideIsFriendly };
	//{
	//	_friendlyGroups pushBackUnique group _x;
	//}
	//forEach _friendly_aircrafts;
	
	
	//_objectsToReveal = getPos _aircraft nearEntities ["Land", 300] select { !(_x isKindOf "Animal") }; // WallHack
	_objectsToReveal = _aircraft targets [False, 300]; // More Fair as it only returns known objects
	
	{
		/* Informing friendlies */
		_grp = _x;
		{
			for [{_i = 0}, {_i < count _objectsToReveal}, {_i = _i + 1}] do { 
				if ( _x call FS_fnc_HasRadioAround ) then 
				{
					// Increasing knowledge of friendly units about the enemy 
					[[_x, _objectsToReveal # _i, _aircraft knowsAbout _objectsToReveal # _i], {
						params ["_friend", "_foe", "_helisOwnKnowledge"];
						_knowledge = _friend knowsAbout _foe;
						_knowledge = ( _knowledge + 0.2 ) min 4;
						//_knowledge = ( _knowledge + 0.2 ) min _helisOwnKnowledge;
						_friend reveal [_foe, _knowledge];
					}] remoteExec ["call", _x];
				};
			};
		}
		forEach units _grp;
	}
	forEach _friendlyGroups;
	
	sleep 5;
	
};

