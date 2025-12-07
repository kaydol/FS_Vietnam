

	if (_shizaType == DEF_ILLUSION_PRIGOZHIN) then 
	{
		
		if (!isTouchingGround DEF_CURRENT_PLAYER || animationState DEF_CURRENT_PLAYER != DEF_WOUNDED_ANIM) then 
		{
			diag_log format ["(ShizaWounded @ %1) Waiting for %2 to touch ground", clientOwner, DEF_CURRENT_PLAYER];
			private _time = time;
			
			waitUntil {
				sleep 1;
				(isTouchingGround DEF_CURRENT_PLAYER && animationState DEF_CURRENT_PLAYER == DEF_WOUNDED_ANIM) || 
				call _fnc_getDistanceToHumans <= DEF_MIN_DISTANCE_TO_TRIGGER ||
				((time - _time) > DEF_TIMEOUT)
			};
		};

		if (!alive DEF_CURRENT_PLAYER) exitWith {
			DEF_FNC_RELEASE_LOCK(DEF_NPC_VAR,DEF_GLOBAL_ANIM_DONE_EH_ID);
			DEF_CURRENT_ILLUSION_VAR = nil;
		};
		
		if (call _fnc_getDistanceToHumans <= DEF_MIN_DISTANCE_TO_TRIGGER) exitWith {
			DEF_FNC_RELEASE_LOCK(DEF_NPC_VAR,DEF_GLOBAL_ANIM_DONE_EH_ID);
			DEF_CURRENT_ILLUSION_VAR = nil;
		};
		
		if (DEF_FADESOUND_TO != 1) then {
			DEF_FADESOUND_OVER fadeSound DEF_FADESOUND_TO;
		};
		
	} 
	else 
	{
		
		if (!isTouchingGround DEF_CURRENT_PLAYER || animationState DEF_CURRENT_PLAYER != DEF_WOUNDED_ANIM) then 
		{
			diag_log format ["(ShizaWounded @ %1) Waiting for %2 to touch ground", clientOwner, DEF_CURRENT_PLAYER];
			private _time = time;
			
			waitUntil {
				sleep 1;
				(isTouchingGround DEF_CURRENT_PLAYER && animationState DEF_CURRENT_PLAYER == DEF_WOUNDED_ANIM) || 
				call _fnc_getDistanceToHumans <= DEF_MIN_DISTANCE_TO_TRIGGER ||
				((time - _time) > DEF_TIMEOUT)
			};
		};

		if (!alive DEF_CURRENT_PLAYER) exitWith {
			DEF_CURRENT_ILLUSION_VAR = nil;
		};

		if (call _fnc_getDistanceToHumans <= DEF_MIN_DISTANCE_TO_TRIGGER) exitWith {
			DEF_CURRENT_ILLUSION_VAR = nil;
		};

		if (DEF_FADESOUND_TO != 1) then {
			DEF_FADESOUND_OVER fadeSound DEF_FADESOUND_TO;
		};
	};
