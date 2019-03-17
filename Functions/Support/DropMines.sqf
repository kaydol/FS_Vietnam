
	/* 
	
		Description:
			causes a mines to fall in the area of ~100-150 meters
		Parameters:
		_this select 0 : center , format [x,y,z]
		_this select 1 : rounds count
		_this select 2 : radius
		_this select 3 : delay beetween rounds 
		_this select 4 : type of rounds
		_this select 5 : height
		_this select 6 : delay before first round
		_this select 7 : debug, true\false
		
		[getPos player, 10] spawn FS_fnc_DropMines
		[_pos, _rounds, _radius, _delayBetweenRounds, _roundType, _height, _initDelay, _debug] spawn FS_fnc_DropMines
		
		Each projectile has it's own unique trajectory.
		Bombs fall at different angles from different directions and with different velocities.
	
	*/
	
    params ["_pos", ["_count", 5], ["_radius", 25 + random 25], ["_delay", 0.5], ["_type", "Sh_82mm_AMOS"], ["_height", 300], ["_initDelay", 0], ["_debug", false]];
	
	private["_mine", "_x", "_y", "_i", "_velocity", "_pos1", "_pos2"];
	
	//["mp_alarm", "FS_PlaySoundGlobal"] call BIS_fnc_MP;
	
	sleep _initDelay;
	
	_markers = [];
	
	for "_i" from 1 to _count do 
	{
		_x = _radius - random(_radius*2); 
		_y = _radius - random(_radius*2); 
			
		_mine = _type createVehicle [(_pos select 0) + _x, (_pos select 1) + _y, _height];  
		_mine setPos [(_pos select 0) + _x, (_pos select 1) + _y, _height];
		
		_pos1 = getPos _mine;
		_pos2 = _pos getPos [random _radius, random 360];
		_velocity = [(_pos2 select 0) - (_pos1 select 0), (_pos2 select 1) - (_pos1 select 1), (_pos2 select 2) - (_pos1 select 2)];
		
		_mine setVelocity _velocity;
		
		if ( _debug ) then {
			private["_mark"];
			_mark = createMarker [format ["%1",random 10000], [(_pos select 0) + _x, (_pos select 1) + _y]];
			_mark setMarkerType "hd_destroy";
			_markers pushBack _mark;
		};
		
		sleep (_delay + random _delay / 2);
	};

	if ( _debug ) then {
		// gradually increase transparency
		_markers spawn {
			_lifetime = 10;
			for [{_i = 0},{_i < _lifetime},{_i = _i + _lifetime / 10}] do {
				sleep (_lifetime / 10);
				{
					_x setMarkerAlphaLocal linearConversion [0, _lifetime, _i, 1, 0];
				} forEach _this;
			};
			{ deleteMarker _x } forEach _this;
		};
	};