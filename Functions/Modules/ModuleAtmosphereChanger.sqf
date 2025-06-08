
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
		private _rain = (_logic getVariable "Rain") == 1;
		private _fog = (_logic getVariable "Fog") == 1;
		private _fogParams = _logic getVariable "FogParams";
		if (_fogParams isEqualType "") then { _fogParams = call compile _fogParams };
		private _enableDust = (_logic getVariable "EnableDust") == 1;
		
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
		
		
		private _radius = _logic getVariable "Radius";
		private _transitionTime = _logic getVariable "TransitionTime";
		private _startCondition = _logic getVariable ["StartCondition", "true"];
		private _stopCondition = _logic getVariable ["StopCondition", "false"];
		private _loopConditions = ( _logic getVariable ["LoopConditions", 0] ) == 1;
		
		
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
			/* Wait until a user-defined condition is true */
			WaitUntil { sleep 0.5; _logic call _startCondition && [_moduleForDistanceChecks, true] call _fnc_distanceCheck }; 
			
			// Defining variables to make them visible outside of the switch-case block
			private _handle = 0 spawn {};
			private _ppCol = -1;
			private _ppCCBase = [0.199, 0.587, 0.114, 0.0];
			private _ppCCOut = [1, 1, 0, [0.0, 0.0, 0.0, 0.0], [1.0, 1.0, 1.0, 1.0], _ppCCBase];
			private _emitter = objNull;
			
			private _oldOvercast = 0;
			private _oldGusts = 0;
			private _oldRain = 0;
			private _oldLightnings = 0;

			// save old fog params 
			private _oldFogParams = fogParams; // [_fogValue, _fogDecay, _fogBase]
			private _oldOvercast = overcast;
			
			// ==================================== //
			// 					Rain				//
			// ==================================== //
			
			if (_rain) then 
			{
				// save old params 
				_oldOvercast = overcast;
				_oldGusts = gusts;
				_oldRain = rain;
				_oldLightnings = lightnings;
				
				_transitionTime setGusts 1;
				_transitionTime setOvercast 1;
				_transitionTime setLightnings 1;
				_transitionTime setRain 1;
				forceWeatherChange;
			};	
			
			
			// ==================================== //
			// 				fog spawner				//
			// ==================================== //
			
			if (_fog) then 
			{
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
				[_handle, _oldFogParams, _oldOvercast, _transitionTime] spawn {
					params ["_handle", "_params", "_oldOvercast", "_transitionTime"];
					waitUntil { sleep 0.5; scriptDone _handle };
					_transitionTime setOvercast _oldOvercast;
					sleep _transitionTime;
					_transitionTime setFog _params;
				};
			};
			
			// ==================================== //
			// 				dust spawner			//
			// ==================================== //
			
			if (_enableDust) then 
			{
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
			// 				color corrections			//
			// ======================================== //
			
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
			};
				
			/* Wait until a user-defined condition is true */
			WaitUntil { sleep 1; _logic call _stopCondition || [_moduleForDistanceChecks, false] call _fnc_distanceCheck };
			
			if (_rain) then {
				_transitionTime setGusts _oldGusts;
				_transitionTime setOvercast _oldOvercast;
				_transitionTime setLightnings _oldLightnings;
				_transitionTime setRain _oldRain;
				[_transitionTime] spawn {
					params ["_transitionTime"];
					sleep _transitionTime;
					forceWeatherChange;
				};
			};
			
			if !(scriptDone _handle) then {
				[_handle, _transitionTime] spawn {
					params ["_handle","_transitionTime"];
					sleep _transitionTime;
					if !(scriptDone _handle) then {
						terminate _handle;
					};
				}
			};
			
			if !(isNull _emitter) then {
				deleteVehicle _emitter;
			};
			
			// disable color effect
			if !(_ppCol isEqualTo -1) then {
				_ppCol ppEffectAdjust _ppCCOut;
				_ppCol ppEffectCommit _transitionTime*2;
				[_ppCol, _transitionTime] spawn {
					params ["_ppCol", "_transitionTime"];
					sleep _transitionTime*2;
					ppEffectDestroy _ppCol;
				};
			};
			
			if ( !_loopConditions && call _stopCondition ) exitWith {
				//diag_log format ["The loop will not be restarted"];
			};

		};

		if !(isNull _logic) then {
			deleteVehicle _logic;
		};
		
	};
	
	default {};
};


