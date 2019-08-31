
private _particlePos = _this;
private _switchTo = "uns_tripwire_punj1_d";

[_particlePos] spawn FS_fnc_PunjiEffects;

if !(isServer) exitWith {};
if ( isNil{ FS_AllGookTraps }) exitWith {};

private _trapReplacement = [_particlePos, _switchTo] call FS_fnc_PunjiTrapFired;
if ( _trapReplacement isEqualTo [] ) exitWith {};
_trapReplacement params ["_firedTrap", "_posAGL", "_dir", "_up"];

/*
	Animate
*/

private _speed = 0;
private _steps = 1; // insta

private _box = _firedTrap call BIS_fnc_boundingBoxDimensions;
private _height = _box # 2;
_firedTrap setPos ( _posAGL vectorAdd [0,0,-_height] );

for [{_i = -_height},{_i <= 0},{ _i = _i + _height / _steps }] do {
	_firedTrap setPos [_posAGL # 0, _posAGL # 1,_i];
	_firedTrap setVectorDirAndUp [_dir, _up];
	sleep ( _speed / _steps );
};
