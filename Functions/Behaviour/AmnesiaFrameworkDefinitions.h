
private _fnc_set = {
	
	params ["_varname", "_key", "_dataToStore", ["_insertOnly", false]];

	if (isNil{ missionNameSpace getVariable _varname }) then {
		missionNameSpace setVariable [_varname, createHashMap];
	};

	private _hashMap = missionNameSpace getVariable _varname;

	_hashMap set [_key, _dataToStore, _insertOnly];
};

private _fnc_get = {

	params ["_varname", "_key"];
	
	if (isNil{ missionNameSpace getVariable _varname }) then {
		missionNameSpace setVariable [_varname, createHashMap];
	};
	
	private _hashMap = missionNameSpace getVariable _varname;
	
	_hashMap get _key 
};


private _fnc_getKeys = {

	params ["_varname"];
	
	if (isNil{ missionNameSpace getVariable _varname }) then {
		missionNameSpace setVariable [_varname, createHashMap];
	};
	
	private _hashMap = missionNameSpace getVariable _varname;
	
	keys _hashMap
};


private _fnc_removeKey = {
	
	params ["_varname", "_key"];

	if (isNil{ missionNameSpace getVariable _varname }) exitWith {};
	
	private _hashMap = missionNameSpace getVariable _varname;
	
	if (_key in (keys _hashMap)) then {
		_hashMap deleteAt _key;
	};
};

