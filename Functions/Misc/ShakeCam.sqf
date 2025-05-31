/*
	Author: Karel Moricky 
	changed a bit for working on all clients, not only for curator

	Description:
	Shake curator camera.
	Must be executed in scheduled environment.

	Parameter(s):
		0: NUMBER - shaking strength
		1: NUMBER - duration
		2: ARRAY in format [<center>,<radius>] - shake only when camera is in given distance from center

	Returns:
	BOOL
*/

#include "..\..\definitions.h"

private ["_strength","_duration","_timeStart","_time","_center","_radius"];
_strength = [_this,0,0.01,[0]] call bis_fnc_param;
_duration = [_this,1,0.7,[0]] call bis_fnc_param;
_pos = [_this,2,[],[[]]] call bis_fnc_param;

_center = [_pos,0,position DEF_CURRENT_PLAYER] call bis_fnc_paramin;
_center = _center call bis_fnc_position;
_radius = [_pos,1,0,[0]] call bis_fnc_paramin;

if (DEF_CURRENT_PLAYER distance _center > _radius) exitwith {false};

_timeStart = time;
_time = time + _duration;
_strengthLocalOld = 0;
while {time < _time && !isnull DEF_CURRENT_PLAYER} do {
	private ["_strengthLocal","_vectorDir"];
	_strengthLocal = linearconversion [0,_duration,time - _timeStart,_strength,0];
	if (_radius > 0) then {
		_strengthLocal = _strengthLocal * linearconversion [0,_radius,DEF_CURRENT_PLAYER distance _center,1,0];
	};
	if (_strengthLocalOld > 0) then {_strengthLocal = -_strengthLocal;};
	_vectorDir = vectordir DEF_CURRENT_PLAYER;
	_vectorDir set [2,(_vectorDir select 2) - _strengthLocalOld + _strengthLocal];
	DEF_CURRENT_PLAYER setvectordirandup [_vectorDir,vectorup DEF_CURRENT_PLAYER];
	_strengthLocalOld = _strengthLocal;
	sleep 0.05;
};
true