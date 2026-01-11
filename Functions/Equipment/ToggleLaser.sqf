
#include "..\..\definitions.h"

params ["_target"];

private _sources = missionNameSpace getVariable [DEF_LASER_SOURCES_VAR, []];

if (_target in _sources) then 
{
	_sources = _sources - [_target];
	_target animateSource ["laser_source",1];
}
else 
{
	_sources pushBack _target;
	_target animateSource ["laser_source",0];
};

missionNameSpace setVariable [DEF_LASER_SOURCES_VAR, _sources select { _x isNotEqualTo objNull }, true];
