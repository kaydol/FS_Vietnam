	
	switch (_shizaType) do 
	{
		case DEF_ILLUSION_PRIGOZHIN: 
		{
			private _time = time;
			
			waitUntil {
				!alive DEF_CURRENT_PLAYER || 
				!(DEF_CURRENT_PLAYER getVariable ["vn_revive_incapacitated", false]) ||
				!DEF_FNC_IS_LOCKED(DEF_NPC_VAR,DEF_GLOBAL_ANIM_DONE_EH_ID) || 			//-- custom addition to this case, compared to default 
				call _fnc_getDistanceToHumans <= DEF_MIN_DISTANCE_TO_TRIGGER ||
				((time - _time) > DEF_TIMEOUT)
			};

			diag_log format ["(ShizaWounded @ %1) Script finished: player dead=%2, player revived=%3, handler deleted itself=%4, distance=%5, timeout=%6", 
				clientOwner,
				!alive DEF_CURRENT_PLAYER, 
				!(DEF_CURRENT_PLAYER getVariable ["vn_revive_incapacitated", false]), 
				!DEF_FNC_IS_LOCKED(DEF_NPC_VAR,DEF_GLOBAL_ANIM_DONE_EH_ID), 
				call _fnc_getDistanceToHumans <= DEF_MIN_DISTANCE_TO_TRIGGER,
				time - _time > DEF_TIMEOUT
			];
			
			if (DEF_FADESOUND_TO != 1) then {
				DEF_FADESOUND_OVER fadeSound 1;
			};
		};
		case DEF_ILLUSION_PLANE: 
		{
			private _time = time;
			
			waitUntil {
				!alive DEF_CURRENT_PLAYER || 
				!(DEF_CURRENT_PLAYER getVariable ["vn_revive_incapacitated", false]) ||
				!DEF_FNC_IS_LOCKED(DEF_NPC_VAR,DEF_GLOBAL_ANIM_DONE_EH_ID) || 			//-- custom addition to this case, compared to default  
				((vehicle player == player) || !(alive vehicle player)) ||				//-- custom addition to this case, compared to default
				call _fnc_getDistanceToHumans <= DEF_MIN_DISTANCE_TO_TRIGGER ||
				((time - _time) > DEF_TIMEOUT)
			};

			diag_log format ["(ShizaWounded @ %1) Script finished: player dead=%2, player revived=%3, handler deleted itself=%4, player exited vehicle=%5, distance=%6, timeout=%7", 
				clientOwner,
				!alive DEF_CURRENT_PLAYER, 
				!(DEF_CURRENT_PLAYER getVariable ["vn_revive_incapacitated", false]), 
				!DEF_FNC_IS_LOCKED(DEF_NPC_VAR,DEF_GLOBAL_ANIM_DONE_EH_ID), 
				(vehicle player == player) || !(alive vehicle player),
				call _fnc_getDistanceToHumans <= DEF_MIN_DISTANCE_TO_TRIGGER,
				time - _time > DEF_TIMEOUT
			];
			
			if (DEF_FADESOUND_TO != 1) then {
				DEF_FADESOUND_OVER fadeSound 1;
			};
		};
		default 
		{
			private _time = time;
		
			waitUntil {
				!alive DEF_CURRENT_PLAYER || 
				!(DEF_CURRENT_PLAYER getVariable ["vn_revive_incapacitated", false]) ||
				call _fnc_getDistanceToHumans <= DEF_MIN_DISTANCE_TO_TRIGGER ||
				((time - _time) > DEF_TIMEOUT)
			};
			
			diag_log format ["(ShizaWounded @ %1) Script finished: player dead=%2, player revived=%3, distance=%4, timeout=%5", 
				clientOwner,
				!alive DEF_CURRENT_PLAYER, 
				!(DEF_CURRENT_PLAYER getVariable ["vn_revive_incapacitated", false]), 
				call _fnc_getDistanceToHumans <= DEF_MIN_DISTANCE_TO_TRIGGER,
				time - _time > DEF_TIMEOUT
			];

			if (DEF_FADESOUND_TO != 1) then {
				DEF_FADESOUND_OVER fadeSound 1;
			};
		};
	};