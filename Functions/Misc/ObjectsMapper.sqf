/* ----------------------------------------------------------------------------
Function: FS_fnc_ObjectsMapper
Description:
	Builds a set of objects in given coordinates.
	This function was used to create an armory room used in FS Arsenal module.
	
	The initial room was built in Virtual Reality map, then grabbed,
	the player's avatar removed from the list and put in _playerPosInRoom 
	and _playerDirInRoom variables inside FS_fnc_ArsenalRoom. 
	
	The rest of the array was placed in FS_fnc_ArsenalRoomCreate.
	
Parameters:
    _pos - position where to build [ARRAY].
    _objects - array of [typeOf _obj, _objPosASL, _vectorDirAndUp, _objPitchBank] [ARRAY].
    
Author:
    kaydol
---------------------------------------------------------------------------- */

params ["_pos", "_objects", ["_createAsSimpleObjects", false]];

{
	private "_obj";
	_x params ["_type", "_relPos", "_dirUp", "_pitchBank"];
	
	if (_createAsSimpleObjects) then {
		_obj = createSimpleObject [_type, [0,0,0]];
	} else {
		_obj = _type createVehicle [0,0,0];
		_obj enableSimulationGlobal false;
	};
	
	_obj setVectorDirAndUp _dirUp;
	_obj setPosASL (_pos vectorAdd _relPos);
	([_obj] + _pitchBank) call BIS_fnc_SetPitchBank;

} forEach _objects; 


