// null = [blowup] execVM "\FS_Vietnam\Effects\Napalm\alias_obj_sing.sqf";

private ["_nap_obj_b","_dir_xx","_dir_yy"];

if (!isServer) exitWith {};

_nap_obj_b = _this select 0;
_dir_xx = wind select 0;
_dir_yy = wind select 1;

[[_nap_obj_b,_dir_xx/10,_dir_yy/10],"\FS_Vietnam\Effects\Napalm\alias_napalm_effect.sqf"] remoteExec ["BIS_fnc_execVM"];
	
	[_nap_obj_b] spawn {
		_loc_bomb = _this select 0;
		_nr_bat = floor (6+random 10);
		
		while {_nr_bat>0} do {
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

enableCamShake true;
_power_sh = floor((50*10)/(player distance _nap_obj_b));
addCamShake [_power_sh, 5, 50];
	
sleep 3 + (random 3);
[[_nap_obj_b,_dir_xx/10,_dir_yy/10],"\FS_Vietnam\Effects\Napalm\alias_napalm_effect_sec.sqf"] remoteExec ["BIS_fnc_execVM"];

_daytime = daytime > 6 && daytime < 17;
[[_nap_obj_b,_daytime,180,40,0.1,true,false],"\FS_Vietnam\Effects\Napalm\fire.sqf"] remoteExec ["BIS_fnc_execVM"];

_nearobj = nearestObjects [_nap_obj_b, [], 50];
{if !(_x isKindOf "Land_HelipadEmpty_F") then {_x setdamage 1};} foreach _nearobj;

sleep 180+(random 120);
deletevehicle _nap_obj_b;