
/*
	The unit is able to listen to radio comms if he has any kind of radio
*/
if ( _this call FS_fnc_HasRTO ) exitWith { True };

/*
	If he does not have any radio, check surroundings in case any of his buddies has, 
	or there is a vehicle nearby
*/
_ableToReceiveRadioComms = False;
_nearestObjects = _this nearEntities 10;
{
	if ( [side _x, side _this] call BIS_fnc_sideIsFriendly && _x call FS_fnc_HasRTO ) exitWith {
		_ableToReceiveRadioComms = True;
	};
	
} forEach _nearestObjects;

_ableToReceiveRadioComms 