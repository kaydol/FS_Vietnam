_logic = _this select 0;
_units = _this select 1;
_activated = _this select 2;

//--- Terminate on client (unless it's curator who created the module)
if (!isserver && {local _x} count (objectcurators _logic) == 0) exitwith {};

if (_activated) then {

	//--- Wait for params to be set
	if (_logic call bis_fnc_isCuratorEditable) then {
		waituntil {!isnil {_logic getvariable "type"} || isnull _logic};
	};
	if (isnull _logic) exitwith {};

	//--- Show decal
	if ({local _x} count (objectcurators _logic) > 0) then {
		//--- Reveal the circle to curators
		_logic hideobject false;
		_logic setpos position _logic;
	};
	if !(isserver) exitwith {};

	_posATL = getPosATL _logic;
	_pos = +_posATL;
	_pos set [2,(_pos select 2) + getterrainheightasl _pos];						 

	//--- Show hint
	[[["Curator","PlaceOrdnance"],nil,nil,nil,nil,nil,nil,true],"bis_fnc_advHint",objectcurators _logic] call bis_fnc_mp;
	
	//--- Play radio
	//[_plane,"CuratorModuleCAS"] call bis_fnc_curatorSayMessage;

	_salvos = _logic getVariable "salvos";
	_radius = _logic getVariable "radius";
	_type = _logic getVariable "type";
	_height = _logic getVariable "height";
	_initDelay = _logic getVariable "initDelay";
	_debug = _logic getVariable "debug";
	
	// ["_posOrObject", ["_salvos", 5], ["_radius", 25 + random 25], ["_type", "Sh_82mm_AMOS"], ["_height", 150], ["_initDelay", 0], ["_debug", false]
	_handle = [_logic, _salvos, _radius, _type, _height, _initDelay, _debug] spawn FS_fnc_DropMines;
	
	waituntil {
		sleep 0.01;
		scriptdone _handle || isnull _logic
	};
	
	if !(isnull _logic) then {
		sleep 1;
		deletevehicle _logic;
	};

	
};