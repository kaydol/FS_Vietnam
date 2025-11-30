
#include "..\..\definitions.h"

params ["_isKeyDown"];

private _attachedTurrets = (attachedObjects DEF_CURRENT_PLAYER) select {typeOf _x == DEF_TURRET_BACKPACK_SHOULDER_GUN};
if (_attachedTurrets isEqualTo []) exitWith {};

private _turret = _attachedTurrets # 0;

_turret call FS_fnc_ToggleLaser;
