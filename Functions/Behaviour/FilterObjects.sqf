
params ["_units"];

// Filter out players who use Arsenal Room
_units = _units select { !(_x getVariable ["UsesArsenalRoom", false]) && alive _x }; 

_units 