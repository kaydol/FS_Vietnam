
/*
	The unit is able to listen to radio comms if he has any kind of radio
*/
if ( _this call FS_fnc_HasRadio ) exitWith { True };

/*
	If he does not have any radio, check surroundings in case any of his buddies has, 
	or there is a vehicle nearby
*/
_radioAround = False;
_nearestObjects = _this nearEntities 10;
{
	if ( [side _x, side _this] call BIS_fnc_sideIsFriendly && _x call FS_fnc_HasRadio ) exitWith {
		_radioAround = True;
	};
	
} forEach _nearestObjects;

_radioAround 