

if ( typeName _this == "GROUP" ) exitWith { false };

if (isNil{RADIOCOMMS_OBJECTS_WITH_COMMS}) then {
	RADIOCOMMS_OBJECTS_WITH_COMMS = call compile getText (ConfigFile >> "CfgVehicles" >> "FS_RadioSettings_Module" >> "Attributes" >> "EntitiesWithComms" >> "defaultValue");
};
if (isNil{RADIOCOMMS_AUDIBLE_RADIUS}) then {
	RADIOCOMMS_AUDIBLE_RADIUS = getNumber (ConfigFile >> "CfgVehicles" >> "FS_RadioSettings_Module" >> "Attributes" >> "AudibleRadius" >> "defaultValue");
};


private _hasComms = false;
{
	if (vehicle _this isKindOf _x) exitWith { _hasComms = true };
} 
forEach RADIOCOMMS_OBJECTS_WITH_COMMS;

if (_hasComms) exitWith { true };

private _nearObjects = _this nearObjects RADIOCOMMS_AUDIBLE_RADIUS;
_hasComms = count (_nearObjects select { toLowerANSI typeOf _x in (RADIOCOMMS_OBJECTS_WITH_COMMS apply {toLowerAnsi _x}) }) > 0;

_hasComms
