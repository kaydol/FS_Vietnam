
#include "..\..\definitions.h"

#define DEF_CC_PRESET_DISABLED 0
#define DEF_CC_PRESET_CUSTOM 1
#define DEF_CC_PRESET_DARKEN 2
#define DEF_CC_PRESET_YELLOW 3

private _mode = param [0,"",[""]];
private _input = param [1,[],[[]]];

private _logic = _input param [0,objNull,[objNull]]; // Module logic
private _isActivated = _input param [1,true,[true]]; // True when the module was activated, false when it's deactivated
private _isCuratorPlaced = _input param [2,false,[true]]; // True if the module was placed by Zeus

if !(_isActivated) exitWith {};

[_mode, _input] call FS_fnc_VisualizeModuleRadius3DEN;

switch _mode do {
	// Default object init
	case "init": 
	{
		private _rain = (_logic getVariable "Rain") isEqualTo 1;
		private _fog = (_logic getVariable "Fog") isEqualTo 1;
		private _fogParams = _logic getVariable "FogParams";
		if (_fogParams isEqualType "") then { _fogParams = call compile _fogParams };
		private _enableDust = (_logic getVariable "EnableDust") isEqualTo 1;
		private _enableSnow = (_logic getVariable "EnableSnow") isEqualTo 1;
		private _enableSteam = (_logic getVariable "EnableSteam") isEqualTo 1;
		private _radius = _logic getVariable "Radius";
		private _transitionTime = _logic getVariable "TransitionTime";
		private _startCondition = _logic getVariable ["StartCondition", "true"];
		private _stopCondition = _logic getVariable ["StopCondition", "false"];
		private _loopConditions = ( _logic getVariable ["LoopConditions", 0] ) isEqualTo 1;
		private _debug = (_logic getVariable "debug") isEqualTo true;
		
		
		private _CCPreset = _logic getVariable "CCPreset";
		private _ppCCBase = [0.199, 0.587, 0.114, 0.0];
		private _ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.0], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
		private _CCTint = [0,0,0,0];
		private _ppCCIn = [1,1.6,0, _CCTint, [1.2, 1, 0.2, 0.4], _ppCCBase];
		
		switch ( _CCPreset ) do {
			case DEF_CC_PRESET_DISABLED: {};
			case DEF_CC_PRESET_DARKEN: {
				_CCTint = [0,0,0,0.5];
				_ppCCIn = [1,1.6,0, _CCTint, [1.2, 1, 0.2, 0.4], _ppCCBase];
			};
			case DEF_CC_PRESET_YELLOW: {
				_CCTint = [1.1, 0.9, 0.8, 0.05];
				_ppCCIn = [1,1.6,0, _CCTint, [1.2, 1, 0.2, 0.4], _ppCCBase];
			};
			default {
				_CCTint = _logic getVariable "CCCustomTint";
				if (_CCTint isEqualType "") then { _CCTint = call compile _CCTint };
				_ppCCIn = [1,1.6,0, _CCTint, [1.2, 1, 0.2, 0.4], _ppCCBase];
			};
		};
		
		
		// If manager module is synced, use condition functions provided by it instead
		private _moduleForDistanceChecks = _logic;
		
		if (_startCondition isEqualType false) then { _startCondition = {_startCondition} };
		if (_startCondition isEqualType "") then { _startCondition = compile _startCondition };
		if (_stopCondition isEqualType false) then { _stopCondition = {_stopCondition} };
		if (_stopCondition isEqualType "") then { _stopCondition = compile _stopCondition };
		
		private _fnc_distanceCheck = {
			params ["_logic", "_inside"];
			if (isNull _logic || isNull DEF_CURRENT_PLAYER) exitWith { !_inside }; // always outside
			_radius = _logic getVariable "Radius";
			if (_radius <= 0) exitWith { _inside }; // if _radius == 0 then always inside
			call (
				[
					{DEF_CURRENT_PLAYER distance _logic > _radius}, // if _inside == false 
					{DEF_CURRENT_PLAYER distance _logic <= _radius} // if _inside == true
				] select _inside
			)
		};
		
		while { true } do 
		{
			if (_debug) then {
				diag_log format ["(AtmosphereChanger %1) Waiting for condition to turn true", _logic];
			};
			
			/* Wait until a user-defined condition is true */
			WaitUntil { sleep 0.5; _logic call _startCondition && [_moduleForDistanceChecks, true] call _fnc_distanceCheck }; 
			
			if (_debug) then {
				diag_log format ["(AtmosphereChanger %1) Condition is true, proceeding...", _logic];
			};
			
			// ==================================== //
			// 					Rain				//
			// ==================================== //
			
			private _oldOvercast = 0;
			private _oldGusts = 0;
			private _oldRain = 0;
			private _oldLightnings = 0;

			// save old fog params 
			private _oldFogParams = fogParams; // [_fogValue, _fogDecay, _fogBase]
			private _oldOvercast = overcast;
			
			if (_rain && !_enableSnow) then 
			{
				if (_debug) then {
					diag_log format ["(AtmosphereChanger %1) Rain starts...", _logic];
				};
			
				// save old params 
				_oldOvercast = overcast;
				_oldGusts = gusts;
				_oldRain = rain;
				_oldLightnings = lightnings;
				
				// start the rain
				_transitionTime setGusts 1;
				_transitionTime setOvercast 1;
				_transitionTime setLightnings 1;
				_transitionTime setRain 1;
				forceWeatherChange;
				skipTime 1;
				skipTime -1;
			};	
			
			
			// ==================================== //
			// 				fog spawner				//
			// ==================================== //
			
			private _handle = 0 spawn {};
			
			if (_fog) then 
			{
				if (_debug) then {
					diag_log format ["(AtmosphereChanger %1) Fog starts...", _logic];
				};
			
				_handle = [_transitionTime, _fogParams, _rain] spawn {
					params ["_transitionTime", "_fogParams", "_rain"];
					private _fogValue = _fogParams # 0;
					private _fogDecay = _fogParams # 1;
					
					while {true} do {
						private _overcast = if (_rain) then {1} else {0.5};
						_transitionTime setOvercast _overcast;
						sleep _transitionTime;
						// the fog base will be constantly adjusting to player's height above sea 
						_transitionTime setFog [_fogValue, _fogDecay, getPosASL DEF_CURRENT_PLAYER select 2];
						sleep _transitionTime;
					};
				};
				
				// restores fog to the old params once the fog spawner is terminated
				[_handle, _oldFogParams, _oldOvercast, _transitionTime, _logic, _debug] spawn {
					params ["_handle", "_params", "_oldOvercast", "_transitionTime", "_logic", "_debug"];
					waitUntil { sleep 0.5; scriptDone _handle };
					_transitionTime setOvercast _oldOvercast;
					sleep _transitionTime;
					_transitionTime setFog _params;
					
					if (_debug) then {
						diag_log format ["(AtmosphereChanger %1) Fog ended", _logic];
					};
				};
			};
			
			// ==================================== //
			// 				dust spawner			//
			// ==================================== //
			
			private _emitter = objNull;
			
			if (_enableDust) then 
			{
				if (_debug) then {
					diag_log format ["(AtmosphereChanger %1) Dust starts...", _logic];
				};
			
				_emitter = "#particlesource" createVehicleLocal getpos DEF_CURRENT_PLAYER;
				
				//particle_emitter_0 setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d",16,12,13,0],"","Billboard",1,10,[0,0,0],[0,0,0.2],0,0.0525,0.04,0.05,[1.6,3.5],[[0.5,0.4,0.3,0],[0.499251,0.414643,0.336079,0],[0.5,0.4,0.3,0.06],[0.5,0.4,0.3,0.05],[0.5,0.4,0.3,0.015],[0.6,0.5,0.4,0]],[1000],0.1,0.05,"","","",0,false,0,[[0,0,0,0],[0,0,0,0]]];
				
				_emitter setParticleParams [
					["\A3\data_f\ParticleEffects\Universal\Universal.p3d",16,12,13,0], // p3dPath, Ntieth, Index, FrameCount, Loop
					"", // animationName (obsolete parameter that was meant to play .rtm anims, should be empty)
					"Billboard", // particleType ("Billboard" or "SpaceObject")
					1, // timerPeriod
					10, // lifeTime
					[0,0,0], // position
					[0,0,0.2], // moveVelocity
					0, // rotationVelocity (rotations per second)
					0.0525, // weight (weight of the particle, kg)
					0.04, // volume (volume of the particle in m3)
					0.05, // rubbing (determines how much particles blown by winds)
					[1.6,3.5], // size (array of particle size along its lifetime)
					[[0.5,0.4,0.3,0],[0.5,0.4,0.3,0.06],[0.5,0.4,0.3,0.05],[0.5,0.4,0.3,0.015],[0.6,0.5,0.4,0]], // color (array of [RGBA] arrays)
					[1000], // animationSpeed
					0.1, // randomDirectionPeriod
					0.05, // randomDirectionIntensity
					"", // onTimerScript
					"", // beforeDestroyScript
					DEF_CURRENT_PLAYER, // this (if this parameter isn't objNull, the particle source will be attached to the object, the generation of particles stops when beyond Object View Distance)
					0, // angle (optional)
					false, // onSurface (optional)
					0, // bounceOnSurface (optional, default -1. Coef of bounce in collision with ground, 0..1 for collisions, -1 to disable collision. Should be used soberly as it has a significant impact on performance)
					[[0,0,0,0],[0,0,0,0]] // emissiveColor (optional, array of [RGBA] arrays, needs to match 'color' values and be 100x times the RGB color values. Alpha is not used)
				];
				_emitter setParticleRandom [1,[10,10,0.2],[0.005,0.005,0.15],10,0.2,[0,0,0,0],0,0,0,0];
				_emitter setParticleCircle [0,[0,0,0]];
				_emitter setParticleFire [0,0,0];
				_emitter setDropInterval 0.1;
			};
			
			// ======================================== //
			// 					 snow					//
			// ======================================== //
			
			private _snowSources = [];
			
			if (_enableSnow) then 
			{
				if (_debug) then {
					diag_log format ["(AtmosphereChanger %1) Snow starts...", _logic];
				};
			
				private _attachTo = DEF_CURRENT_PLAYER;
				private _side = 50;
				private _height = 20;
				
				0 setRain 0; // NOTE: Since Arma 3 this command is MP synchronised, if executed on server, the changes will propagate globally. If executed on client effect is temporary as it will soon change to the server setting.
				forceWeatherChange;
				999999 setRain 0;
				skipTime 1; 
				skipTime -1;
	
				/* Sole snowflakes */
				
				private _source1 = "#particlesource" createVehicleLocal getpos _attachTo;
				_source1 setDropInterval 0.005; 
				_source1 setParticleCircle [0.0, [0, 0, 0]];

				_source1 setParticleRandom [
					/*LifeTime*/		0,
					/*Position*/		[_side/2,_side/2,_height],
					/*MoveVelocity*/	[0,0,0],
					/*rotationVel*/		0,
					/*Scale*/			0.01,
					/*Color*/			[0,0,0,0.1],
					/*randDirPeriod*/	0,
					/*randDirIntesity*/	0,
					/*Angle*/			0
				];

				_source1 setParticleParams [
					/*Sprite*/				["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 13,1], "",// [File,Ntieth,Index,Count,Loop(Bool)], "?"
					/*Type*/				"Billboard", 
					/*TimmerPer*/			1,
					/*Lifetime*/			6, 
					/*Position*/			[0,0,_height],  
					/*MoveVelocity*/		[0,0,0], 
					/*Simulation*/			1,0.0000001,0.000,1.7, //rotationVel,weight,volume,rubbing
					/*Scale*/				[0.07],  
					/*Color*/				[[1,1,1,1]],
					/*AnimSpeed*/			[0,1], 
					/*randDirPeriod*/		0.2, 
					/*randDirIntesity*/		1.2,
					/*onTimerScript*/		"",
					/*DestroyScript*/		"",
					/*Follow*/				_attachTo,
					/*Angle*/				0,
					/*onSurface*/ 			False,
					/*bounceOnSurface*/		-1,
					/*emissiveColor*/		[[1,1,1,1]]
				];
				
				_snowSources pushBack _source1;
			};
			
			// ======================================== //
			// 					 steam					//
			// ======================================== //
			
			if (_enableSteam) then 
			{
				if (_debug) then {
					diag_log format ["(AtmosphereChanger %1) Steam from mouth starts...", _logic];
				};
			
				private _code = {
					_this spawn 
					{
						private ["_source","_fog"];
						params ["_unit", ["_breathe", 1], ["_time", 10]];
						
						if (isNull _unit || !alive _unit) exitWith {};
						
						if (!(_breathe in [1,2,4,6,7,10,14])) exitWith {};
						/*
							1 : Breath
							2 : Breath Injured
							3 : Breath Scuba
							4 : Injured
							5 : Pulsation
							6 : Hit Scream
							7 : Burning
							8 : Drowning
							9 : Drown
							10 : Gasping
							11 : Stabilizing
							12 : Healing
							13 : Healing With Medikit
							14 : Recovered 
						*/
						_source = "logic" createVehicleLocal (getpos _unit);
						_source attachto [_unit, [0,0.15,0], "neck"];
						
						_fog = "#particlesource" createVehicleLocal getpos _source;
						
						private ["_v1", "_v2", "_cosA", "_cosB", "_sinA", "_sinB", "_cosC", "_velocity", "_volume"];
						
						_fog setParticleRandom [2, [0, 0, 0], [0.25, 0.25, 0.25], 0, 0.5, [0, 0, 0, 0.1], 0, 0, 10];
						_fog setDropInterval 0.001;
							
							
						_fog setParticleParams [
							/*Sprite*/ 			["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 13,0], "",
							/*Type*/ 			"Billboard",
							/*TimmerPer*/ 		0.5,
							/*Lifetime*/ 		0.5,
							/*Position*/ 		[0,0,0],
							/*MoveVelocity*/ 	[1.2, 1.2,-0.2],
							/*Simulation*/ 		1, 1.275, 1, 0.2, //rotationVel,weight,volume,rubbing
							/*Scale*/ 			[0, 0.2,0],
							/*Color*/ 			[[1,1,1, 0.001], [1,1,1, 0.02], [1,1,1, 0]],
							/*AnimSpeed*/ 		[1000],
							/*randDirPeriod*/ 	1,
							/*randDirIntesity*/ 0.04,
							/*onTimerScript*/ 	"",
							/*DestroyScript*/ 	"", 
							/*Follow*/ 			_source
						];
							
						for [{_i = 0}, {_i < _time}, {_i = _i + 1}] do 
						{
							_v1 = vectorDir _unit;
							_v2 = eyeDirection _unit;
							_cosA = [0,1,0] vectorCos _v1; 	// cos between north and body direction
							_cosB = _v1 vectorCos _v2;		// cos between head- and body- directions
							_sinA = sqrt(abs(1 - _cosA^2)); // abs is needed because sometimes cos is slightly above 1... 
							_sinB = sqrt(abs(1 - _cosB^2));
							
							/* initial direction */
							_velocity = [0, 1.2, -0.2];
							
							
							_volume = (_v1 select 0)*(_v2 select 1)-(_v1 select 1)*(_v2 select 0);
							// Which is equal to "(_v1 vectorCrossProduct _v2) select 2", but FASTER
							// We can find out which vector is on the right by calculating the volume of cross product
							// Volume will be negative if we turn head to the left and positive if turn to the right
							
							/* direction when unit is running (to make steam round the neck && to prevent steam from the neck) */ 
							if (speed _unit > 5) then 
							{
								if (_volume <= 0) then {
									_velocity = [2.2, 1.2, -0.2]; 
								} else {
									_velocity = [-2.2, 1.2, -0.2]; 
								};
							};
							
							// adjusting z coordinate of _velocity
							_velocity params ["_x", "_y", "_z"];
							_v2 params ["_xx", "_yy", "_zz"];
							_velocity = [_x, _y, _zz];
							
							/* 1. Turn due to body direction */
							
							if (getDir _unit > 180 && getDir _unit <= 360) then {
								_velocity = [
												(_velocity select 0) * _cosA - (_velocity select 1) * _sinA, 
												(_velocity select 0) * _sinA + (_velocity select 1) * _cosA, 
												-0.2
											];
							} else {
								_velocity = [
												(_velocity select 0) * _cosA + (_velocity select 1) * _sinA, 
												-(_velocity select 0) * _sinA + (_velocity select 1) * _cosA, 
												-0.2
											];
							};
							
							/* 2. Turn due to head direction */
							
							if (_volume <= 0) then { _sinB = -1 * _sinB; };
							
							_velocity = [
											(_velocity select 0) * _cosB - (_velocity select 1) * _sinB, 
											(_velocity select 0) * _sinB + (_velocity select 1) * _cosB, 
											-0.2
										];
							
							_fog setParticleParams [
								/*Sprite*/ 			["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 13,0], "",
								/*Type*/ 			"Billboard",
								/*TimmerPer*/ 		0.5,
								/*Lifetime*/ 		0.5,
								/*Position*/ 		[0,0,0],
								/*MoveVelocity*/ 	_velocity,
								/*Simulation*/ 		1, 1.275, 1, 0.2, //rotationVel,weight,volume,rubbing
								/*Scale*/ 			[0, 0.2,0],
								/*Color*/ 			[[1,1,1, 0.001], [1,1,1, 0.01], [1,1,1, 0]],
								/*AnimSpeed*/ 		[1000],
								/*randDirPeriod*/ 	1,
								/*randDirIntesity*/ 0.04,
								/*onTimerScript*/ 	"",
								/*DestroyScript*/ 	"", 
								/*Follow*/ 			_source
							];
							
						
							sleep 0.05;
						};
						
						_fog setDropInterval 1;
						
						deleteVehicle _fog;
						deleteVehicle _source;
					};
				};
				
				{
					private _id = _x addEventHandler ["SoundPlayed", _code];
					_x setVariable ["FS_AtmosphereChanger_SoundPlayedEH", _id];
					if (_debug) then {
						diag_log format ["(AtmosphereChanger %1) Added Steam from mouth to %2", _logic, _x];
					};
				}
				forEach (playableUnits + switchableUnits);
			};
			
			
			
			// ======================================== //
			// 				color corrections			//
			// ======================================== //
			
			private _ppCol = -1;
			private _ppCCBase = [0.199, 0.587, 0.114, 0.0];
			private _ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.0], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
			
			if (_CCPreset != DEF_CC_PRESET_DISABLED) then {	
				private _name = "colorCorrections";
				private _priority = 1550;
				while { 
					_ppCol = ppEffectCreate [_name, _priority]; 
					_ppCol < 0 
				} do { 
					_priority = _priority + 1; 
				};
				_ppCol ppEffectAdjust _ppCCIn;
				_ppCol ppEffectCommit _transitionTime;
				_ppCol ppEffectEnable true;
				
				if (_debug) then {
					diag_log format ["(AtmosphereChanger %1) Color correction with priority %2 starts ", _logic, _priority];
				};
			};
			
			/* Wait until a user-defined condition is true */
			WaitUntil { sleep 1; _logic call _stopCondition || [_moduleForDistanceChecks, false] call _fnc_distanceCheck };
			
			if (_rain || _enableSnow) then {
				if (_debug) then {
					diag_log format ["(AtmosphereChanger %1) Restoring rain or snow to previous values", _logic];
				};
				_transitionTime setGusts _oldGusts;
				_transitionTime setOvercast _oldOvercast;
				_transitionTime setLightnings _oldLightnings;
				_transitionTime setRain _oldRain;
				[_transitionTime] spawn {
					params ["_transitionTime"];
					sleep _transitionTime;
					forceWeatherChange;
					skipTime 1; 
					skipTime -1;
				};
			};
			
			if !(scriptDone _handle) then {
				if (_debug) then {
					diag_log format ["(AtmosphereChanger %1) Terminating fog script", _logic];
				};
				[_handle, _transitionTime] spawn {
					params ["_handle","_transitionTime"];
					sleep _transitionTime;
					if !(scriptDone _handle) then {
						terminate _handle;
					};
				}
			};
			
			if !(isNull _emitter) then {
				if (_debug) then {
					diag_log format ["(AtmosphereChanger %1) Deleting the dust emitter", _logic];
				};
				deleteVehicle _emitter;
			};
			
			if (_snowSources isNotEqualTo []) then {
				if (_debug) then {
					diag_log format ["(AtmosphereChanger %1) Deleting snow sources: %2", _logic, _snowSources];
				};
				{ deleteVehicle _x } forEach _snowSources;
			};
			
			if (_enableSteam) then {
				
				{
					private _id = _x getVariable "FS_AtmosphereChanger_SoundPlayedEH";
					if (!isNil{_id}) then {
						_x removeEventHandler ["SoundPlayed", _id];
						if (_debug) then {
							diag_log format ["(AtmosphereChanger %1) Removed Steam from mouth script from %2", _logic, _x];
						};
					};
				}
				forEach (playableUnits + switchableUnits);
			};
			
			// disable color effect
			if !(_ppCol isEqualTo -1) then {
				if (_debug) then {
					diag_log format ["(AtmosphereChanger %1) Deleting ppcolor effect", _logic];
				};
				_ppCol ppEffectAdjust _ppCCOut;
				_ppCol ppEffectCommit _transitionTime*2;
				[_ppCol, _transitionTime] spawn {
					params ["_ppCol", "_transitionTime"];
					sleep _transitionTime*2;
					ppEffectDestroy _ppCol;
				};
			};
			
			if ( !_loopConditions && _logic call _stopCondition ) exitWith {
				if (_debug) then {
					diag_log format ["(AtmosphereChanger %1) The loop will not be restarted", _logic];
				};
			};

		};

		if !(isNull _logic) then {
			if (_debug) then {
				diag_log format ["(AtmosphereChanger %1) Self deletion", _logic];
			};
			deleteVehicle _logic;
		};
		
	};
	
	default {};
};


