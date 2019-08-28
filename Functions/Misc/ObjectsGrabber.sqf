/* ----------------------------------------------------------------------------
Function: FS_fnc_ObjectsGrabber
Description:
	Grabs positions ASL, direction, and orientation of nearby objects.
	This function was used to create an armory room used in FS Arsenal module.
	
	The initial room was built in Virtual Reality map, then grabbed,
	the player's avatar removed from the list and put in _playerPosInRoom 
	and _playerDirInRoom variables inside FS_fnc_ArsenalRoom. 
	
	The rest of the array was placed in FS_fnc_ArsenalRoomCreate.
	
Parameters:
    _anchor - the object, center of the grab radius [Object].
    _grabRadius - radius of the grabbing [Number].
    
Returns:
    An array of [typeOf _obj, _objPosASL, _vectorDirAndUp, _objPitchBank] 

Author:
    kaydol
---------------------------------------------------------------------------- */

params ["_anchor", "_grabRadius"]; 
 
_entities = _anchor nearObjects _grabRadius; 
_entities = _entities apply { [typeOf _x, (getPosASL _x), [vectorDir _x, vectorUp _x], _x call BIS_fnc_getPitchBank] }; 
 
/* Normalization of coordinates */
_minX = 1e6; 
_minY = 1e6; 
_minZ = 1e6; 
{ 
	_p = _x # 1; 
	if ( _p # 0 < _minX ) then { 
		_minX = _p # 0;
		_minY = _p # 1;
		_minZ = _p # 2;
	} 
	else {
		if ( _p # 1 < _minY ) then {  
			_minX = _p # 0;
			_minY = _p # 1;
			_minZ = _p # 2;
		
		} 
		else {
			if ( _p # 2 < _minZ ) then {  
				_minX = _p # 0;
				_minY = _p # 1;
				_minZ = _p # 2;
			}; 
		};
	};
	
} forEach _entities; 

_entities = _entities apply { [_x # 0, (_x # 1 vectorDiff [_minX, _minY, _minZ]), _x # 2, _x # 3] }; 

copyToClipBoard str _entities; 