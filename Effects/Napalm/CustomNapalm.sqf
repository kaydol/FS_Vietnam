
_this set [2, 0];

// Initializing default values
if (isNil{ NAPALM_ENABLE }) then 
{
	NAPALM_ENABLE = getNumber (ConfigFile >> "CfgVehicles" >> "FS_NapalmSettings_Module" >> "Attributes" >> "Enable" >> "defaultValue") == 1;
};

if !( NAPALM_ENABLE ) exitWith {};

[_this] spawn FS_fnc_NapalmCreateExplosion; 

