

if ( typeName _this == "GROUP" ) exitWith { false };

if (isNil{RADIOCOMMS_ENTITIES_WITH_COMMS}) then {
	RADIOCOMMS_ENTITIES_WITH_COMMS = getArray (ConfigFile >> "CfgVehicles" >> "FS_RadioSettings_Module" >> "Attributes" >> "EntitiesWithComms" >> "defaultValue");
};

private _hasComms = false;
{
	if (_this isKindOf _x) exitWith { _hasComms = true };
} 
forEach RADIOCOMMS_ENTITIES_WITH_COMMS;

_hasComms 