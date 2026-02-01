
#include "..\..\definitions.h"

/*
	This script is only called for one person (not called globally)
*/

#define DEF_HEALING_RADIUS 3.1
#define DEF_PARTICLE_RADIUS 1.5
#define DEF_INCLUDE_CREW true 
#define DEF_HEALING_RECEIVED_SOUND "FS_Healing_Tick"
#define DEF_HEALING_RATE 0.15

#define DEF_NUMBER_OF_PULSES 10
#define DEF_SLEEP_BETWEEN_PULSES 1

#define DEF_RSC_TITLE "FS_HealingGrenades_HUD"
#define DEF_HEALING_GRENADE_TEXTURES_WEIGHTED "FS_HealingGrenades_Textures_Weighted"

private _pos = ATLTOASL _this;


//----------------------------------------------//
// Flash players who were in the impact zone	//
//----------------------------------------------//

private _fnc_getAffectedUnits = {
	params ["_pos"];
	[_pos, DEF_HEALING_RADIUS, DEF_HEALING_RADIUS, 0, false, DEF_HEALING_RADIUS] nearEntities [["MAN"], false, true, DEF_INCLUDE_CREW]
};

private _fnc_getWeightedTexture = {
	params ["_player"];
	private _defaultPoolWeighted = [
		"\FS_Vietnam\Textures\healing_grenade_flash_image_gays.paa", 0, 
		"\FS_Vietnam\Textures\healing_grenade_flash_image_jesus.paa", 1,
		"\FS_Vietnam\Textures\healing_grenade_flash_image_biden_blast.paa", 0
	];
	
	/* Get player-specific weighted array of textures */
	private _poolWeighted = _player getVariable [DEF_HEALING_GRENADE_TEXTURES_WEIGHTED, _defaultPoolWeighted];
	private _selected = selectRandomWeighted _poolWeighted;
	private _selectedID = _poolWeighted findIf { _x isEqualTo _selected };
	
	/* Increase all the weights by the increment */
	if (count _poolWeighted > 2) then { // do nothing if there is only 1 texture in the pool
		_poolWeighted = _poolWeighted apply {
			if ( _x isEqualType 0 ) then {
				_x = _x + 1.0 / ((count _poolWeighted - 2) / 2);
				_w = [_x, 1.0] select (_x > 1.0);
				_x = _w;
			};
			_x
		};
	};

	/* Set the weight of the currently selected texture to be 0 */
	if (count _poolWeighted > 2) then { // do nothing if there is only 1 texture in the pool
		_poolWeighted set [_selectedID + 1, 0];
	};
	
	/* Update weights */
	_player setVariable [DEF_HEALING_GRENADE_TEXTURES_WEIGHTED, _poolWeighted, true];
	
	_selected
};

private _flashedPlayers = ([_pos] call _fnc_getAffectedUnits) select {isPlayer _x}; 
if (_flashedPlayers isNotEqualTo []) then 
{
	{ 
		private _texture = _x call _fnc_getWeightedTexture;
		
		[_texture, {
			params ["_texture"];
			disableSerialization;
			
			if (isNull( uiNamespace getVariable [DEF_RSC_TITLE, displayNull] )) then 
			{
				(DEF_RSC_TITLE call BIS_fnc_rscLayer) cutRsc [DEF_RSC_TITLE, "WHITE IN", 1];
			};
			
			private _ctrl = (uiNamespace getVariable DEF_RSC_TITLE) ctrlCreate ["RscPicture", -1];
			
			_ctrl ctrlSetText _texture;
			
			_ctrl ctrlSetPosition [0, 0, 1, 1];
			_ctrl ctrlSetTextColor [1,1,1, 0];
			_ctrl ctrlCommit 0;
			
			_ctrl ctrlSetPosition [0, 0, 1, 1];
			_ctrl ctrlSetTextColor [1,1,1, 1];
			_ctrl ctrlCommit 0.5;
			
			sleep 1;
			
			ctrlDelete _ctrl;
			
		}] remoteExec ["spawn", _x] 
	
	} forEach _flashedPlayers;
};


//--------------------------//
// Create particle emitter 	//
//--------------------------//

