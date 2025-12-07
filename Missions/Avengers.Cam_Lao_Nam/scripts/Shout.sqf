
/*
	While stealing this code, please give credits to kaydol.
	Originally written for Tiberian Genesis addon which can be found on Arma 3 Steam Workshop.
*/

#define DEF_DEBUG false 

params ["_unit"];

#define BLAST_FORCE 300
#define BLAST_RADIUS 7
#define OFFSET 0
#define LOS_NONE 0
#define LOS_DIRECT 1
#define LOS_INDIRECT 2

private _fnc_lineOfSightKind = {
	params ["_unit", "_object"];
	private _p1 = eyePos _unit;
	private _p2 = getPosASL _object;
	if (_object isKindOf "Man") then {
		_p2 = AGLToASL ( _object modelToWorldVisual (_object selectionPosition "pelvis") ); 
	};
	
	private _terrainIntersect = terrainIntersectASL [_p1, _p2];
	if (_terrainIntersect) exitWith { LOS_NONE };
	
	private _losObjects = lineIntersectsWith [_p1, _p2, _unit, _object, false];
	if ({_x isKindOf "House"} count _losObjects > 0) exitWith { LOS_NONE };
	
	if (count _losObjects == 0) exitWith { LOS_DIRECT };
	LOS_INDIRECT
};

