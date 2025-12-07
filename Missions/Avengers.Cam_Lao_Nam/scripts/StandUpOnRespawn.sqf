

//-- "Respawn" EH is persisted across multiple respawns
player addEventHandler ["Respawn", {
	params ["_unit", "_corpse"];
	if !(isNull _corpse) then {
		deleteVehicle _corpse; //-- Delete player's body 
	};
	private _anim = selectRandom ["Acts_Getting_Up_Player", "Acts_Flashes_Recovery_1", "Acts_Flashes_Recovery_2"]; 
	[player, _anim] remoteExec ["switchMove", 0]; 
	0 cutText ["", "BLACK IN", 10, true, true]; 
}];

