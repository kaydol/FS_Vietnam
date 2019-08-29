/* ----------------------------------------------------------------------------
Function: FS_fnc_DropMines

Description:
	Causes mines to fall in the area. Each projectile has it's own unique trajectory.
	Bombs fall at different angles from different directions and with different velocities.
	
Parameters:
    _this select 0 : center, format [x,y,z]
	_this select 1 : ammount of salvos, each salvo is 6 rounds followed by a delay
	_this select 2 : radius
	_this select 3 : type of rounds
	_this select 4 : height
	_this select 5 : delay before the first round
	_this select 6 : debug, true\false
	
Author:
    kaydol
---------------------------------------------------------------------------- */


params ["_pos", ["_salvos", 5], ["_radius", 25 + random 25], ["_type", "Sh_82mm_AMOS"], ["_height", 150], ["_initDelay", 0], ["_debug", false]];

sleep _initDelay;

private ["_i"];
private _markers = [];
private _soundEmitters = [];

for "_i" from 1 to _salvos do 
{
	for [{_j = 0},{_j < 6},{_j = _j + 1}] do {
		
		private _emitter = "#particlesource" createVehicle [_pos # 0, _pos # 1, 50];
		private _incomingShell = ["incoming_1", "incoming_2", "incoming_3", "incoming_4", "incoming_5", "incoming_6", "incoming_7", "incoming_8", "incoming_9", "incoming_10", "incoming_11", "incoming_12", "incoming_13"] call BIS_fnc_SelectRandom;
		[_emitter, [_incomingShell, 500]] remoteExec ["say3D", 0];
		_soundEmitters pushBack _emitter;
		
		sleep (0.3 + random 2);
		
		private _x = _radius - random(_radius*2); 
		private _y = _radius - random(_radius*2); 
			
		private _mine = _type createVehicle [(_pos select 0) + _x, (_pos select 1) + _y, _height];  
		_mine setPos [(_pos select 0) + _x, (_pos select 1) + _y, _height];
		
		private _pos1 = getPos _mine;
		private _pos2 = _pos getPos [random _radius, random 360];
		private _velocity = [(_pos2 select 0) - (_pos1 select 0), (_pos2 select 1) - (_pos1 select 1), (_pos2 select 2) - (_pos1 select 2)];
		
		_mine setVelocity _velocity;
		
		if ( _debug ) then {
			private _mark = createMarker [format ["%1",random 10000], [(_pos select 0) + _x, (_pos select 1) + _y]];
			_mark setMarkerType "hd_destroy";
			_markers pushBack _mark;
		};
		
		[_mine, _soundEmitters, _pos2] spawn {
			params ["_mine", "_soundEmitters", "_pos"];
			waitUntil {!alive _mine};
			private _emitter = "#particlesource" createVehicle _pos;
			private _rumbling = ["dirt_1", "dirt_2", "dirt_3", "dirt_4", "dirt_5", "dirt_6", "dirt_7"] call BIS_fnc_SelectRandom;
			[_emitter, [_rumbling, 300]] remoteExec ["say3D", 0];
			_soundEmitters pushBack _emitter;
			{ _x hideObjectGlobal true } foreach (nearestTerrainObjects [_pos,["bush"],10]);
		};
		
	};
	
	
	
	sleep 6;
};

sleep 6;

{ deleteVehicle _x } forEach _soundEmitters;

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