/* ----------------------------------------------------------------------------
Function: FS_fnc_PunjiTrapFired

Description:
	Replaces the trap with the fired version of this trap.
	
Parameters:
    _trapPos - position where the punji trap has fired.
	_typeOfReplacement - class of the fired version of the trap. 
	
Returns:
    [_trapReplacement, _posAGL, _dir, _up] - created object with the type of _typeOfReplacement, 
		the position and orientation of the trap if the information about this punji trap was found 
		in the FS_AllGookTraps array, otherwise [].

Author:
    kaydol
---------------------------------------------------------------------------- */

params ["_particlePos", "_switchTo"];

// Finding the mine in the table by comparing coordinates
private _minDist = -1;
private _id = -1;
{
	if ( _x isEqualType [] ) then 
	{
		_x params ["_mine", "_posAGL", "_orientation"];
		private _dist = _posAGL distance _particlePos;
		if ( _minDist > _dist || _minDist < 0) then {
			_minDist = _dist;
			_id = _forEachIndex;
		};
	};
}
forEach FS_AllGookTraps;

if ( _id < 0 ) exitWith { /* No punji traps in FS_AllGookTraps */ [] };

FS_AllGookTraps # _id params ["_mine", "_posAGL", "_orientation"];

if !(isNull _mine) exitWith {
	/* This script already fired for this mine... */
	[]
};

_orientation params ["_dir", "_up"];

// Replacing the objNull with a reference to _trapReplacement
private _trapReplacement = createVehicle [_switchTo, _posAGL, [], 0, "CAN_COLLIDE"];
(FS_AllGookTraps # _id) set [0, _trapReplacement]; 

[_trapReplacement, _posAGL, _dir, _up]
 