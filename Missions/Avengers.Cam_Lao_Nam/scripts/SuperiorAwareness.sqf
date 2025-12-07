
#define DEF_FIRED_NEAR_EH_ID "eh_superior_awareness_firednear"
#define DEF_SUPPRESSED_EH_ID "eh_superior_awareness_suppressed"

params ["_unit"];


if (_unit != player) exitWith {};


if !(player diarySubjectExists "Readme") then 
{
	player createDiarySubject ["Readme","Your abilities"];
	player setDiarySubjectPicture ["Readme","Your abilities"];
};

player createDiaryRecord ["Readme", ["Superior Awareness", "<br/>The enemies that have suppressed you are marked on the screen as targets.<br/><br/>Also triggers for enemies that fired nearby.<br/><br/>"]];

waitUntil { sleep 1; !dialog };

sleep 1;

["RespawnAdded", ["Perk: Superior Awareness", "You can tell where the enemy is firing from", '\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\instructor_ca.paa']] call BIS_fnc_showNotification;
//systemChat "New Perk: Superior Awareness - You can tell where the enemy is firing from";

private _fnc_add = {

	params ["_unit", ["_corpse", objNull]];
	
	//----
	
	if (!isNil{_corpse getVariable DEF_FIRED_NEAR_EH_ID}) then {
		_corpse removeEventHandler ["FiredNear", _corpse getVariable DEF_FIRED_NEAR_EH_ID];
	};
	
	private _id = _unit getVariable DEF_FIRED_NEAR_EH_ID;
	if (!isNil{ _id }) then {
		_unit removeEventHandler ["FiredNear", _id];
	};
	
	_id = _unit addEventHandler ["FiredNear", {
		params ["_unit", "_firer", "_distance", "_weapon", "_muzzle", "_mode", "_ammo", "_gunner"];
		
		if (_firer == player) exitWith {};
		if (side _firer == side _unit) exitWith {};
		
		_unit doTarget _firer;
		
		//systemChat "Target marked - by fired near";
	}];
	
	_unit setVariable [DEF_FIRED_NEAR_EH_ID, _id];
	
	//----
	
	if (!isNil{_corpse getVariable DEF_SUPPRESSED_EH_ID}) then {
		_corpse removeEventHandler ["Suppressed", _corpse getVariable DEF_SUPPRESSED_EH_ID];
	};
	
	_id = _unit getVariable DEF_SUPPRESSED_EH_ID;
	if (!isNil{ _id }) then {
		_unit removeEventHandler ["Suppressed", _id];
	};
	
	_id = _unit addEventHandler ["Suppressed", {
		params ["_unit", "_distance", "_shooter", "_instigator", "_ammoObject", "_ammoClassName", "_ammoConfig"];
		
		_unit doTarget _shooter;
		
		diag_log format ["(SuperiorAwareness @ %1) Target marked - by suppression", clientOwner];
	}];
	
	_unit setVariable [DEF_SUPPRESSED_EH_ID, _id];
};


//-- "Respawn" EH is persisted across multiple respawns
_unit addEventHandler ["Respawn", _fnc_add];

if (getNumber(missionConfigFile >> "respawnOnStart") <= 0) then {
	[_unit] call _fnc_add;
};