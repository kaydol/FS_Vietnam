MENU_ARTYSCREEN_OPTIONS =
[
	// First array: "User menu" This will be displayed under the menu, bool value: has Input Focus or not.
	// Note that as to version Arma2 1.05, if the bool value set to false, Custom Icons will not be displayed.
	["Artillery",false],
	// Syntax and semantics for following array elements:
	// ["Title_in_menu", [assigned_key], "Submenu_name", CMD, [["expression",script-string]], "isVisible", "isActive" <, optional icon path> ]
	// Title_in_menu: string that will be displayed for the player
	// Assigned_key: 0 - no key, 1 - escape key, 2 - key-1, 3 - key-2, ... , 10 - key-9, 11 - key-0, 12 and up... the whole keyboard
	// Submenu_name: User menu name string (eg "#USER:MY_SUBMENU_NAME" ), "" for script to execute.
	// CMD: (for main menu:) CMD_SEPARATOR -1; CMD_NOTHING -2; CMD_HIDE_MENU -3; CMD_BACK -4; (for custom menu:) CMD_EXECUTE -5
	// script-string: command to be executed on activation.  (_target=CursorTarget,_pos=CursorPos) 
	// isVisible - Boolean 1 or 0 for yes or no, - or optional argument string, eg: "CursorOnGround"
	// isActive - Boolean 1 or 0 for yes or no - if item is not active, it appears gray.
	// optional icon path: The path to the texture of the cursor, that should be used on this menuitem.
	//["Teleport", [2], "", -5, [["expression", "Player SetPos _pos;"]], "1", "1", "\A3\ui_f\data\IGUI\Cfg\Cursors\iconcursorsupport_ca.paa"],
	//["Kill Target", [3], "", -5, [["expression", "_target SetDamage 1;"]], "1", "1", "\A3\ui_f\data\IGUI\Cfg\Cursors\iconcursorsupport_ca.paa"],
	//["Disabled", [4], "", -5, [["expression", ""]], "1", "0"],
	//["Submenu", [5], "#USER:MENU_COMMS_2", -5, [], "1", "1"]
	["Put strikes 50m infront", [0], "", -5, [["true","player call FS_fnc_CanTransmit"]], "isVisible", "1", "\A3\ui_f\data\IGUI\Cfg\Cursors\iconcursorsupport_ca.paa"],
	["Put strikes around", [0], "", -5, [["true","player call FS_fnc_CanTransmit"]], "isVisible", "1", "\A3\ui_f\data\IGUI\Cfg\Cursors\iconcursorsupport_ca.paa"],
	["Form a corridor ahead", [0], "", -5, [["true","player call FS_fnc_CanTransmit"]], "isVisible", "1", "\A3\ui_f\data\IGUI\Cfg\Cursors\iconcursorsupport_ca.paa"]
];

[player,"RequestAeroScreen",[],[],""] call BIS_fnc_addCommMenuItem; 
[player,"RequestArtyScreen",[],[],""] call BIS_fnc_addCommMenuItem; 
[player,"SignalDistress",[],[],""] call BIS_fnc_addCommMenuItem; 
[player,"Sitrep",[],[],""] call BIS_fnc_addCommMenuItem; 