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

#define INCOMING_SHELL_SOUNDS ["incoming_1", "incoming_2", "incoming_3", "incoming_4", "incoming_5", "incoming_6", "incoming_7", "incoming_8", "incoming_9", "incoming_10", "incoming_11", "incoming_12", "incoming_13"]

params ["_posOrObject", ["_salvos", 5], ["_radius", 25 + random 25], ["_type", "Sh_82mm_AMOS"], ["_height", 150], ["_initDelay", 0], ["_debug", false]];

sleep _initDelay;

private ["_i"];
private _markers = [];

for "_i" from 1 to _salvos do 
{
	for [{_j = 0},{_j < 6},{_j = _j + 1}] do 
	{
		private _position = if ( _posOrObject isEqualType objNull ) then [{ getPos _posOrObject }, { _posOrObject }];
		
		if ( _position isEqualTo [0,0,0] ) exitWith {}; // object became null 
		
		[_position, {
			if !(hasInterface) exitWith {};
			playSound3D [format ["FS_Vietnam\Effects\Artillery\Sound\%1.ogg", selectRandom INCOMING_SHELL_SOUNDS], nil, false, ATLToASL [_this # 0, _this # 1, 50], 10, 1.5, 800];
		}]
		remoteExec ["call", 0];
		
		sleep (0.3 + random 2);
		
		private _x = _radius - random(_radius*2); 
		private _y = _radius - random(_radius*2); 
			
		private _mine = _type createVehicle [(_position select 0) + _x, (_position select 1) + _y, _height];
		
		_mine setPos [(_position select 0) + _x, (_position select 1) + _y, _height];
		
		private _pos1 = getPos _mine;
		private _pos2 = _position getPos [random _radius, random 360];
		private _velocity = [(_pos2 select 0) - (_pos1 select 0), (_pos2 select 1) - (_pos1 select 1), (_pos2 select 2) - (_pos1 select 2)];
		
		_mine setVelocity _velocity;
		
		if ( _debug ) then {
			private _mark = createMarker [format ["%1",random 10000], [(_position select 0) + _x, (_position select 1) + _y]];
			_mark setMarkerType "mil_dot";
			_mark setMarkerColor "ColorRed";
			_markers pushBack _mark;
		};
		
		[_mine, _pos2] spawn 
		{
			params ["_mine", "_position"];
			
			waitUntil {!alive _mine};
			
			[_position] remoteExec ["FS_fnc_FallingDirt", 0];
			
			{ _x hideObjectGlobal true } foreach (nearestTerrainObjects [_position,["bush"],10]);
		};
		
	};
	
	sleep 6;
};

sleep 6;

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