//-- Cast a ray with a length of OFFSET and if it intersects with something then use the 
//-- intersection pos as center for the explosion otherwise use the end of the ray as the explosion center
private _centerASL = eyePos _unit vectorAdd (_unit weaponDirection currentWeapon _unit vectorMultiply OFFSET);
private _intersection = lineIntersectsSurfaces [eyePos _unit, _centerASL, _unit];
if (count _intersection > 0) then {
	(_intersection # 0) params ["_intersectPosASL", "_surfaceNormal", "_intersectObject", "_parentObject"];
	_centerASL = _intersectPosASL;
};

private _affectedUnits = ((ASLToAGL _centerASL) nearEntities BLAST_RADIUS) select { (_x == _unit || side _x != side _x) && [_unit, _x] call _fnc_lineOfSightKind != LOS_NONE };
_affectedUnitsWithForceDir = _affectedUnits apply { [_x, (eyePos _unit vectorFromTo getPosASL _x) vectorMultiply ((_unit distance _x) * BLAST_FORCE)] };

if (DEF_DEBUG) then {
	TG_RepulsorRound_EndPos = ASLToAGL _centerASL;
	TG_RepulsorRound_MuzzlePos = ASLToAGL eyePos _unit;

	if !( isNil { TG_RepulsorRound_Draw3D_Circle } ) then {
		if !( TG_RepulsorRound_Draw3D_Circle isEqualTo "" ) then {
			[TG_RepulsorRound_Draw3D_Circle, "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
		};
		TG_RepulsorRound_Draw3D_Circle = nil;
	};

	private _code = {
		private _circles = [];
		{
			private _corners = [];
			private _cornersCount = 20;
			private _turnAngle = 360 / _cornersCount;
			private _i = 0;
			for [{_i = 0},{_i < _cornersCount},{_i = _i + 1}] do {
				private _pos = _x getPos [BLAST_RADIUS, _i * _turnAngle];
				_pos set [2, _x # 2];
				_corners pushBack _pos;
			};
			_circles pushBack _corners;
		}
		forEach [TG_RepulsorRound_EndPos];
		
		{
			private _size = count _x;
			for [{_i = 0},{_i < _size},{_i = _i + 1}] do {
				drawLine3D [_x # _i, _x # (( _i + 1 ) % _size ), [1,0,0,1]];
			};
		} 
		forEach _circles;		
	};
	TG_RepulsorRound_Draw3D_Circle = ["TG_RepulsorRound_Draw3D_Circle", "onEachFrame", _code] call BIS_fnc_addStackedEventHandler;

	["TG_RepulsorRound_Draw3D", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
	["TG_RepulsorRound_Draw3D", "onEachFrame", {
		drawLine3D [TG_RepulsorRound_MuzzlePos, TG_RepulsorRound_EndPos, [1,0,0,1]];
	}] call BIS_fnc_addStackedEventHandler;
};

//systemChat str _affectedUnitsWithForceDir;

//=================//
//	Visual effect  //
//=================//

[[_unit, _centerASL], 
{
	if (!hasInterface) exitWith {};
	
	params ["_unit", "_centerASL"];
	private _emitter = "#particlesource" createVehicleLocal getPos _unit;
	
	_emitter setPosASL _centerASL;
	_emitter attachTo [_unit, [0,0,0]];
	
	_emitter setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d",16,12,13,0], // p3dPath, Ntieth, Index, FrameCount, Loop
	"", // animationName (obsolete parameter that was meant to play .rtm anims, should be empty)
	"Billboard", // particleType ("Billboard" or "SpaceObject")
	1, // timerPeriod
	1, // lifeTime
	[0,0,0], // position
	[0,0,1], // moveVelocity
	0, // rotationVelocity (rotations per second)
	0.053, // weight (weight of the particle, kg)
	0.04, // volume (volume of the particle in m3)
	0.05, // rubbing (determines how much particles blown by winds)
	[6,11], // size (array of particle size along its lifetime)
	[[0.4,0.3,0.2,0.1],[0.4,0.3,0.2,0.05],[0.4,0.3,0.2,0.04],[0.4,0.3,0.2,0.02],[0.4,0.3,0.2,0.01],[0.4,0.3,0.2,0.001]], // color (array of [RGBA] arrays)
	[1000], // animationSpeed
	0.1, // randomDirectionPeriod
	0.05, // randomDirectionIntensity
	"", // onTimerScript
	"", // beforeDestroyScript
	"", // this (if this parameter isn't objNull, the particle source will be attached to the object, the generation of particles stops when beyond Object View Distance)
	0, // angle (optional)
	false, // onSurface (optional)
	0, // bounceOnSurface (optional, default -1. Coef of bounce in collision with ground, 0..1 for collisions, -1 to disable collision. Should be used soberly as it has a significant impact on performance)
	[[0,0,0,0]], // emissiveColor (optional, array of [RGBA] arrays, needs to match 'color' values and be 100x times the RGB color values. Alpha is not used)
	[0,1,0] // vectorDir (optional, sets the default direction for SpaceObject particles)
	];

	_emitter setParticleRandom [0.5,[0,0,1],[20.5,20.5,0.5],20,0.1,[0,0,0,0],0,0,0,0];
	_emitter setParticleCircle [0,[0.8,0.8,-1]];
	_emitter setParticleFire [0,0,0];
	_emitter setDropInterval 0.01;
	
	[0.01,0.9 + random 1,[_centerASL, 400]] spawn FS_fnc_ShakeCam;
	
	sleep 0.5;
	deleteVehicle _emitter;
}] remoteExec ["spawn", 0];


//==================//
//	Applying Force  //
//==================//

[[_affectedUnitsWithForceDir],
{
	//-- First call is on server, because only server knows what clients own what units
	params ["_affectedUnitsWithForceDir"];
	
	private _ownerArr = _affectedUnitsWithForceDir apply { owner (_x # 0) };
	private _owners = _ownerArr arrayIntersect _ownerArr;
	
	//-- Separate units by their locality and then do a single remoteExec on each group 
	{
		private _clientId = _x;
		private _unitsOwnedByThisClient = _affectedUnitsWithForceDir select { owner (_x # 0) == _clientId };
		
		//-- Execute where the unit is local
		[[_unitsOwnedByThisClient], {
			params ["_localUnitsWithForceDir"];
			private _fnc_forceRagdoll = {
				params ["_target", "_force"];
				if (_target isKindOf "Man") then 
				{
					//_target allowDamage false;
					//[_target, 1] remoteExec ["FS_fnc_AddGodmodeTimespan", _target];
					
					_target setUnconscious true;
					
					switch (backpack _target) do 
					{
						case "FS_Backpack_RaiStone": 
						{
							_target addForce [(_force vectorAdd velocity _target) vectorAdd [0,0,3000], [0,0,0]];
							
							_target spawn 
							{
								params ["_target"];
								
								sleep 3;
								
								waitUntil { (vectorMagnitudeSqr velocity _target) < 1 };
								
								if (isTouchingGround _target) then 
								{
									private _desiredTerrainHeightASL = (_posASL # 2) - 1;
									private _positionsAndHeights = [_posASL, 3, 3, _desiredTerrainHeightASL] call FS_fnc_GetNewTerrainHeight; 
									[_positionsAndHeights] call FS_fnc_SetNewTerrainHeight;
									
									[getPos _target] remoteExec ["FS_fnc_FallingDirt", 0];
									
									[0.01,0.9 + random 1,[getPosASL _target, 400]] spawn FS_fnc_ShakeCam;
									
									[_target, {
										params ["_target"]; 
										playSound3D [getMissionPath "music\fart_reverb.ogg", _target, _target call FS_fnc_IsInside, getPosASL _target, 2];
										
										private _emitter = "#particlesource" createVehicleLocal getPos _target;
										_emitter attachTo [_target, [0,0,0]];
										
										_emitter setParticleParams [["warfxPE\ParticleEffects\Universal\smoke_02.p3d",1,0,1,0],"","Billboard",1,5,[0,0,0],[0,0,0],0,10.1,7.9,4,[1,10],[[0.6,0.5,0.4,0.4],[0.6,0.5,0.4,0]],[1],0,0,"","","",0,false,0,[[0,0,0,0]],[0,1,0]];
										_emitter setParticleRandom [0,[5,5,0.1],[5,5,5],10,0,[0,0,0,0],0,0,360,0];
										_emitter setParticleCircle [0,[0,0,0]];
										_emitter setParticleFire [0,0,0];
										_emitter setDropInterval 0.01;
										
										sleep 1;
										
										detach _emitter;
										deleteVehicle _emitter;
										
									}] remoteExec ["spawn",0];
								};
								
								_target setUnconscious false;
								// AparPercMstpSnonWnonDnon_AmovPpneMstpSnonWnonDnon
								// AcrgPknlMstpSnonWnonDnon_AmovPercMstpSrasWrflDnon_getOutMedium
								[_target, "AparPercMstpSnonWnonDnon_AmovPpneMstpSnonWnonDnon"] remoteExec ["switchMove", 0];
							};
						};
						case "B_Parachute": 
						{
							if (isPlayer _target) then 
							{
								private _id = _target addAction ["<t size='2.0' color='#00ff00'>Open Parachute</t>", 
								{ 
									params ["_target", "_caller", "_actionId", "_arguments"];
									_target removeAction _actionId;
									player action ["openParachute", player];
									sleep 1;
									player addBackpack "B_Parachute";
								}, 
								[], 10, true, true, "defaultAction", "((getPos _target) # 2) > 100", 0, true];
							};
							_target addForce [(_force vectorAdd velocity _target) vectorAdd [0,0,13000], [0,0,0]];
						};
						default 
						{
							_target addForce [(_force vectorAdd velocity _target) vectorAdd [0,0,8000], [0,0,0]];
						};
					};
					
					0 = [_target] spawn {
						sleep 6;
						params ['_target'];
						_target setUnconscious false;
					};
				}
				else 
				{
					_target addForce [_force, [0,0,50000]];
					//systemchat typeOf _target;
				};
			};
			{
				[_x # 0, _x # 1] call _fnc_forceRagdoll;
			} forEach _localUnitsWithForceDir;
		
		}] remoteExec ["call", _clientId];
		
	} forEach _owners;
	
}] remoteExec ["call", 0];
