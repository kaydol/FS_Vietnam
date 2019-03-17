params ["_unit", "_deathSound"];

// Runs on all clients via [_args] remoteExec ["spawn", 0]
_burningTime = 4;

_source = "#particlesource" createVehicleLocal getPos _unit;
_source setParticleCircle [0, [0, 0, 0]];
_source setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 0.25, [0, 0, 0, 0], 0, 0];
_source setParticleClass "MediumSmoke";
_source setParticleFire [0.3,1.0,0.01];

//_source setDropInterval 0.05;

_emitter = "Land_HelipadEmpty_F" createVehicleLocal getPos _unit;
_emitter attachTo [_unit, [0,0,0], "head_hit"];

if ( _unit != player ) then 
{
	_unit setRandomLip True;
	_emitter say3D [_deathSound, 200];
};

sleep _burningTime;

// if (local _unit) then { _unit setDamage 1; };
_unit setRandomLip False;

_source setDropInterval 0;
deleteVehicle _source;
deleteVehicle _emitter;



