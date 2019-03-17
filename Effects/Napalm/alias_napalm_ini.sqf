// by ALIAS
// null = [] execVM "\FS_Vietnam\Effects\Napalm\alias_napalm_ini.sqf";
//[[[this],"\FS_Vietnam\Effects\Napalm\alias_napalm_ini.sqf"],"BIS_fnc_execVM",true,true] call BIS_fnc_MP;
// [[[],"\FS_Vietnam\Effects\Napalm\bomber_nap.sqf"],"BIS_fnc_execVM",true,true] call BIS_fnc_MP;

if (!isServer) exitWith {};

_bombardier_x	= _this select 0;
_dire_x			= direction _bombardier_x;

//blows_a = [];publicVariable "blows_a";
ib = 0;
publicVariable "ib";

while {ib < number_of_bombs} do {
	private ["_nap_obj_princ"];
	
	// creaza obiect principale
	_nap_obj_princ = "Bomb_03_F" createvehicle ([getPosATL _bombardier_x select 0,getPosATL _bombardier_x select 1,(getPosATL _bombardier_x select 2)-5]);
	waituntil {!isnull _nap_obj_princ};
	
	[_nap_obj_princ,_bombardier_x,_dire_x] spawn {
	ib = ib+1; 	publicVariable "ib";
	
	_nap_obj	= _this select 0;
	_bombardier = _this select 1;
	_dire		= _this select 2;
	
	_dir_x = sin _dire;	
	_dir_y = cos _dire;	

	_alt_b = getposATL _nap_obj select 2;

	[_nap_obj, -125, 0] call BIS_fnc_setPitchBank;
	
	while {_alt_b>15} do {
			_alt_b = getposATL _nap_obj select 2;
			sleep 0.1;
	};
	
	_poz_blow = [getPos _nap_obj select 0, getPos _nap_obj select 1];
	deletevehicle _nap_obj;
	_nap_obj_b = "Land_HelipadEmpty_F" createVehicle [_poz_blow select 0,_poz_blow select 1,0];
	
	[_poz_blow] spawn {
		_poz_destr = _this select 0;
		sleep 20;
		_nearobj = nearestObjects [_poz_destr, [], 50];
		{if !(_x isKindOf "Land_HelipadEmpty_F") then {_x setdamage 1};} foreach _nearobj;	
	};
	
	[[_nap_obj_b,_dir_x,_dir_y],"\FS_Vietnam\Effects\Napalm\alias_napalm_effect.sqf"] remoteExec ["BIS_fnc_execVM"];

	[_nap_obj_b] spawn {
		_loc_bomb = _this select 0;
		_nr_bat = floor (6+random 20);
		
		while { _nr_bat > 0 } do {
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

	_nap_sec = "Land_HelipadEmpty_F" createVehicle [getPosATL _nap_obj_b select 0,(getPosATL _nap_obj_b select 1) + _dir_y*1.5,0];
	[[_nap_sec,_dir_x,_dir_y],"\FS_Vietnam\Effects\Napalm\alias_napalm_effect_sec.sqf"] remoteExec ["BIS_fnc_execVM"];

	// foc post nap
	_daytime = daytime > 6 && daytime < 17;
	[[_nap_sec,_daytime,180,40,0.1,true,false],"\FS_Vietnam\Effects\Napalm\fire.sqf"] remoteExec ["BIS_fnc_execVM"];
	
	[_nap_obj_b] spawn { 
		_de_sters = _this select 0;
		sleep 180+(random 120);
		deletevehicle _de_sters;
	};

};
	sleep bomb_drop_interval;
};