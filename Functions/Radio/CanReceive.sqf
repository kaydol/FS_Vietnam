
params ["_object", ["_preventRecursion", false]];

if ( _object call FS_fnc_CanTransmit ) exitWith { true };

if (isNil{RADIOCOMMS_PERSONAL_RADIOS}) then {
	RADIOCOMMS_PERSONAL_RADIOS = call compile getText (ConfigFile >> "CfgVehicles" >> "FS_RadioSettings_Module" >> "Attributes" >> "PersonalRadios" >> "defaultValue");
};

private _ableToReceiveRadioComms = ((RADIOCOMMS_PERSONAL_RADIOS apply {toLowerANSI _x}) arrayIntersect ((assignedItems _object) apply {toLowerANSI _x})) isNotEqualTo [];
if ( _ableToReceiveRadioComms ) exitWith { true };
if ( _preventRecursion ) exitWith { false };

/*
	If he does not have any radio, check surroundings in case any of his buddies has, 
	or there is a vehicle nearby
*/

if (isNil{RADIOCOMMS_OBJECTS_WITH_COMMS}) then {
	RADIOCOMMS_OBJECTS_WITH_COMMS = call compile getText (ConfigFile >> "CfgVehicles" >> "FS_RadioSettings_Module" >> "Attributes" >> "EntitiesWithComms" >> "defaultValue");
};
if (isNil{RADIOCOMMS_AUDIBLE_RADIUS}) then {
	RADIOCOMMS_AUDIBLE_RADIUS = getNumber (ConfigFile >> "CfgVehicles" >> "FS_RadioSettings_Module" >> "Attributes" >> "AudibleRadius" >> "defaultValue");
};

private _entities = _object nearObjects RADIOCOMMS_AUDIBLE_RADIUS;
{
	if ([side _x, side _object] call BIS_fnc_sideIsFriendly && [_x, true] call FS_fnc_CanReceive || 
		typeOf _x in (RADIOCOMMS_OBJECTS_WITH_COMMS apply {toLowerAnsi _x})) exitWith {
		_ableToReceiveRadioComms = true;
	};
	
} forEach _entities;

_ableToReceiveRadioComms 




