/*
	This function assigns a FiredNear to a random alive unit
	When the unit dies, the EH is reassigned to someone else
	If the whole group is dead, the function cleans everything and stops
*/

params ["_group"];

_ehID = -1;

while {{alive _x} count units _group > 0} do {

	_pickNext = selectRandom (( units _group ) select {alive _x} );
	
	_ehID = _pickNext addEventHandler ["FiredNear", {
		_this call FS_fnc_GrpFiredNearExec;
	}];
	
	waitUntil { sleep 10; !alive _pickNext };
	
	if ( !isNull _pickNext ) then {
		_pickNext removeEventHandler ["FiredNear", _ehID];
	};
	
};

