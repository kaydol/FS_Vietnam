
/*--------------------------------------------------------------------------------------
	
	Executing this script only makes sense if :
		- Attributes -> Multiplayer... -> Respawn -> Respawn is enabled
		- Attributes -> Multiplayer... -> Respawn -> Respawn Templates contain both "Select Respawn Position" and "Spectator" enabled 
	
	The respawn templates "MenuPosition" and "Spectator" are not compatible since MenuPosition will force the map open. Instead you can use the following settings to get access to the full spectator mode
	
	If respawn template "Wave" is also enabled, respawn counter is adjusted so players spawns together. Wave delay is based on respawnDelay and Player's respawn time is set between 1 and 2 times respawnDelay: if respawnDelay is set to e.g 10, respawn waves happen every 10 seconds. If a player dies and the next respawn wave is in 3 seconds, the player's respawn time is set to 17 seconds to match the next wave.
	
	Do NOT enable "Show Respawn counter" with "Select Respawn Position", because counter is already built-in in "Select Respawn Position"
	
----------------------------------------------------------------------------------------*/

// --- Enable full spectator in respawn screen
{
	missionNamespace setVariable [_x, true];
} forEach [
	"BIS_respSpecAi",					// Allow spectating of AI
	"BIS_respSpecAllowFreeCamera",		// Allow moving the camera independent from units (players)
	"BIS_respSpecAllow3PPCamera",		// Allow 3rd person camera
	"BIS_respSpecShowFocus",			// Show info about the selected unit (dissapears behind the respawn UI)
	"BIS_respSpecShowCameraButtons",	// Show buttons for switching between free camera, 1st and 3rd person view (partially overlayed by respawn UI)
	"BIS_respSpecShowControlsHelper",	// Show the controls tutorial box
	"BIS_respSpecShowHeader",			// Top bar of the spectator UI including mission time
	"BIS_respSpecLists"					// Show list of available units and locations on the left hand side
];

//-- Put custom overrides here
BIS_respSpecShowFocus = false;
BIS_respSpecAllowFreeCamera = false;
BIS_respSpecAi = false;
BIS_respSpecShowCameraButtons = false;

