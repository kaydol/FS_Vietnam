
if !(hasInterface) exitWith {};

params ["_unit"];

sleep 1;

[_unit] spawn {
	params ["_unit"];
	for [{_i = 0}, {_i < 5}, {_i = _i + 1}] do {
		if (alive _unit && !isNil{ FS_addHealthBar }) exitWith { _unit spawn FS_addHealthBar; }; 
		sleep 1;
	};
};

[_unit] spawn {
	params ["_unit"];
	for [{_i = 0}, {_i < 5}, {_i = _i + 1}] do {
		if (alive _unit && !isNil{ FS_addMapMarker }) exitWith { _unit spawn FS_addMapMarker; }; 
		sleep 1;
	};
};

[_unit] spawn {
	params ["_unit"];
	for [{_i = 0}, {_i < 5}, {_i = _i + 1}] do {
		if (alive _unit && !isNil{ FS_addNametag }) exitWith { _unit spawn FS_addNametag; }; 
		sleep 1;
	};
};


