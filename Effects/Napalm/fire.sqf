// by ALIAS 
// Tutorial: https://www.youtube.com/watch?v=WKakf7yb2WM

/*
* Script MP and SP compatible.
** Script runs on client side only so the server is not loaded with unnecessary tasks. 
*** However mind the number of fires they can still cause frames drop. Test and see what it works for you.

_day_time					- boolean, true for day, false for night
								* to keep particles to the minimum i use 2 versions for fire, one for night and one for day, use whatever fits in your mission better
_life_time					- seconds, fire will be put off after the time you set for life time
_radius						- meters, you want to be covered by fire, note that at certain values the fire doesn't look good, so use it wisely
_damage_inflicted_surround	- 0..1, amount of damage you to be inflicted upon objects close to fire, use smaller values and test damage is in loop
_kill_vehicle_in_fire		- boolean, true if you want the vehicle blowing up when fire is gone, false if you want just to delete the vehicle
_human						- boolean, true if the object set on fire is a footmobile, false if is an object (buildings, wrecks, vehicles etc)
*/

if (!hasInterface) exitWith {};

// if (isDedicated) exitWith {};

// if (!isNil "_fireon") exitWith {}; _fireon = true;

// private [];

_obj = _this select 0;
_day_time = _this select 1;
_life_time = _this select 2;
_radius = _this select 3;
_damage_inflicted_surround = _this select 4;

//  duration - fire lifetime

[_life_time, _obj] spawn {
	_lft = _this select 0;
	_obje = _this select 1;
	sleep _lft;
	_obje setDammage 1;
	sleep 30+ random 60;
	deletevehicle _obje;
};

_obj spawn {
	while {!isNull _this} do {
		_fireSound = ["furnal_1", "furnal_2"] call BIS_fnc_SelectRandom;
		_this say3d [_fireSound,2000];
		sleep 10;	
	};
};

if (_damage_inflicted_surround > 0 && isServer) then 
{
	[_obj,_radius * 1.5,_damage_inflicted_surround] spawn 
	{
		_obje = _this select 0;
		_radiux = _this select 1;
		_dam = _this select 2;
		while {!isNull _obje} do { 
			_objects = _obje nearEntities ["MAN", _radiux];
			[_objects, _dam] spawn 
			{
				params ["_objects", "_dam"];
				{
					[[_x, _dam], {
						params ["_sol", "_dam"];
						_sol setDamage ( getDammage _sol + _dam );  
					}] remoteExec ["call", _x]
				}
				forEach _objects;
			};
			sleep 2;
		};
	};
};


if (_day_time) then 
{
	// --------------- fire day time ---------------

	// foc
	_flacari = "#particlesource" createVehicleLocal (getPosATL _obj);
	_flacari setParticleCircle [_radius-_radius/9, [0, 0, 0]];
	_flacari setParticleRandom [1, [0.25, 0.25, 0], [0.175, 0.175, 0.1], 5, 0.25, [0, 0, 0, 0.5], 0.5, 0];
	_flacari setParticleParams [["\A3\data_f\cl_exp", 1, 0, 1], "", "Billboard", 1, 2.5, [0, 0, 0], [0, 0, 2], 50, 10, 7.9, 0.1, [_radius/2+2,_radius/2+1,_radius/2+0.5], [[1, 1, 1, 1], [0.3, 0.3, 0.3, 0.5], [0, 0, 0, 0]], [0.08], 1, 0, "", "", _obj];
	_flacari setDropInterval 0.05;

	// fum
	_fum = "#particlesource" createVehicleLocal (getPosATL _obj);
	_fum setParticleCircle [_radius+1, [0, 0, 0]];
	_fum setParticleRandom [30, [0.25, 0.25, 0], [0.175, 0.175, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
	_fum setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 60, [0, 0, 0], [0, 0, 0], 50, 10, 7.9, 0.1, [_radius/2+1.5,_radius/2+2.5,_radius/2+4,_radius/2+7,_radius/2+9,_radius/2+15], [[0, 0, 0, 1], [0.1, 0.1, 0.1, 1], [0.5, 0.35, 0.1, 0.8], [0, 0, 0, 0.9], [0.01, 0.01, 0.01, 0.5], [0, 0, 0, 0.05]], [0.08], 1, 0, "", "", _obj];
	_fum setDropInterval 0.1;
} 
else {
	// --------------- fire night time ---------------
	// fum
	_fum = "#particlesource" createVehicleLocal (getPosATL _obj);
	_fum setParticleCircle [_radius, [0, 0, 0]];
	_fum setParticleRandom [30, [0.25, 0.25, 0], [0.175, 0.175, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
	_fum setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 60, [0, 0, 0], [0, 0, 0], 50, 10, 7.9, 0.1, [_radius/2+1.5,_radius/2+2.5,_radius/2+4,_radius/2+7,_radius/2+9,_radius/2+15], [[0.7, 0.5, 0.5, 1], [0.5, 0, 0, 1], [0.5, 0.1, 0.1, 0.8], [0, 0, 0, 0.9], [0.01, 0.01, 0.01, 0.5], [0, 0, 0, 0.05]], [0.08], 1, 0, "", "", _obj];
	_fum setDropInterval 0.1;

	_lite= [_obj,_radius] spawn {
		// lumina
		_objt = _this select 0;
		_radiust = _this select 1;
		_luminafoc = "#lightpoint" createVehicleLocal ([1,1,1]); 
		_luminafoc lightAttachObject [_objt, [0,0,-1]];
		_luminafoc setLightAmbient [1,0.1,0];
		_luminafoc setLightColor [1,0,0];
		_luminafoc setLightUseFlare true;
		_luminafoc setLightDayLight true;
		
		while {!isNull _objt} do {
			_luminafoc setLightBrightness 8+ random 1;
			_luminafoc setLightAttenuation [/*start*/ /*(_radiust/2)+random 3*/random _radiust/2, /*constant*/70+random 10, /*linear*/ 10+random 20, /*quadratic*/ 0, /*hardlimitstart*/1+random 0.5,/* hardlimitend*/300]; 
			sleep 0.1;
		};	
		deletevehicle _luminafoc;
	};
	
};