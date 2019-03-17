// by ALIAS
// null = [_nap_sec] execvm "\FS_Vietnam\Effects\Napalm\alias_napalm_effect_sec.sqf";

private ["_nap_bomb_sec","_dir_xx","_dir_yy","_nap_bomb_sec","_nap_bomb_secund"];

if (!hasInterface) exitWith {};

sleep 1;

_nap_bomb_secund = _this select 0;
_dir_xx = _this select 1;
_dir_yy = _this select 2;

_nap_bomb_sec = "Land_HelipadEmpty_F" createVehicleLocal getPosATL _nap_bomb_secund;

// flacari
_foc = "#particlesource" createVehicleLocal (getPosATL _nap_bomb_sec);
_foc setParticleCircle [15, [-1, 1, 0]];
_foc setParticleRandom [0.5, [0.25, 0.25, 0], [0.175, 0.175, 0.1], 5, 0.15, [0, 0, 0, 0.1], 0.5, 0];
_foc setParticleParams [["\A3\data_f\cl_exp", 1, 0, 1], "", "Billboard", 1, 60, [0, 0, 0], [_dir_xx*100,_dir_yy*100, 3], 40, 10.3, 7.9, 0.5, [30,15,30], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 0.5]], [0.02], 1, 0, "", "", _nap_bomb_sec];
_foc setDropInterval 0.01;

[_foc] spawn {
	_de_sters = _this select 0;
	sleep 3;
	deleteVehicle _de_sters;
};

// flacari coloana
_foc_col = "#particlesource" createVehicleLocal (getPosATL _nap_bomb_sec);
_foc_col setParticleCircle [15, [0, 0, 0]];
_foc_col setParticleRandom [0.5, [0.25, 0.25, 0], [0.175, 0.175, 0.1], 5, 0.15, [0, 0, 0, 0.1], 0.5, 0];
_foc_col setParticleParams [["\A3\data_f\cl_exp", 1, 0, 1], "", "Billboard", 1, 5+ random 5, [0, 0, 0], [_dir_xx*100,_dir_yy*100, 20 + random 20], 40, 5, 8, 0.2, [30,15,10+random 60], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 0]], [0.02], 1, 0, "", "", _nap_bomb_sec];
_foc_col setDropInterval 0.01;

[_foc_col] spawn {
	_de_sters = _this select 0;
	sleep 10;
	deleteVehicle _de_sters;
};


// fum negru
_fum_negru = "#particlesource" createVehicleLocal getPosATL _nap_bomb_sec;
_fum_negru setParticleCircle [30,[0.2, 0.5, 20]];
_fum_negru setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 0, [0, 0, 0, 0], 0, 0];
_fum_negru setParticleParams [["\A3\data_f\cl_basic.p3d", 1, 0, 1], "", "Billboard", 1, 15, [_dir_xx, _dir_yy*1.5, 10], [_dir_xx*100,_dir_yy*100, 75], 45, 17, 13, 0.7, [35, 25, 50,70], [[0.5, 0.5, 0.5, 0.5], [0, 0, 0, 1], [0, 0, 0, 0.5], [0, 0, 0, 0]], [0.08], 0.1, 3, "", "", _nap_bomb_sec];
_fum_negru setDropInterval 0.05;

[_fum_negru] spawn {
	_de_sters = _this select 0;
	sleep 10;
	deleteVehicle _de_sters;
};

sleep 60;
deleteVehicle _nap_bomb_sec;