
/* ----------------------------------------------------------------------------
Function: FS_fnc_IsPosHidden

Description:
	
	
Parameters:
    _pos - Position: position of the object being tested
	_unitsToHideFrom - Array: array of units to check visibility against 
	_objectToIgnore1 - Object: object to be ignored when checking visibility
	_objectToIgnore2 - Object: object to be ignored when checking visibility
	
Returns:
    BOOL - true if position can be seen by units.

Author:
    kaydol
---------------------------------------------------------------------------- */

params ["_posASL", "_unitsToHideFrom", ["_objectToIgnore1", objNull], ["_objectToIgnore2", objNull]];

private _cansee = false;

{
	_cansee = [_objectToIgnore1, "VIEW", _objectToIgnore2] checkVisibility [eyePos _x, _posASL] > 0.3 ;
	if ( _cansee ) exitWith {};
}
forEach _unitsToHideFrom;
	
!_cansee 

