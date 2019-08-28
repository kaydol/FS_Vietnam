
/*
	Spawns a wall of particles in a circle
	Intended to be spawned in place of bomb impacts
*/

params ["_posATL", "_radius", "_lifetime"];

_anchor = "#particlesource" createVehicleLocal _posATL;

_isDay = daytime > 6 && daytime < 17;

// Fire 
_fireCircle = "#particlesource" createVehicleLocal _posATL;
_fireCircle setParticleCircle [0.9 * _radius, [0, 0, 0]];
_fireCircle setParticleRandom [1, [0.25, 0.25, 0], [0.175, 0.175, 0.1], 5, 0.25, [0, 0, 0, 0.5], 0.5, 0];
_fireCircle setParticleParams [
	/*Sprite*/				["\A3\data_f\cl_exp", 1, 0, 1], "",// [File,Ntieth,Index,Count,Loop(Bool)], "?"
	/*Type*/				"Billboard", 
	/*TimmerPer*/			1,
	/*Lifetime*/			2.5, 
	/*Position*/			[0,0,0],  
	/*MoveVelocity*/		[0,0,2], 
	/*Simulation*/			0,10,7.9,0.1, //rotationVel,weight,volume,rubbing
	/*Scale*/				[_radius / 2 + 2, _radius / 2 + 1, _radius / 2 + 0.5],  
	/*Color*/				[[1, 1, 1, 0], [1, 1, 1, 1], [0.3, 0.3, 0.3, 0.5], [0, 0, 0, 0]],
	/*AnimSpeed*/			[1], 
	/*randDirPeriod*/		1, 
	/*randDirIntesity*/		0,
	/*onTimerScript*/		"",
	/*DestroyScript*/		"",
	/*Follow*/				_anchor
];
_fireCircle setDropInterval 0.05;

// Smoke
_smokeCircle = "#particlesource" createVehicleLocal _posATL;
_smokeCircle setParticleCircle [_radius+1, [0, 0, 0]];
_smokeCircle setParticleRandom [30, [0.25, 0.25, 0], [0.175, 0.175, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
_smokeCircle setParticleParams [
	/*Sprite*/				["\A3\data_f\cl_basic", 1, 0, 1], "",// [File,Ntieth,Index,Count,Loop(Bool)], "?"
	/*Type*/				"Billboard", 
	/*TimmerPer*/			1,
	/*Lifetime*/			5,
	/*Position*/			[0,0,0],  
	/*MoveVelocity*/		[0,0,0.5], 
	/*Simulation*/			10,10,7.9,0.1, //rotationVel,weight,volume,rubbing
	/*Scale*/				[_radius / 2 + 1.5, _radius / 2 + 2.5,_radius / 2 + 3, _radius / 2 + 5, _radius / 2 + 7, _radius / 2 + 10],  
	/*Color*/				[[0.1, 0.1, 0.1, 0], [0.1, 0.1, 0.1, 0.5], [0.1, 0.1, 0.1, 1], [0.5, 0.35, 0.1, 0.8], [0, 0, 0, 0.9], [0.01, 0.01, 0.01, 0.5], [0, 0, 0, 0.05]],
	/*AnimSpeed*/			[0.08], 
	/*randDirPeriod*/		1, 
	/*randDirIntesity*/		0,
	/*onTimerScript*/		"",
	/*DestroyScript*/		"",
	/*Follow*/				_anchor
];
_smokeCircle setDropInterval 0.5;

if !( _isDay ) then 
{
	[_anchor, _radius] spawn 
	{
		params ["_anchor", "_radius"]; 
		
		_light = "#lightpoint" createVehicleLocal ([1,1,1]); 
		_light lightAttachObject [_anchor, [0,0,-1]];
		_light setLightAmbient [1,0.1,0];
		_light setLightColor [1,0,0];
		_light setLightUseFlare true;
		_light setLightDayLight true;
		
		while {!isNull _anchor} do 
		{
			_light setLightBrightness 8 + random 1;
			_light setLightAttenuation [
				/*start*/ random _radius / 2, 
				/*constant*/ 70 + random 10, 
				/*linear*/ 10 + random 20, 
				/*quadratic*/ 0, 
				/*hardlimitstart*/ 1 + random 0.5, 
				/*hardlimitend*/ 300
			]; 
			sleep (0.2 - random 0.15);
		};
		deleteVehicle _light;
	};
	
};

sleep _lifetime;

deleteVehicle _anchor; 