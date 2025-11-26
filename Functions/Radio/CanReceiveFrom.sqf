
params ["_object"];

if (isNil{RADIOCOMMS_PERSONAL_RADIOS}) then {
	RADIOCOMMS_PERSONAL_RADIOS = call compile getText (ConfigFile >> "CfgVehicles" >> "FS_RadioSettings_Module" >> "Attributes" >> "PersonalRadios" >> "defaultValue");
};

private _transmitters = [];

if (isNil{RADIOCOMMS_OBJECTS_WITH_COMMS}) then {
	RADIOCOMMS_OBJECTS_WITH_COMMS = call compile getText (ConfigFile >> "CfgVehicles" >> "FS_RadioSettings_Module" >> "Attributes" >> "ObjectsWithComms" >> "defaultValue");
};
if (isNil{RADIOCOMMS_AUDIBLE_RADIUS}) then {
	RADIOCOMMS_AUDIBLE_RADIUS = getNumber (ConfigFile >> "CfgVehicles" >> "FS_RadioSettings_Module" >> "Attributes" >> "AudibleRadius" >> "defaultValue");
};

private _entities = _object nearObjects RADIOCOMMS_AUDIBLE_RADIUS;
{
	if ([side _x, side _object] call BIS_fnc_sideIsFriendly && [_x, true] call FS_fnc_CanReceive || 
		typeOf _x in (RADIOCOMMS_OBJECTS_WITH_COMMS apply {toLowerAnsi _x})) then {
		_transmitters pushBack _x;
	};
} forEach _entities;

_transmitters 
