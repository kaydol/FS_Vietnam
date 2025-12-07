
//-- This makes sense only if "goko_bi_patched" addon is installed 
//-- Prevents the hat being shot off the head

waitUntil {sleep 1; !isNull player};

//-- "Respawn" EH is persisted across multiple respawns
player addEventHandler ["Respawn", { player setVariable ["goko_blacklisted", true, true]; }];

//-- If respawn on start is disabled, manually add action on mission start
if (getNumber(missionConfigFile >> "respawnOnStart") <= 0) then {
	player setVariable ["goko_blacklisted", true, true];
};

