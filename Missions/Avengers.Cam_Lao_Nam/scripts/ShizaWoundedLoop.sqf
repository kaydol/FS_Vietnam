
#define DEF_SHIZA_CHANCE_STARTS_AT 0
#define DEF_SHIZA_CHANCE_INCREASE_PER_DEATH 0.05
#define DEF_MAX_SHIZA_CHANCE 0.5

_this spawn 
{
	params ["_player"];
	
	private _shizaChance = DEF_SHIZA_CHANCE_STARTS_AT;
	
	while {sleep 1; true} do 
	{
		waitUntil { sleep 1; _player getVariable ["vn_revive_incapacitated", false] };
		
		private _isHeadUnderwater = eyePos player select 2 < 0;
		if ((random 1) < _shizaChance && !_isHeadUnderwater) then 
		{
			_player execVM "scripts\ShizaWounded.sqf";
		}
		else 
		{
			_shizaChance = (_shizaChance + DEF_SHIZA_CHANCE_INCREASE_PER_DEATH) min DEF_MAX_SHIZA_CHANCE;
			diag_log format ["(ShizaWounded @ %1) Increasing chance of shiza to %2", clientOwner, _shizaChance];
		};
		
		waitUntil { sleep 1; !(_player getVariable ["vn_revive_incapacitated", true]) };
	};
};