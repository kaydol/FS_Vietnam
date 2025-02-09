/*
	Spawns phosphorus strands
	
	Batteries can't be created locally and therefore have to be created on the server.
	
	Server creates the batteries and then sends a single remoteExec that tells all the
	clients to attach a local smoke emitter to each of the batteries.
	
*/

if (!isServer) exitWith {};

params ["_posATL"];

_numberOfProjectiles = floor 6;

_batteries = [];

// Server spawns batteries and applies velocity to them
while { _numberOfProjectiles > 0 } do 
{
	_velocityX = ( selectRandom [1,-1] ) * floor ( 10 + random 30 );
	_velocityY = ( selectRandom [1,-1] ) * floor ( 10 + random 30 );
	_velocityZ = 10 + random 50;
	
	_battery = createVehicle ["Land_Battery_F", _posATL, [], 20, "CAN_COLLIDE"];
	_battery setVelocity [_velocityX, _velocityY, _velocityZ];
	
	_batteries pushBack _battery;
	
	_numberOfProjectiles = _numberOfProjectiles - 1;
};

// Server tells everybody to attach smoke emitters to each of the batteries
[_batteries, 
{
	if (!hasInterface) exitWith {};
	{
		_x spawn
		{
			if (isNull _this) exitWith {};
			
			_smoker = "#particlesource" createVehicleLocal getPos _this;
			_smoker setParticleCircle [0, [0, 0, 0]];
			_smoker setParticleRandom [2, [0, 0, 0], [0.2, 0.2, 0.5], 0.3, 0.5, [0, 0, 0, 0.5], 0, 0];
			_smoker setParticleParams [["\A3\data_f\cl_basic.p3d", 1, 0, 1], // p3dPath, Ntieth, Index, FrameCount, Loop
				 "", // animationName (obsolete parameter that was meant to play .rtm anims, should be empty)
				 "Billboard", // particleType ("Billboard" or "SpaceObject")
				 1, // timerPeriod
				 7, // lifeTime
				 [0, 0, 0], // position
				 [0, 0, 0.5], // moveVelocity
				 0, // rotationVelocity (rotations per second)
				 10.1, // weight (weight of the particle, kg)
				 7.9, // volume (volume of the particle in m3)
				 0.01, // rubbing (determines how much particles blown by winds)
				 [0, 3], // size (array of particle size along its lifetime)
				 [[1,1,1,0], [1,1,1,1], [1,1,1,0.5], [1,1,1,0.25], [1,1,1,0]], // color (array of [RGBA] arrays)
				 [0.125], // animationSpeed
				 1, // randomDirectionPeriod
				 0, // randomDirectionIntensity
				 "", // onTimerScript
				 "", // beforeDestroyScript
				 _this // this (if this parameter isn't objNull, the particle source will be attached to the object, the generation of particles stops when beyond Object View Distance)
			];
			_smoker setDropInterval 0.02;
			
			sleep 1.5;
			
			deleteVehicle _smoker;
		};
	}
	forEach _this;
	
}] remoteExec ["call", 0];

sleep 3;

// Server deletes the batteries
{
	deleteVehicle _x;
} 
forEach _batteries;
