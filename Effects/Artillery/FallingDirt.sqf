
#define FALLING_DIRT_SOUNDS ["dirt_1", "dirt_2", "dirt_3", "dirt_4", "dirt_5", "dirt_6", "dirt_7"]

if !(hasInterface) exitWith {};

params ["_explosionPos"];

if ( player distance _explosionPos > 200 ) exitWith {};

private _fnc_fadingEffect = {
	params ["_emitter", "_interval", "_duration"];
	private _steps = 10;
	for [{_i = _steps},{_i >= 0},{_i = _i - 1}] do {
		sleep (_duration / _steps);
		_emitter setDropInterval ( _interval + linearConversion [_steps, 0, _i, 0, 1] );
	};
	_emitter setDropInterval 0;
	deleteVehicle _emitter;
};

playSound3D [format ["FS_Vietnam\Effects\Artillery\Sound\%1.ogg", selectRandom FALLING_DIRT_SOUNDS], nil, false, ATLToASL [_explosionPos # 0, _explosionPos # 1, 50], 10, 1, 800];

private _dirt = "#particlesource" createVehicleLocal getPos player;
_dirt setParticleCircle [0, [0, 0, 0]];
_dirt setParticleRandom [0, [20, 20, 0], [3, 3, 0.4], 0, 1, [0, 0, 0, 0], 0, 0];
_dirt setParticleParams [["\A3\data_f\ParticleEffects\Universal\Mud.p3d", 1, 0, 1], "", "SpaceObject", 1, 4, [0, 0, 20], [0, 0, -1], 0, 10, 0, 0, [0, 0.1, 0.1], [[0.1, 0.1, 0.1, 1], [0.25, 0.25, 0.25, 0.5], [0.5, 0.5, 0.5, 0]], [0.08], 1, 0, "", "", player];
_dirt setDropInterval 0.05;

[_dirt, 0.05, 3] spawn _fnc_fadingEffect;

sleep 2;

[player, 0.01] call BIS_fnc_dirtEffect;

private _dust = "#particlesource" createVehicleLocal getPos player;
_dust setParticleCircle [0, [0, 0, 0]];
_dust setParticleRandom [0, [10, 10, 0], [0.175, 0.175, 0], 0, 0.25, [0, 0, 0, 0], 0, 0];
_dust setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 3, [0, 0, -0.2], [0, 0, 0.75], 0, 10, 7.9, 0.075, [1.2, 2, 2], [[0.25, 0.25, 0.25, 0], [0.25, 0.25, 0.25, 0.05], [0.25, 0.25, 0.25, 0]], [0.08], 1, 0, "", "", player];
_dust setDropInterval 0.1;

[_dust, 0.1, 2] spawn _fnc_fadingEffect; 