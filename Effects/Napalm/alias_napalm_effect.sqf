// by ALIAS
// null = [] execvm "\FS_Vietnam\Effects\Napalm\alias_napalm_effect.sqf";

private ["_nap_bomb","_nap_bombix","_dir_xx","_dir_yy"];

if (!hasInterface) exitWith {};

_nap_bombix = _this select 0;
_dir_xx = _this select 1;
_dir_yy = _this select 2;

_nap_bomb = "Land_HelipadEmpty_F" createVehicleLocal getPosATL _nap_bombix;

_explosionSound = ["napalm", "napalm_1", "napalm_2", "napalm_3", "napalm_4", "napalm_5", "napalm_6", "napalm_7", "napalm_8", "napalm_9"] call BIS_fnc_SelectRandom;

_nap_bomb say3d [_explosionSound, 2000];

//sleep 1;

// vapori
_vapori_nap = "#particlesource" createVehicleLocal getPosATL _nap_bomb;
_vapori_nap setParticleCircle [0, [0, 0, 0]];
_vapori_nap setParticleRandom [0, [0.25, 0.25, 0], [0.175, 0.175, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
_vapori_nap setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 0.5, [0, 0, 0], [0, 0, 0.75], 0, 10, 7.9, 0, [10, 100], [[1, 1, 1, 1], [1, 1, 1, 0]], [0.08], 1, 0, "", "", _nap_bomb];
_vapori_nap setDropInterval 300;


[_vapori_nap] spawn {
	_de_sters = _this select 0;
	sleep 1;
	deleteVehicle _de_sters;
};

// scantei
_scantei = "#particlesource" createVehicleLocal getPosATL _nap_bomb;
_scantei setParticleCircle [10, [0, 0, 10]];
_scantei setParticleRandom [3, [0.25, 0.25, 0], [100, 100, 100], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
_scantei setParticleParams [["\A3\data_f\cl_exp", 1, 0, 1], "", "Billboard", 1, 7, [0, 0, 0], [5, 5, 30], 0.3, 200, 5, 3, [1.5, 1, 0.5], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _nap_bomb];
_scantei setDropInterval 0.01;	

[_scantei] spawn {
	_de_sters = _this select 0;
	sleep 1;
	deleteVehicle _de_sters;
};

// fum alb
_fum_alb = "#particlesource" createVehicleLocal getPosATL _nap_bomb;
_fum_alb setParticleCircle [30,[0.2, 0.5, 0.9]];
_fum_alb setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 0, [0, 0, 0, 0], 0, 0];
_fum_alb setParticleParams [["\A3\data_f\cl_basic.p3d", 1, 0, 1], "", "Billboard", 1, 17, [0, 0, 0], [_dir_xx*100,_dir_yy*100, 15], 25, 17, 13, 0.7, [15, 25, 31], [[1, 1, 1, 1], [0.5, 0.5, 0.5, 0.5], [0, 0, 0, 0]], [0.08], 0.1, 3, "", "", _nap_bomb];
_fum_alb setDropInterval 0.01;

[_fum_alb] spawn {
	_de_sters = _this select 0;
	sleep 5;
	deleteVehicle _de_sters;
};


//lumina
_li_exp = "#lightpoint" createVehicle getPosATL _nap_bomb;
_li_exp lightAttachObject [_nap_bomb, [0,0,3]];
_li_exp setLightAttenuation [/*start*/ 0, /*constant*/0, /*linear*/ 0, /*quadratic*/ 0, /*hardlimitstart*/40,600];  
_li_exp setLightIntensity 500;
_li_exp setLightBrightness 10;
_li_exp setLightDayLight true;	
_li_exp setLightUseFlare true;
_li_exp setLightFlareSize 100;
_li_exp setLightFlareMaxDistance 2000;	
_li_exp setLightAmbient[1,0.2,0.1];
_li_exp setLightColor[1,0.2,0.1];

[_li_exp] spawn {
	_lum_sters = _this select 0;
	sleep 1;
	_u=10;
	while {_u>0} do {
	_lum_sters setLightBrightness _u;
	_u=_u-0.2;
	sleep 0.1;
	};
	sleep 0.5;
	deleteVehicle _lum_sters;
};

sleep 20;
deleteVehicle _nap_bomb;