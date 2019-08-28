
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
	if ( count ( _radios arrayIntersect (items _x + assignedItems _x + [backpack _x]) ) > 0 ) exitWith 
	{
		_hasRTO = True;
		/*
			There is one problem with Arma I am going to tell here.
			A player is only able to hear and see sideChat, sideRadio messages if he has "ItemRadio" equipped. 
			
			Backpack radios added by Unsung Vietnam War addon are not counted as radios by the game, they are just backpacks.
			Yet we want to let the players be able to send and receive messages even if they don't have "ItemRadio" but have a backpack radio.
			
			So we will be checking if the player has a backpack radio and then GIVING him "ItemRadio" if he doesn't have it yet.
			You may consider this a HACK as it will produce an exploit that will allow players to eject countless "ItemRadio" on the ground.
		*/
		if !( "ItemRadio" in assignedItems _x ) then {
			if ( "ItemRadio" in items _x ) then {
				// If the player has the radio in their inventory but not wearing it, put it on
				_x assignItem "ItemRadio";
			} else {
				// If the player doesn't have the radio at all, give it and put it on
				_x linkItem "ItemRadio";
			};
		};
	};

} forEach _pool;

_hasRTO
