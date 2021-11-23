/* ----------------------------------------------------------------------------
Function: FS_fnc_DropNapalm

Description:
	A wrapper for easier CAS with napalm bombs.
	
Parameters:
    _this select 0: POSITION - position of the first bomb to be dropped at
    _this select 1: POSITION or NUMBER [OPTIONAL] - a second position needed to calculate direction of the strike, 
					or the direction of the plane itself
	_this select 2: BOOL [OPTIONAL] - debug
	
Returns:
    Nothing.

Author:
    kaydol
---------------------------------------------------------------------------- */

// Processing input parameters

private _debug = false;
private _direction = random 360;
private _beginPos = _this # 0;

if (count _this > 1) then {
	if ( _this # (count _this - 1) isEqualType true ) then {
		_debug = _this # (count _this - 1);
		_this resize (count _this - 1);
	};
};

if (_this isEqualTypeAll [] && count _this == 2) then { // supplied 2 coordinates
	_direction = [_this # 0, _this # 1] call BIS_fnc_dirTo;
} else {
	_direction = _this # 1;
};

// Processing done


private _center = createCenter sideLogic;
private _group = createGroup _center;
private _logic = _group createUnit ["LOGIC", _beginPos, [], 0, "NONE"];
//_logic setVariable ["vehicle", "uns_F4J_CAS"]; 
_logic setVariable ["vehicle", "vn_b_air_f4b_navy_cas"]; 
_logic setvariable ["type", 3];
_logic setvariable ["debug", _debug];
_logic setDir _direction;


/* 
	This is a legit spike to fix a bug with
	The_Unsung_Vietnam_War_Mod napalm bombs
	landing 200 meters in front of the target
*/
//if ( _planeClass == "vn_b_air_f4b_navy_cas" && _weaponTypesID == 3 ) then {
//	_pos = _logic getPos [50, direction _logic];
//	_logic setPos _pos;
//};
//if ( _planeClass == "uns_F4J_CAS" && _weaponTypesID == 3 ) then {
//	_pos = _logic getPos [350, direction _logic];
//	_logic setPos _pos;
//};
/* End spike */

[_logic, [], true] spawn FS_fnc_ModuleNapalmCAS;
