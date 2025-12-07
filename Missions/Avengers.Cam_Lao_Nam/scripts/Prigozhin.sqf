
params ["_unit"];

// Immortality of the unit is handled elsewhere, this is just what's added on top 

// For the Improved Melee System addon. 
// Prevents playing reaction animations to melee attacks
_unit setVariable ["IMS_IsUnitInvicibleScripted", 1];

_unit setCaptive true;
_unit enableSimulation false;
_unit hideObject true;

_unit disableAI "ALL";
