
if (!isServer) exitWith {};

params ["_bomb", "_plane", "_napalmBombType", ["_napalmDuration", 100], ["_bombRadius", 40]];

if (typeOf _bomb != _napalmBombType) exitWith {};

waitUntil {(getposATL _bomb select 2) < 15};

_dire  = getDir _plane;
_dir_x = sin _dire;	
_dir_y = cos _dire;	

_pos = [getPos _bomb select 0, getPos _bomb # 1];
deletevehicle _bomb;

_helipad = "Land_HelipadEmpty_F" createVehicle [_pos # 0,_pos # 1,0];

// Insta killing men inside the bomb impact radius, also making them scream
_objects = _pos nearEntities ["MAN", _bombRadius];
{
	_deathSound = ["napalm_death_1", "napalm_death_2", "napalm_death_3", "napalm_death_4"] call BIS_fnc_SelectRandom;
	[_x, _deathSound] remoteExec ["FS_fnc_BurnedAlive", 0];
} 
forEach _objects;

[_pos] spawn {
	_p = _this select 0;
	_nearobj = _p nearObjects 50;
	{
		if !(_x isKindOf "Land_HelipadEmpty_F") then { _x setdamage 1; };
		sleep 2;
	}
	foreach _nearobj;	
};

[[_helipad,_dir_x,_dir_y],"\FS_Vietnam\Effects\Napalm\alias_napalm_effect.sqf"] remoteExec ["BIS_fnc_execVM"];

[0.005,0.3 + random 1,[ [_pos select 0,_pos select 1,0],400]] remoteExec ["FS_fnc_ShakeCam", 0];
{ _x hideObjectGlobal true } foreach (nearestTerrainObjects [ [_pos select 0,_pos select 1,0],["bush"],40]);

[_helipad] spawn 
{
	_loc_bomb = _this select 0;
	_nr_bat = floor (6+random 20);
	
	while {_nr_bat>0} do 
	{
		private ["_vit_z","_vit_x","_vit_y","_buc_nap","_li_exp"];
		
		_vit_z = 10+random 50;
		_vit_x = ([1,-1] call BIS_fnc_selectRandom)* floor (10+random 30);
		_vit_y = ([1,-1] call BIS_fnc_selectRandom)* floor (10+random 30);

		_buc_nap = createVehicle ["Land_Battery_F", getPosATL _loc_bomb, [], 20, "CAN_COLLIDE"];

		//ataseaza smoke la baterii
		[[_buc_nap],"\FS_Vietnam\Effects\Napalm\alias_buc_nap.sqf"] remoteExec ["BIS_fnc_execVM"];
		
		_buc_nap setVelocity [_vit_x,_vit_y,_vit_z];
		[_buc_nap] spawn {_de_delete = _this select 0; sleep 6;	deleteVehicle _de_delete;};
		_nr_bat = _nr_bat-1;
	};
};

_nap_sec = "Land_HelipadEmpty_F" createVehicle [getPosATL _helipad select 0,(getPosATL _helipad select 1) + _dir_y*1.5,0];
[[_nap_sec,_dir_x,_dir_y],"\FS_Vietnam\Effects\Napalm\alias_napalm_effect_sec.sqf"] remoteExec ["BIS_fnc_execVM"];

// foc post nap
_daytime = daytime > 6 && daytime < 17;
[[_nap_sec,_daytime,_napalmDuration,40,0.1],"\FS_Vietnam\Effects\Napalm\fire.sqf"] remoteExec ["BIS_fnc_execVM"];

[_helipad, _napalmDuration] spawn {
	params ["_helipad", "_napalmDuration"];
	
	sleep ( _napalmDuration / 10 );
	createSimpleObject ["\FS_Vietnam\Effects\Napalm\krater.p3d", position _helipad];
	
	sleep ( _napalmDuration - _napalmDuration / 10 );
	deletevehicle _helipad;
};
