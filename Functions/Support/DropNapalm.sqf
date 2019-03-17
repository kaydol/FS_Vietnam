

params ["_coordinates", ["_napalmDuration", 100]];


_center = createCenter sideLogic;
_group = createGroup _center;
_logic = _group createUnit ["LOGIC", _beginPos, [], 0, "NONE"];
//_logic setVariable ["vehicle", "uns_F4J_CAS"]; 
_logic setVariable ["vehicle", "uns_A7N_CAS"]; 
_logic setvariable ["type", 3];
_logic setvariable ["napalmDuration", _napalmDuration];

_direction = random 360;

if ( count _coordinates == 2 ) then { 
	if (_coordinates # 1 isEqualType 0) then { 
		// _coordinates == [_startPos, _direction]
		_direction = _coordinates # 1;
	} else { 
		// _coordinates == [[x1,y1,z1], [x2,y2,z2]]
		_direction = [_coordinates # 0, _coordinates # 1] call BIS_fnc_dirTo;
	};
};

_logic setDir _direction;

[_logic, [], true] spawn FS_fnc_ModuleCas;
