/*
	Returns position ASL or []
	If _verbose, also returns anchor unit
	
*/

params ["_unitsToHideFrom", "_anchor", ["_distance", 100], ["_angle", [0, 360]], ["_attempts", 10], ["_debug", false]];

private _cansee = True;
private _pos_found = False;
private _result = [];

_angle params ["_minAngle", "_maxAngle"];
private _angleRange = _maxAngle - _minAngle;

while { !_pos_found && _attempts > 0 } do 
{
	_attempts = _attempts - 1;
	_pos_found = True;
	
	private _p = AGLToASL ( _anchor getPos [_distance, _minAngle + random _angleRange] );
	_p = _p vectorAdd [0,0,1.8]; // elevate p to represent a height of a standing person
	{
		_cansee = [objNull, "VIEW"] checkVisibility [eyePos _x, _p] > 0.3 ;
		_water = surfaceIsWater _p;
		if ( _cansee || _water ) exitWith { _pos_found = False; };
	}
	forEach _unitsToHideFrom;
	
	if ( _pos_found ) exitWith {
		_result = _p;
	};
};

_result

