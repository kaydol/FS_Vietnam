/*
	Places a sniper on the tree.
*/

params ["_tree"];

_buildingPositions = _tree call BIS_fnc_buildingPositions;
if (_buildingPositions isEqualTo []) exitWith {};

_rndPos = selectRandom _buildingPositions;
_tree allowDamage false;

_NewGrp = createGroup EAST;
"uns_men_NVA_daccong_MRK" createUnit [_rndPos, _NewGrp, "", 1, "PRIVATE"];
_unit = units _NewGrp select 0;
_unit setPos _rndPos;

[_unit, _tree] execFSM "\FS_Vietnam\FSM\TreeSniper.fsm"; 


