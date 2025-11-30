
#include "..\..\definitions.h"

params ["_target"];

private _sources = missionNameSpace getVariable [DEF_LASER_SOURCES_VAR, []];

if (_target in _sources) then 
{
	_sources = _sources - [_target];
}
else 
{
	_sources pushBack _target;
};

missionNameSpace setVariable [DEF_LASER_SOURCES_VAR, _sources select { _x isNotEqualTo objNull }, true];
