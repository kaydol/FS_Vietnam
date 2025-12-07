
private _syncToZeus = {
	params ["_unit"];
	[_unit, {
		params ["_unit"];
		
		private _zeusModules = allMissionObjects "ModuleCurator_F";
		if !(_zeusModules isEqualTo []) then 
		{
			private _zeus = _zeusModules # 0;
			_zeus addCuratorEditableObjects [[_unit],true];
			
			diag_log format ["(SyncToZeus @ %1) Unit (%2 @ %3) respawned, syncing to zeus (%4 @ %5)", clientOwner, _unit, owner _unit, _zeus, owner _zeus];
		};
	}] remoteExec ["spawn", 0];
};

if (!isNull player) then 
{
	//-- "Respawn" EH is persisted across multiple respawns
	player addEventHandler ["Respawn", _syncToZeus];

	//-- If respawn on start is disabled, manually add action on mission start
	if (getNumber(missionConfigFile >> "respawnOnStart") <= 0) then {
		[player] call _syncToZeus;
	};
};

