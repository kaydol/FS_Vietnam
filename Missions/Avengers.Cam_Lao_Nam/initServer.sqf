//--- Curator settings
_curator = allcurators select 0;
_curators = allcurators;

//--- Unlock everything
{
	_x setcuratorcoef ["place",0];
	_x setcuratorcoef ["delete",0];
} foreach _curators;

vn_force_end = true;
publicVariable "vn_force_end";


[] execVM "InitButJIPfriendly.sqf";


private _zeusModules = allMissionObjects "ModuleCurator_F";
if !(_zeusModules isEqualTo []) then 
{
	private _zeus = _zeusModules # 0;
	
	//-- Adding groups to Zeus 
	{
		_zeus addCuratorEditableObjects [units _x,true];
		{
			_x addEventHandler ["Respawn", { 
				params ["_localUnit", ["_corpse", objNull]];
				private _zeusModules = allMissionObjects "ModuleCurator_F";
				if (_zeusModules isEqualTo []) exitWith{};
				private _zeus = _zeusModules # 0;
				
				[_zeus, [[_localUnit], true]] remoteExec ["addCuratorEditableObjects", 2];
				//_zeus addCuratorEditableObjects [[_localUnit],true];
				
				diag_log format ["(SyncToZeus @ %1) Unit (%2 @ %3) respawned, syncing to zeus (%4 @ %5)", clientOwner, _localUnit, owner _localUnit, _zeus, owner _zeus];
			}];
		} forEach units _x;
	} forEach (allgroups select {side _x == civilian || side _x == west});
	
	//-- Adding all mines to Zeus 
	_zeus addCuratorEditableObjects [allMines,true];
	
};

