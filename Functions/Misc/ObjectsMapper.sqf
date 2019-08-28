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

params ["_pos", "_objects"];

{
	private _obj = _x # 0 createVehicle [0,0,0];
	_obj enableSimulation false;
	_obj setVectorDirAndUp _x # 2;
	_obj setPosASL (_pos vectorAdd _x # 1);
	([_obj] + _x # 3) call BIS_fnc_SetPitchBank;

} forEach _objects; 


