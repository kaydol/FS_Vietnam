
params ["_object", ["_radioType", "West"], ["_radioChannel", 1]]; // [heli, "West", 1]

_object setVariable ["_radioType", _radioType]; 
_object setVariable ["_radioChannel", _radioChannel]; 
_object setVariable ["uns_radioOwner", _object]; 

as = [_object] execVM "uns_radio2_c\functions\fn_playback.sqf"; 