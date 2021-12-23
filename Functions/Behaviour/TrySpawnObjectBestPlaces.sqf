/* ----------------------------------------------------------------------------
Function: FS_fnc_TrySpawnObjectBestPlaces

Description:
	The intended usage of this function is to spawn sniper trees in places where
	players can not see them. 
	
Parameters:
	_type - STRING: Type of vehicle.
	_coords - POSITION: Position to be used as center for selectBestPlaces command.
    _expression - STRING: Expression, see https://community.bistudio.com/wiki/Ambient_Parameters 
	_amount - NUMBER: Number of objects to spawn. Default 1.
	_unitsToHideFrom - 	ARRAY: Array of units to check visibility against. Objects 
						that have their topmost point visible to _unitsToHideFrom
						will not be spawned. Default [].
    
Returns:
   Array of created objects or [].

Author:
    kaydol
---------------------------------------------------------------------------- */

#define DEF_OBJECT_HEIGHTS_DICTIONARY "OBJECT_HEIGHTS_DICTIONARY"

/*
	Returns height of the object. Values are cached in a global variable.
	Parameters:
		_this: STRING - type of the object to get height of, case insensitive.
*/
private _getObjectHeight = {
	params ["_type"];
	
	if (isNil{missionNameSpace getVariable DEF_OBJECT_HEIGHTS_DICTIONARY}) then {
		missionNameSpace setVariable [DEF_OBJECT_HEIGHTS_DICTIONARY, []];
	};
	
	private _dictionary = missionNameSpace getVariable DEF_OBJECT_HEIGHTS_DICTIONARY;
	private _index = _dictionary find {_x # 0 == _type};
	
	//-- New object encountered, calculate height and save
	if (_index < 0) then {
		private _local = _type createVehicleLocal [0,0,0];
		private _height = 0;
		if !(_local isEqualTo objNull) then {
			_local hideObject true;
			private _dimensions = _local call BIS_fnc_boundingBoxDimensions;
			_height = _dimensions # 2;
			deleteVehicle _local;
		};
		_index = _dictionary pushBack [_type, _height];
		missionNameSpace setVariable [DEF_OBJECT_HEIGHTS_DICTIONARY, _dictionary]; // just to be sure 
	};
	
	//-- Return object's height stored in variable
	((_dictionary # _index) # 1)
};

params ["_type", "_coords", "_expression", ["_amountToSpawn", 1], ["_unitsToHideFrom", []], ["_debug", false]];

private _radius = 50;
private _precision = 2;
private _threshold = 0.2;
private _maxResults = 20 min (2 * (_radius / _precision));
private _places = (selectBestPlaces [_coords, _radius, _expression, _precision, _maxResults]) select {_x # 1 >= _threshold};
private _created = [];

if !(_places isEqualTo []) then 
{
	_amountToSpawn = _amountToSpawn min (count _places);
	
	private _i = 0;
	for "_i" from 0 to (count _places)-1 do 
	{
		private _pos2D = (_places # _i) # 0;
		private _expr = (_places # _i) # 1;
		
		//-- Check if the topmost point of the object's is visible to _unitsToHideFrom
		private _isPosHidden = true;
		if !(_unitsToHideFrom isEqualTo []) then {
			private _objHeight = _type call _getObjectHeight;
			private _posASL = [_pos2D # 0, _pos2D # 1, (getTerrainHeightASL _pos2D) + _objHeight];
			_isPosHidden = [_posASL, _unitsToHideFrom] call FS_fnc_IsPosHidden;
		};
		
		//-- If hidden, spawn object 
		if (_isPosHidden) then {
			private _object = createVehicle [_type, _pos2D, [], 10, "NONE"];
			if !(_object isEqualTo objNull) then {
				_amountToSpawn = _amountToSpawn - 1;
				_created pushBack _object;
			};
		};
		
		if (_amountToSpawn <= 0) exitWith {};
	};
};

_created 
