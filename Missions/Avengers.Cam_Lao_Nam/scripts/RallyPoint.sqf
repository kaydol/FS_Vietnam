
#define DEF_GLOBAL_VARIABLE_MARKER_NAME Rally_Point_Marker_Name
#define DEF_ACTION_ID_GLOBAL_VARIABLE Rally_Point_ActionId
#define DEF_MIN_DISTANCE_MOVED_TO_DROP_RALLY 50
#define DEF_DEBUG false 

params ["_unit"];

#include "RallyPointInclude.h";

DEF_GLOBAL_VARIABLE_MARKER_NAME = "respawn_west_rally_point";

//if (_unit == player || !isPlayer _unit) then {
//	[_unit, _unit] call _fnc_deployRallyPoint;
//};

if (_unit == player) then 
{
	if !(player diarySubjectExists "Readme") then 
	{
		player createDiarySubject ["Readme","Your abilities"];
		player setDiarySubjectPicture ["Readme","Your abilities"];
	};

	player createDiaryRecord ["Readme", ["Rally Point", format ["<br/>You can drop a respawn point for your side to respawn at.<br/><br/>Must be at least %1m away from the previous rally point (this radius is marked on the map).<br/><br/>Must not be incapacitated.<br/><br/>", DEF_MIN_DISTANCE_MOVED_TO_DROP_RALLY]]];

	sleep 1;

	["RespawnAdded", ["Perk: Rally Point", format ["You can deploy a spawn point for your team every %1m", DEF_MIN_DISTANCE_MOVED_TO_DROP_RALLY], '\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\instructor_ca.paa']] call BIS_fnc_showNotification;
	//systemChat format ["New Perk: Rally Point - You can deploy a spawn point for your team every %1m", DEF_MIN_DISTANCE_MOVED_TO_DROP_RALLY];

	
	private _fnc_addAction = {
	
		params ["_unit", ["_corpse", objNull]];
		
		#include "RallyPointInclude.h";
		
		private _fnc_canDeployRallyPoint = {
			params ['_unit', '_markerName'];
			
			if (DEF_DEBUG) then {
				hintSilent format ["Dist to %1 is %2", _markerName, _unit distance2D (getMarkerPos _markerName)];
			};
			
			private _markerIsFarEnough = (_unit distance2D (getMarkerPos _markerName)) > DEF_MIN_DISTANCE_MOVED_TO_DROP_RALLY;
			private _isIncapacitated = _unit getVariable ['vn_revive_incapacitated', false];
			
			!_isIncapacitated && _markerIsFarEnough
		};
		
		
		if (DEF_ACTION_ID_GLOBAL_VARIABLE >= 0 && !(isNull _corpse)) then {
			_corpse removeAction DEF_ACTION_ID_GLOBAL_VARIABLE;
			DEF_ACTION_ID_GLOBAL_VARIABLE = -1;
		};
		
		private _id = _unit addAction ["<t size='2.0' color='#00ff00'>Drop Rally Point</t>", _fnc_deployRallyPoint, [], 0, false, true, "", 
			format ["alive player && [player, '%1'] call %2", DEF_GLOBAL_VARIABLE_MARKER_NAME, _fnc_canDeployRallyPoint]
		];
		DEF_ACTION_ID_GLOBAL_VARIABLE = _id;
	};


	DEF_ACTION_ID_GLOBAL_VARIABLE = -1;


	//-- "Respawn" EH is persisted across multiple respawns
	_unit addEventHandler ["Respawn", _fnc_addAction];

	//-- If respawn on start is disabled, manually add action on mission start
	if (getNumber(missionConfigFile >> "respawnOnStart") <= 0) then {
		_unit call _fnc_addAction;
	};
	
};





