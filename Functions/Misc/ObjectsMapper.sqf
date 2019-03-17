
params ["_anchor", "_grabRadius"];

_entities = _anchor nearEntities _grabRadius;
_entities = _entities apply { [typeOf _x, _anchor worldToModel getPos _x, _x call BIS_fnc_getPitchBank] };

copyToClipBoard str _entities;
