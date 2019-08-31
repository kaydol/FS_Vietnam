
params ["_posATL"];

_posATL = +_posATL;
_posATL set [2,0];

playSound3D ["FS_Vietnam\Functions\Punji\punji.ogg", nil, false, ATLToASL _posATL, 10, 1.5, 70];

private _greenGrass = "#particlesource" createVehicleLocal _posATL;
_greenGrass setParticleCircle [0, [0, 0, 0]];
_greenGrass setParticleRandom [0, [0.25, 0.25, 0], [0.175, 0.175, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
_greenGrass setParticleParams [["\A3\data_f\cl_grass1", 1, 0, 1], "", "SpaceObject", 1, 2, [0, 0, 0], [0, 0, 3.75], 0, 30, 7.9, 0.075, [1.2, 2, 4], [[0.1, 0.1, 0.1, 1], [0.25, 0.25, 0.25, 0.5], [0.5, 0.5, 0.5, 0]], [0.08], 0.5, 1, "", "", _greenGrass];
_greenGrass setDropInterval 0.002;

_greenGrass spawn {
	sleep 0.2;
	deleteVehicle _this;
};

private _yellowGrass = "#particlesource" createVehicleLocal _posATL;
_yellowGrass setParticleCircle [0, [0, 0, 0]];
_yellowGrass setParticleRandom [0, [0.25, 0.25, 0], [0.175, 0.175, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
_yellowGrass setParticleParams [["\A3\data_f\cl_grass2", 1, 0, 1], "", "SpaceObject", 1, 2, [0, 0, 0], [0, 0, 3.75], 0, 30, 7.9, 0.075, [1.2, 2, 4], [[0.1, 0.1, 0.1, 1], [0.25, 0.25, 0.25, 0.5], [0.5, 0.5, 0.5, 0]], [0.08], 0.5, 1, "", "", _yellowGrass];
_yellowGrass setDropInterval 0.002;

_yellowGrass spawn {
	sleep 0.2;
	deleteVehicle _this;
};