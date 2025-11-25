
params ["_object", ["_distance", 2]];

private _posASL = [0,0,0];

if (_object isKindOf "MAN") then { 
	_posASL = eyePos _object;
} else {
	_posASL = getPosASL _object;
};

private _intersections = lineIntersectsSurfaces [_posASL, [_posASL # 0, _posASL # 1, (_posASL # 2) + _distance], _object];
!(_intersections isEqualTo [])
