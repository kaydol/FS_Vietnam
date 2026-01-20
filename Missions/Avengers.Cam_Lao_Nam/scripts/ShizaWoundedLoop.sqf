
#define DEF_SHIZA_CHANCE 0.6

_this spawn 
{
	params ["_player"];
	
	while {sleep 1; true} do 
	{
		waitUntil { sleep 1; _player getVariable ["vn_revive_incapacitated", false] };
		
		if ((random 1) < DEF_SHIZA_CHANCE) then {
			_player execVM "scripts\ShizaWounded.sqf";
		};
		
		waitUntil { sleep 1; !(_player getVariable ["vn_revive_incapacitated", true]) };
	};
};