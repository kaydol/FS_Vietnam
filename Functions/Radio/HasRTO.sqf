
/*
	When group is given, returns True if the group has an active Radio Telephone Operator
	When a single unit is given, returns True if that unit is an active Radio Telephone Operator (has the radio)
	
*/

if ( _this call FS_fnc_HasCommSystem ) exitWith { True };

_radios = ["UNS_ItemRadio_PRC_25", "UNS_NVA_RTO", "UNS_ARMY_RTO", "UNS_ARMY_RTO2", "UNS_SF_RTO", "UNS_Alice_FR", "UNS_USMC_RTO", "UNS_USMC_RTO2"];
_hasRTO = False; 
_isGroup = typeName _this == "GROUP";
_pool = if ( _isGroup ) then [{units _this}, {[_this]}];

{
	if ( count ( _radios arrayIntersect (items _x + assignedItems _x + [backpack _x]) ) > 0 ) exitWith {
		_hasRTO = True;
	};

} forEach _pool;

_hasRTO
