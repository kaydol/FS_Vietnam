/*
	Returns position ASL or []
	If _verbose, also returns anchor unit
	
*/

params ["_unitsToHideFrom", ["_distance", 100], ["_verbose", False], ["_angle", [0, 360]], ["_attempts", 10]];

private _pos = [];
private _cansee = True;
private _pos_found = False;
private _anchor = objNull;
private _p = [];

_angle params ["_minAngle", "_maxAngle"];
private _angleRange = _maxAngle - _minAngle;

while { !_pos_found && _attempts > 0 } do 
{
	_attempts = _attempts - 1;
	_pos_found = True;
	{
		_anchor = _x;
		_p = AGLToASL ( _anchor getPos [_distance, _minAngle + random _angleRange] );
		{
			_cansee = [objNull, "VIEW"] checkVisibility [eyePos _x, _p] > 0.3 ;
			_water = surfaceIsWater _p;
			if ( _cansee || _water ) exitWith { _pos_found = False; };
		}
		forEach _unitsToHideFrom;
		
		if ( _pos_found ) exitWith {
			_pos = _p;
		};
	}
	forEach _unitsToHideFrom;
};

_result = _pos;

if ( _verbose ) then {
	_result = [_pos,  _anchor];
};

_result

