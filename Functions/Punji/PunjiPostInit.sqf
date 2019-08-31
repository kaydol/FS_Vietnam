/* ----------------------------------------------------------------------------
Function: FS_fnc_PunjiPostInit

Description:
	Assigns fired event handler to track players placed punji traps.
	Punji traps are stored in FS_AllGookTraps array, which is used
	to track down punji trap that fired and create a fired version 
	of this trap in its place.
	
Author:
    kaydol
---------------------------------------------------------------------------- */

waitUntil { isPlayer player }; 

player addEventHandler ["Fired", { _this call FS_fnc_PunjiPutEventHandler; }];

/*
player addEventHandler ["Respawn", {
	player addEventHandler ["Fired", { _this call FS_fnc_PunjiPutEventHandler; }];
}];
*/