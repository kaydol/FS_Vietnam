
_particlePos = _this;
_switchTo = "uns_tripwire_punj4_d";

if !(isServer || isDedicated) exitWith {};
if ( isNil{ FS_AllGookTraps }) exitWith {};

// Finding the mine in the table by comparing coordinates
_minDist = -1;
_id = -1;
{
	if ( _x isEqualTo [] ) then 
	{
		_x params ["_mine", "_posAGL", "_orientation"];
		_dist = _posAGL distance _particlePos;
		if ( _minDist > _dist || _minDist < 0) then {
			_minDist = _dist;
			_id = _forEachIndex;
		};
	};
}
forEach FS_AllGookTraps;

if ( _id < 0 ) exitWith { /* No punji traps in FS_AllGookTraps */ };

FS_AllGookTraps # _id params ["_mine", "_posAGL", "_orientation"];

if !(isNull _mine) exitWith {
	/* This script already fired for this mine... */
};

_orientation params ["_dir", "_up"];

// Replacing the objNull with a reference to _trapReplacement
_trapReplacement = _switchTo createVehicle _posAGL;
(FS_AllGookTraps # _id) set [0, _trapReplacement]; 


/*
	Animate
*/

_speed = 0.1;
_steps = 5;

_trapReplacement setPos _posAGL;
_trapReplacement setVectorDirAndUp [_dir vectorMultiply -1, _up];

for [{_i = -90},{_i <= 0},{ _i = _i + 90 / _steps }] do {
	[_trapReplacement, _i, 0] call BIS_fnc_setPitchBank; 
	sleep ( _speed / _steps );
};
