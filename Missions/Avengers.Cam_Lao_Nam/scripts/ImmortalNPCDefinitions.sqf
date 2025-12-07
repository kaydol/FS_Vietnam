
private _fnc_playAnimDone = {
	_this spawn {
		params ['_unit', '_anim'];
		diag_log format ['_anim = %1, find1 = %2, find2=%3, state = %4', _anim, DEF_IMS_UNCONSCIOUS_ANIMS findIf { _anim == _x }, DEF_A3_INCAPPED_STATES findIf {lifeState _unit == _x}, lifeState _unit];
		
		// string comparison of "in" is case sensitive 
		if (DEF_IMS_UNCONSCIOUS_ANIMS findIf { _anim == _x } >= 0 || DEF_A3_INCAPPED_STATES findIf {lifeState _unit == _x} >= 0 ) then 
		{
			if (isDamageAllowed _unit) then {
				[_unit, ''] remoteExec ['switchMove', 0];
				_unit removeEventHandler [_thisEvent, _thisEventHandler];
			} else { 
				[_unit, selectRandom DEF_STANDUP_ANIMS] remoteExec ['switchMove', 0];
				_unit setUnconscious false;
			};
		};
	};
};
