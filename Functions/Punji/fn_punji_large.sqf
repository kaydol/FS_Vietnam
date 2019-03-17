
_particlePos = _this;
_switchTo = "uns_tripwire_punj2_d";

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

_speed = 0;
_steps = 1; // insta

_box = _trapReplacement call BIS_fnc_boundingBoxDimensions;
_height = _box # 2;
_trapReplacement setPos ( _posAGL vectorAdd [0,0,-_height] );

for [{_i = -_height},{_i <= 0},{ _i = _i + _height / _steps }] do {
	_trapReplacement setPos [_posAGL # 0, _posAGL # 1,_i];
	_trapReplacement setVectorDirAndUp [_dir, _up];
	sleep ( _speed / _steps );
};
