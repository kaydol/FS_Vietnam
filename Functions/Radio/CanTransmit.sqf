
/*
	When group is given, returns True if the group has an active Radio Telephone Operator
	When a single unit is given, returns True if that unit is an active Radio Telephone Operator (has the radio) or inside a vehicle with radio comms
	
*/

if ( _this call FS_fnc_HasCommSystem ) exitWith { true };

if (isNil{RADIOCOMMS_ITEMS_BACKPACKS}) then {
	RADIOCOMMS_ITEMS_BACKPACKS = call compile getText (ConfigFile >> "CfgVehicles" >> "FS_RadioSettings_Module" >> "Attributes" >> "RTOItemsAndBackpacks" >> "defaultValue");
};

private _hasRTO = false; 
private _isGroup = typeName _this == "GROUP";
private _pool = if ( _isGroup ) then [{units _this}, {[_this]}];

{
	if ( count ((RADIOCOMMS_ITEMS_BACKPACKS apply {toLowerANSI _x}) arrayIntersect ((items _x + assignedItems _x + [backpack _x]) apply {toLowerANSI _x})) > 0 ) exitWith 
	{
		_hasRTO = true;
	};

} forEach _pool;

_hasRTO
