
if (!hasInterface) exitWith {};

params ["_posATL"];

_anchor = "#particlesource" createVehicleLocal _posATL;

// Spawns a single particle that expands heavily
_singleCloud = "#particlesource" createVehicleLocal getPosATL _anchor;
_singleCloud setParticleCircle [0, [0, 0, 0]];
_singleCloud setParticleRandom [0, [0.25, 0.25, 0], [0.175, 0.175, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
_singleCloud setParticleParams [
	["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 
	1, 					/*TimmerPer*/
	1.25, 				/*Lifetime*/
	[0, 0, 0], 			/*Position*/
	[0, 0, 0.75], 		/*MoveVelocity*/
	0, 					/*RotationVel*/
	10, 				/*Weight*/
	7.9, 				/*Volume*/
	0, 					/*Rubbing*/
	[10, 100], 			/*Scale*/
	[[1, 1, 1, 0], [1, 1, 1, 0.2], [1, 1, 1, 1], [1, 1, 1, 0.5], [1, 1, 1, 0]], /*Color*/
	[0.08], 			/*AnimSpeed*/
	1, 					/*randDirPeriod*/
	0, 					/*randDirIntesity*/
	"", 				/*onTimerScript*/
	"", 				/*DestroyScript*/
	_anchor 			/*Follow*/	
];
_singleCloud setDropInterval 1000;

_singleCloud spawn {
	sleep 1;
	deleteVehicle _this;
};


// Sparks
_sparks = "#particlesource" createVehicleLocal getPosATL _anchor;
_sparks setParticleCircle [10, [0, 0, 10]];
_sparks setParticleRandom [3, [0.25, 0.25, 0], [100, 100, 100], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
_sparks setParticleParams [["\A3\data_f\cl_exp", 1, 0, 1], "", "Billboard", 1, 7, [0, 0, 0], [5, 5, 30], 0.3, 200, 5, 3, [1.5, 1, 0.5], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _anchor];
_sparks setDropInterval 0.04;

_sparks spawn {
	sleep 1;
	deleteVehicle _this;
};

// Small clouds that rise into the sky towards the end
_smallClouds = "#particlesource" createVehicleLocal getPosATL _anchor;
_smallClouds setParticleCircle [30,[0.2, 0.5, 0.9]];
_smallClouds setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 0, [0, 0, 0, 0], 0, 0];
_smallClouds setParticleParams [
	["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 
	1, 					/*TimmerPer*/
	5, 					/*Lifetime*/
	[0, 0, 0], 			/*Position*/
	[0, 0, 15], 		/*MoveVelocity*/
	10, 				/*RotationVel*/
	17, 				/*Weight*/
	13, 				/*Volume*/
	0.7, 				/*Rubbing*/
	[15, 25, 31], 		/*Scale*/
	[[1, 1, 1, 0], [1, 1, 1, 0.2], [1, 1, 1, 1], [0.5, 0.5, 0.5, 0.5], [0, 0, 0, 0]], /*Color*/
	[0.08], 			/*AnimSpeed*/
	0.1, 				/*randDirPeriod*/
	3, 					/*randDirIntesity*/
	"", 				/*onTimerScript*/
	"", 				/*DestroyScript*/
	_anchor 			/*Follow*/
];

_smallClouds setDropInterval 0.1;

_smallClouds spawn {
	sleep 3;
	deleteVehicle _this;
};

// Light that fades overtime
_light = "#lightpoint" createVehicle getPosATL _anchor;
_light lightAttachObject [_anchor, [0,0,3]];
_light setLightAttenuation [0, 0, 0, 0, 40, 600];
_light setLightIntensity 500;
_light setLightBrightness 10;
_light setLightDayLight true;	
_light setLightUseFlare true;
_light setLightFlareSize 100;
_light setLightFlareMaxDistance 2000;	
_light setLightAmbient [1,0.2,0.1];
_light setLightColor [1,0.2,0.1];

_light spawn {
	sleep 1;
	_u = 10;
	while { _u > 0 } do 
	{
		_this setLightBrightness _u;
		_u = _u - 0.2;
		sleep 0.1;
	};
	sleep 0.5;
	deleteVehicle _this;
};