[[_pos], {
	params ["_pos"];
	
	private _emitter = "#particlesource" createVehicleLocal _pos;
	_emitter setPosASL _pos;
	
	_emitter setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d",16,7,48,1], // p3dPath, Ntieth, Index, FrameCount, Loop
	"", // animationName (obsolete parameter that was meant to play .rtm anims, should be empty)
	"Billboard", // particleType ("Billboard" or "SpaceObject")
	1, // timerPeriod
	1, // lifeTime
	[0,0,0], // position
	[0,0,0.1], // moveVelocity
	1, // rotationVelocity (rotations per second)
	1.2777, // weight (weight of the particle, kg)
	1, // volume (volume of the particle in m3)
	0.001, // rubbing (determines how much particles blown by winds)
	[0.1,0.5,0.5], // size (array of particle size along its lifetime)
	[[0.287731,0.6,0.270425,0.2],[0.310806,0.6,0.2935,0.368493],[0.2935,0.6,0.287731,0]], // color (array of [RGBA] arrays)
	[1.5,0.5], // animationSpeed
	1, // randomDirectionPeriod
	0.04, // randomDirectionIntensity
	"", // onTimerScript
	"", // beforeDestroyScript
	"", // this (if this parameter isn't objNull, the particle source will be attached to the object, the generation of particles stops when beyond Object View Distance)
	0, // angle (optional)
	false, // onSurface (optional)
	-1, // bounceOnSurface (optional, default -1. Coef of bounce in collision with ground, 0..1 for collisions, -1 to disable collision. Should be used soberly as it has a significant impact on performance)
	[[0,0,0,0]], // emissiveColor (optional, array of [RGBA] arrays, needs to match 'color' values and be 100x times the RGB color values. Alpha is not used)
	[0,1,0] // vectorDir (optional, sets the default direction for SpaceObject particles)
	];
	_emitter setParticleRandom [0,[0,0,0.5],[0,0,0.5],0,0,[0,0,0,0.35],0,0,0.1,-1];
	//_emitter setParticleRandom [0,[0,0,0.1],[0,0,0],20,0,[0,0,0,0.35],0,0,0.1,-1];
	_emitter setParticleCircle [DEF_PARTICLE_RADIUS,[0,0,0]];
	_emitter setParticleFire [0,0,0];
	_emitter setDropInterval 0.03;
	
	sleep (DEF_SLEEP_BETWEEN_PULSES * DEF_NUMBER_OF_PULSES);
	
	deleteVehicle _emitter; 
	
}] remoteExec ["spawn", 0];


//--------------------------------------------------------------//
// Apply fixed amount of healing pulses to the affected area	//
//--------------------------------------------------------------//

for [{_i = 0},{_i < DEF_NUMBER_OF_PULSES},{_i = _i + 1}] do 
{
	{
		private _unit = _x; 
		private _array = getAllHitPointsDamage _x;
		
		if (count _array > 2) then 
		{
			private _damageValues = _array select 2; 
			//hint format ["(%1), %2",time, _damageValues];
			
			// Heal
			{
				private _dmg = _x;
				if (_dmg > 0) then 
				{ 
					[_unit, [_forEachIndex, (_dmg - DEF_HEALING_RATE) max 0, false]] remoteExec ["setHitIndex", _unit];
					
					if (isPlayer _unit) then 
					{
						if (DEF_HEALING_RECEIVED_SOUND != "") then {
							DEF_HEALING_RECEIVED_SOUND remoteExec ["playSound", _unit];
						};
						
						// Only update time at which healing effect ends if the new value is greater, 
						// to better accomodate situations where unit is being healed by several grenades
						private _time = _unit getVariable [DEF_HEALING_GRENADE_EFFECT_ENDS_AT, 0];
						if (_time < time + 1) then {
							// Set variable to update icon in HUD 
							_unit setVariable [DEF_HEALING_GRENADE_EFFECT_ENDS_AT, time + 1, true];
						};
					};
				};
			} forEach _damageValues; 
			
			if (selectMax _damageValues == 0) then {
				[_unit, 0] remoteExec ["setDamage", _unit];
			};
			
			// Revive
			if (_unit getVariable ["vn_revive_incapacitated", false]) then {
				_unit setVariable ["vn_revive_incapacitated", false, true];
			};
		};
	} forEach ([_pos] call _fnc_getAffectedUnits);
	
	sleep DEF_SLEEP_BETWEEN_PULSES;
};
