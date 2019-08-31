
private _particlePos = _this;
private _switchTo = "uns_tripwire_punj3_d";

[_particlePos] spawn FS_fnc_PunjiEffects;

if !(isServer) exitWith {};
if ( isNil{ FS_AllGookTraps }) exitWith {};

private _trapReplacement = [_particlePos, _switchTo] call FS_fnc_PunjiTrapFired;
if ( _trapReplacement isEqualTo [] ) exitWith {};
_trapReplacement params ["_firedTrap", "_posAGL", "_dir", "_up"];

/*
	Animate
*/

private _speed = 0.1;
private _steps = 5;

_firedTrap setPos _posAGL;
_firedTrap setVectorDirAndUp [_dir vectorMultiply -1, _up];

for [{_i = -90},{_i <= 0},{ _i = _i + 90 / _steps }] do {
	[_firedTrap, _i, 0] call BIS_fnc_setPitchBank; 
	sleep ( _speed / _steps );
};
