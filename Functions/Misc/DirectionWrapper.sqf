/* ----------------------------------------------------------------------------
Function: FS_fnc_DirectionWrapper

Description:
	A wrapper that takes any number (including negative ones) for input and
	converts it into an 0-360 azimuth. 
	
Parameters:
    _direction - "bad" bearing, can be negative, can exceed +-360 [Number].
    
Returns:
    Normalized direction, e.g. a number from [0,360] 

Examples:
	(begin example)
	_dir = [-780] call FS_fnc_DirectionWrapper;
	(end)

Author:
    kaydol
---------------------------------------------------------------------------- */


params ["_direction"];

while {_direction < 0} do { _direction = _direction + 360; };
while {_direction >= 360} do { _direction = _direction - 360; };

_direction 