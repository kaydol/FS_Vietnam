params ["_aircraft"];


/*
	First, updating the stations to indicate that this aircraft
	has left its station 
*/
_side = _aircraft getVariable ["initSide", side _aircraft];
[_side, "AIRSTATIONS", _aircraft] call FS_fnc_UpdateSideVariable;

[_side, "ChopperDown"] remoteExec ["FS_fnc_TransmitOverRadio", 2];