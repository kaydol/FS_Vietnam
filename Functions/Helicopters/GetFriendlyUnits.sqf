
params ["_aircraft"];

_side = _aircraft getVariable ["initSide", side _aircraft];

_friendlyGroups = [];
{
	if ( [side _x, _side] call BIS_fnc_sideIsFriendly && group _aircraft != _x ) then { 
		_friendlyGroups pushBack _x 
	}; 
}
forEach allGroups;

_friendlyUnits = [];

/* If the group has a radio operator, or is known to the pilot, add it to the pool of friendly units */
{
	_add = [];
	if ( _x call FS_fnc_HasRTO || { _aircraft knowsAbout _x > 0 } count units _x > 0 ) then { 
		_add = units _x select {vehicle _x isKindOf "LAND"}; 
	};
	_friendlyUnits = _friendlyUnits + _add;
}
forEach _friendlyGroups;

_friendlyUnits = _friendlyUnits select { !(_x getVariable ["UsesArsenalRoom", False]) }; // Filter out players who use Arsenal Room
_friendlyUnits 