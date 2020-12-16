
params ["_pos", "_unitsToHideFrom"];

private _cansee = False;
private _p = _pos;
_p = _p vectorAdd [0,0,1.8]; // elevate p to represent a height of a standing person

{
	_cansee = [objNull, "VIEW"] checkVisibility [eyePos _x, _p] > 0.3 ;
	if ( _cansee ) exitWith {};
}
forEach _unitsToHideFrom;
	
_cansee 
