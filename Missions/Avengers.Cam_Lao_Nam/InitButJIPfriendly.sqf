

vn_fnc_music = compile preprocessFileLineNumbers "vn_fnc_music.sqf";


// For the home-made Improved Melee System Compat Patch
// Requires allowFunctionsRecompile = 1; in mission description.ext 
IMS_fnc_allowDamageWrapper = {
	params ["_unit", "_state"];
	
};
IMS_fnc_setDamageWrapper = {
	params ["_unit", "_dmg"];
	
	private _fnc_unstuckAnimation = {
		params ["_unit", "_anim"];
		if (DEF_IMS_UNCONSCIOUS_ANIMS findIf { _anim == _x } >= 0 || DEF_A3_INCAPPED_STATES findIf {lifeState _unit == _x} >= 0 ) then 
		{
			[_unit, "AmovPpneMstpSrasWrflDnon"] remoteExec ["switchMove", 0];
			if (!isNil{ _thisEvent } && !isNil{ _thisEventHandler }) then {
				_unit removeEventHandler [_thisEvent, _thisEventHandler];
			};
		};
		//if (underwater _unit) then {
			private _blood = _unit nearObjects ["Blood_01_Base_F", 10];
			{deleteVehicle _x} forEach _blood;
		//};
	};
	
	if (isDamageAllowed _unit) then {
		_unit setDamage _dmg;
		diag_log format ["(IMS_WRAPPER) %1 setDamage %2", _unit, _dmg];
		
		if (_dmg >= 1 /*&& underwater _unit*/) then // static animations are especially noticeable on divers, because they become static instead of sinking 
		{
			_unit addEventHandler ["AnimDone", _fnc_unstuckAnimation];
		};
	};
};
IMS_fnc_findNearestEnemyWrapper = {
	params ["_unit1","_unit2",["_result", objNull]];
	if (_result isEqualTo objNull) exitWith {
		_unit1 findNearestEnemy _unit2 
	};
	_result getVariable "ForcedNearestEnemyResult"
};
WBK_IMSIsEnabledStaticDeaths = false;
//publicVariable "WBK_IMSIsEnabledStaticDeaths";

[] execVM "scripts\ApplyGokuPatch.sqf";
