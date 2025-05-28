
/* ----------------------------------------------------------------------------
Function: FS_fnc_OccupyTree

Description:
	Places a sniper on the tree and runs a custom FSM on them, 
	making them turn their head and change positions on the tree 
	so they are always on the closest corner of the platform 
	to the enemy if there are more than one position defined 
	in the tree's config and the enemy was spotted.
	
	In the FSM there is a custom script that regulates the sniper's
	rate of fire to deliberately make him fire a lot slower than he can
	if the enemy is far from his position, to make it more difficult for
	the enemy to pinpoint his location. As the enemy gets closer, the ROF
	increases linearly until the full ROF is reached when there is no need
	to hide anymore, as this sniper's position obviously got compromised.
	
	This FSM was designed to work with semi-auto weapons like SVD,
	but should probably work with bolt-action rifles, too.
	
	The snipers will only attempt to move on their platform if they 
	are not in view of any players. The snipers will freeze for a short 
	time after each shot.
	
Parameters:
    _tree - Building with config defined positions to place a sniper in 
	_assignedCurator - Curator module to make the sniper editable for 
	
Returns:
    Nothing.

Author:
    kaydol
---------------------------------------------------------------------------- */

#include "..\..\definitions.h"

params ["_tree", ["_assignedCurator", objNull], ["_debug", false]];

private _buildingPositions = _tree call BIS_fnc_buildingPositions;
if (_buildingPositions isEqualTo []) exitWith {
	"Could not place a sniper on this tree because it has no building positions defined in config" call BIS_fnc_error;
};

private _validCurator = false;
//-- If _assignedCurator is given as a string, try to get the global variable out of it 
if (_assignedCurator isEqualType "" && !(_assignedCurator isEqualTo "")) then {
	_assignedCurator = missionNameSpace getVariable [_assignedCurator, objNull];
};
if (_assignedCurator isEqualType objNull && alive _assignedCurator) then {
	_validCurator = true;
};

_tree allowDamage false;
_tree enableDynamicSimulation true;

private _newGrp = createGroup EAST;
private _class = selectRandom DEF_TREE_SNIPERS;

_class createUnit [_buildingPositions # 0, _newGrp, "", 1, "PRIVATE"];

private _unit = units _newGrp select 0;
_unit triggerDynamicSimulation false; 

//-- Disable RNG movement when used with RNG AI addon 
if (isClass (configFile >> "CfgPatches" >> "RNG_mod")) then {
	_unit setVariable ["RNG_disabled",true,true]; 
};

if (_validCurator) then {
	_assignedCurator addCuratorEditableObjects [units _newGrp, false];
};

//-- Exclude live tree snipers from Garbage Collector 
//_newGrp setVariable [DEF_GC_EXCLUDE_GROUP_VAR, true, true];

private _fsm = [_unit, _tree, nil, _debug] execFSM "\FS_Vietnam\FSM\TreeSniper.fsm"; 

_unit setVariable [DEF_SNIPER_FSM_HANDLE, _fsm, true];

