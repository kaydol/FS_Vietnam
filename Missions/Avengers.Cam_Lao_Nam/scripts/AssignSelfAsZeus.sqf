
#define DEF_ZEUS_UNIT curator
#define DEF_ASSIGN_SELF_AS_ZEUS_ACTION_ID "AssignSelfAsZeusActionId"
#define DEF_ASSIGN_SELF_AS_ZEUS_ACTION_DESCRIPTION "Assign self as Zeus..."
#define DEF_ASSIGN_SELF_AS_ZEUS_ACTION_ICON "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa"

//-- Hosts and logged in admins will have an action to assign self as Zeus
private _assignSelfAsZeus = {
	params ["_unit", ["_corpse", objNull]];
	{
		private _previousAction = _x getVariable DEF_ASSIGN_SELF_AS_ZEUS_ACTION_ID;
		if (!isNil{_previousAction}) then {
			[_x, _previousAction] call BIS_fnc_holdActionRemove;
		};
	} forEach ([_unit, _corpse] select {!(_x isEqualTo objNull)});
	
	private _id = [
		player, 
		DEF_ASSIGN_SELF_AS_ZEUS_ACTION_DESCRIPTION, 
		DEF_ASSIGN_SELF_AS_ZEUS_ACTION_ICON, 
		DEF_ASSIGN_SELF_AS_ZEUS_ACTION_ICON, 
		'player != DEF_ZEUS_UNIT && (isServer || call BIS_fnc_admin > 0)', 
		"true", 
		{},
		{},
		//{ [player, {_this assignCurator (allMissionObjects "ModuleCurator_F") # 0}] remoteExec ["call", 2]; }, 
		{ 	
			[player, {
				params ["_zeusControllingUnit"];
				DEF_ZEUS_UNIT = _zeusControllingUnit; 
				publicVariable 'DEF_ZEUS_UNIT';
			}] remoteExec ["call", 2]; 
		},
		{},
		[],
		3,
		-1000,
		false,
		false
	] call BIS_fnc_holdActionAdd; 
	
	_unit setVariable [DEF_ASSIGN_SELF_AS_ZEUS_ACTION_ID, _id];
};

//-- "Respawn" EH is persisted across multiple respawns
player addEventHandler ["Respawn", _assignSelfAsZeus];

//-- If respawn on start is disabled, manually add action on mission start
if (getNumber(missionConfigFile >> "respawnOnStart") <= 0) then {
	[player] call _assignSelfAsZeus;
};
