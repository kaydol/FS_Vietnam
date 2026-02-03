
params ["_object", ["_preventRecursion", false]];

//-- Prevent players hearing radio from curators unless player is a curator, then he should be able to hear all radio 
if (_object isKindOf "VirtualCurator_F" && player != _object) exitWith { false };

if ( _object call FS_fnc_CanTransmit ) exitWith { true };

if (isNil{RADIOCOMMS_PERSONAL_RADIOS}) then {
	RADIOCOMMS_PERSONAL_RADIOS = call compile getText (ConfigFile >> "CfgVehicles" >> "FS_RadioSettings_Module" >> "Attributes" >> "PersonalRadios" >> "defaultValue");
};

// Personal radio must be in "assignedItems", not "items"
// In other words, units with radios in their inventories instead of assigned items do not count as receivers - the radio must be equipped  
private _ableToReceiveRadioComms = ((RADIOCOMMS_PERSONAL_RADIOS apply {toLowerANSI _x}) arrayIntersect ((assignedItems _object) apply {toLowerANSI _x})) isNotEqualTo [];

if ( _ableToReceiveRadioComms ) exitWith { true };
if ( _preventRecursion ) exitWith { false };

/*
	If he does not have any radio, check surroundings in case any of his buddies has it, 
	or if there is a vehicle nearby
*/

if (isNil{RADIOCOMMS_OBJECTS_WITH_COMMS}) then {
	RADIOCOMMS_OBJECTS_WITH_COMMS = call compile getText (ConfigFile >> "CfgVehicles" >> "FS_RadioSettings_Module" >> "Attributes" >> "ObjectsWithComms" >> "defaultValue");
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




