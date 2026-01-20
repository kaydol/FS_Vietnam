
#include "definitions.h"

#define DEF_ILLUSION_PRIGOZHIN 1
#define DEF_ILLUSION_GRAVE 2
#define DEF_ILLUSION_BODIES 3
#define DEF_ILLUSION_MEMORIAL 4
#define DEF_ILLUSION_LITERALLY_ME 5
#define DEF_ILLUSION_HEAVEN 6
#define DEF_ILLUSION_PLANE 7

//-- DEF_ILLUSION_PRIGOZHIN 
#define DEF_NPC_VAR Prigozhin
#define DEF_MARKER_FACE_PLAYER ""
#define DEF_MARKER_ROTATE_90 "90"
#define DEF_MARKER_ROTATE_330 "330"
#define DEF_MARKER_ATTACH_TO_PLAYER "-"
#define DEF_MARKER_FACE_RANDOM_DIR "."
#define DEF_MARKER_END_ANIMATION ".."
#define DEF_MARKER_END_ANIMATION_REVIVE_PLAYER "..."
#define DEF_GLOBAL_ANIM_DONE_EH_ID "FS_EH_AnimDone"
#define DEF_GLOBAL_ANIM_SEQUENCE "FS_AnimSequence"

//-- DEF_ILLUSION_PRIGOZHIN
#define DEF_FNC_RELEASE_LOCK(UNIT,VARNAME) (UNIT setVariable [VARNAME, nil, true])	
#define DEF_FNC_LOCK(UNIT,ID,VARNAME) (UNIT setVariable [VARNAME, ID, true])
#define DEF_FNC_IS_LOCKED(UNIT,VARNAME) (!isNil{UNIT getVariable VARNAME})
#define DEF_PRIGOZHIN_ATMOSPHERE Atmosphere_For_Shiza_Depressed
#define DEF_PRIGOZHIN_JUKEBOX Jukebox_For_Shiza_Depressed

//-- DEF_ILLUSION_GRAVE
#define DEF_GRAVES_GRAVE_CLASSES [["Land_Grave_forest_F", -90], ["Land_Grave_dirt_F", -90]]
#define DEF_GRAVES_FENCE_CLASSES [["Land_GraveFence_03_F", 0], ["Land_GraveFence_02_F", 0]]
#define DEF_GRAVES_MAX_STEEPNESS 0.3
#define DEF_GRAVES_DISTANCE 1.5
#define DEF_GRAVES_ATMOSPHERE Atmosphere_For_Shiza_Depressed
#define DEF_GRAVES_JUKEBOX Jukebox_For_Shiza_Depressed

//-- DEF_ILLUSION_BODIES
#define DEF_BODIES_CLASSES ["Land_vn_b_prop_body_01_02","Land_vn_b_prop_body_02","Land_vn_b_prop_body_01","Land_vn_b_prop_body_02_02"]
#define DEF_BODIES_ATMOSPHERE Atmosphere_For_Shiza_Depressed
#define DEF_BODIES_JUKEBOX Jukebox_For_Shiza_Depressed

//-- DEF_ILLUSION_MEMORIAL
#define DEF_MEMORIAL_CLASSES ["Land_BattlefieldCross_01_F","Land_BattlefieldCross_01_green_F"]
#define DEF_MEMORIAL_FLOWER_CLASSES ["FlowerBouquet_02_F","FlowerBouquet_01_F","FlowerBouquet_03_F"]

//-- DEF_ILLUSION_LITERALLY_ME
#define DEF_LITERALLY_ME_START_HEIGHT 5
#define DEF_LITERALLY_ME_END_HEIGHT 20
#define DEF_LITERALLY_ME_ROTATION 90
#define DEF_LITERALLY_ME_ATMOSPHERE Atmosphere_For_Shiza_LiterallyMe
#define DEF_LITERALLY_ME_JUKEBOX Jukebox_For_Shiza_LiterallyMe

//-- DEF_ILLUSION_HEAVEN
#define DEF_HEAVEN_END_HEIGHT 500
#define DEF_HEAVEN_ATMOSPHERE Atmosphere_For_Shiza_Heaven
#define DEF_HEAVEN_JUKEBOX Jukebox_For_Shiza_Heaven

//-- DEF_ILLUSION_PLANE
#define DEF_ILLUSION_PLANE_CLASS "vnx_b_air_ac119_03_01"
#define DEF_ILLUSION_PLANE_JUKEBOX Jukebox_For_Shiza_Plane

//-- Common definitions 
#define DEF_RESPAWN_MARKER "respawn_west_rally_point"
#define DEF_WOUNDED_ANIM "unconsciousrevivedefault"
#define DEF_CURRENT_PLAYER (missionNameSpace getVariable ["bis_fnc_moduleRemoteControl_unit", player]) 
#define DEF_TRIGGER_PROBABILITY 1
#define DEF_MIN_DISTANCE_TO_TRIGGER 1
#define DEF_USE_2D_DISTANCE true 
#define DEF_FADESOUND_TO 0.15
#define DEF_FADESOUND_OVER 0
#define DEF_CURRENT_ILLUSION_VAR ShizaType // not nil when script is executing 
#define DEF_CURRENT_JUKEBOX_VAR ShizaJukebox
#define DEF_CURRENT_ATMOSPHERE_VAR ShizaAtmosphere
#define DEF_TIMEOUT 45


params ["_player"];

if (_player != DEF_CURRENT_PLAYER) exitWith {
	diag_log format ["(ShizaWounded @ %1) _player != DEF_CURRENT_PLAYER, exiting", clientOwner];
};
if (_player != vehicle DEF_CURRENT_PLAYER) exitWith {
	diag_log format ["(ShizaWounded @ %1) _player != vehicle DEF_CURRENT_PLAYER, exiting", clientOwner];
};
if (!hasInterface) exitWith {
	diag_log format ["(ShizaWounded @ %1) !hasInterface, exiting", clientOwner];
};
if (isNull DEF_NPC_VAR) exitWith {
	diag_log format ["(ShizaWounded @ %1) isNull DEF_NPC_VAR, exiting", clientOwner];
};
if (underWater _player) exitWith {
	diag_log format ["(ShizaWounded @ %1) underWater _player, exiting", clientOwner];
};

private _fnc_getDistanceToHumans = {
	
	if (isNull DEF_CURRENT_PLAYER) exitWith { -1 };

	private _group1 = [getPos DEF_CURRENT_PLAYER, getMarkerPos DEF_RESPAWN_MARKER];
	private _group2 = ((units group DEF_CURRENT_PLAYER) select {isPlayer _x && alive _x}) - [DEF_CURRENT_PLAYER];
	private _distanceToHumans = [_group1, _group2, false, DEF_USE_2D_DISTANCE] call FS_fnc_DistanceBetweenArrays;
	
	if (_distanceToHumans < 0) exitWith { 1e9 };
	
	_distanceToHumans
};

if (!isNil{DEF_CURRENT_ILLUSION_VAR}) exitWith {
	diag_log format ["(ShizaWounded @ %1) Other shiza is already in progress, exiting...", clientOwner];
};

if (((random 1) - DEF_TRIGGER_PROBABILITY) > 0) exitWith {
	diag_log format ["(ShizaWounded @ %1) Lottery failed, exiting...", clientOwner];
};

if (call _fnc_getDistanceToHumans <= DEF_MIN_DISTANCE_TO_TRIGGER) exitWith {
	diag_log format ["(ShizaWounded @ %1) Too close to humans, exiting...", clientOwner];
};


//-------------------------------------------------------------------------------------------------------------

private _possibleShizas = [];

//-- Additional condition to spawn graves: the immediate terrain must be flat enough 
private _result = (position DEF_CURRENT_PLAYER) isFlatEmpty [DEF_GRAVES_DISTANCE, -1, DEF_GRAVES_MAX_STEEPNESS, DEF_GRAVES_DISTANCE, 0, false, DEF_CURRENT_PLAYER];
private _isFlat = _result isNotEqualTo [];
if (_isFlat) then {
	_possibleShizas pushBack DEF_ILLUSION_GRAVE;
};

//-- Additional condition to spawn Prigozhin: Prigozhin must not be meeting other players 
if (!DEF_FNC_IS_LOCKED(DEF_NPC_VAR,DEF_GLOBAL_ANIM_DONE_EH_ID)) then {
	_possibleShizas pushBack DEF_ILLUSION_PRIGOZHIN;
	_possibleShizas pushBack DEF_ILLUSION_PLANE;
};
_possibleShizas pushBack DEF_ILLUSION_BODIES;
//_possibleShizas pushBack DEF_ILLUSION_MEMORIAL; // not ready yet 
_possibleShizas pushBack DEF_ILLUSION_LITERALLY_ME;
_possibleShizas pushBack DEF_ILLUSION_HEAVEN;


//-------------------------------------------------------------------------------------------------------------

if (count _possibleShizas <= 0) exitWith {
	diag_log format ["(ShizaWounded @ %1) No shizas available, exiting...", clientOwner];
};

private _shizaType = selectRandom _possibleShizas;

diag_log format ["(ShizaWounded @ %1) Possible shizas: %2, chosen = %3", clientOwner, _possibleShizas, _shizaType];

private _fnc_doBefore = {
	0 cutText ["", "BLACK IN", 6, true, true];
	enableRadio false;
	clearRadio;
};
private _fnc_doAfter = {
	0 cutText ["", "BLACK IN", 6, true, true];
	enableRadio true;
	DEF_CURRENT_JUKEBOX_VAR = nil;
	DEF_CURRENT_ATMOSPHERE_VAR = nil;
	DEF_CURRENT_ILLUSION_VAR = nil; 
};
private _fnc_rotateVector2D = {
	params ["_dir", "_angle360"];
	
	private _x = 0; // center of rotation, X
	private _y = 0; // center of rotation, Y
	
	private _dx = _x - (_dir select 0); 
	private _dy = _y - (_dir select 1); 
	
	_dir = [ 
		_x - ((_dx * cos (_angle360)) - (_dy * sin (_angle360))), 
		_y - ((_dx * sin (_angle360)) + (_dy * cos (_angle360))),
		0 
	];
	
	_dir
};


switch (_shizaType) do 
{
	case DEF_ILLUSION_PRIGOZHIN: {
		DEF_CURRENT_JUKEBOX_VAR = DEF_PRIGOZHIN_JUKEBOX;
		DEF_CURRENT_ATMOSPHERE_VAR = DEF_PRIGOZHIN_ATMOSPHERE;
		DEF_CURRENT_ILLUSION_VAR = DEF_ILLUSION_PRIGOZHIN;
		
		private _animations = [
			[DEF_MARKER_FACE_PLAYER, "Acts_AidlPercMstpSloWWrflDnon_warmup_6_loop"], 
			[DEF_MARKER_FACE_PLAYER, "Acts_AidlPercMstpSnonWnonDnon_warmup_2_loop", "Acts_AidlPercMstpSnonWnonDnon_warmup_2_out", DEF_MARKER_END_ANIMATION], 
			[DEF_MARKER_FACE_PLAYER, "Acts_AidlPercMstpSnonWnonDnon_warmup_6_loop"],
			[DEF_MARKER_ROTATE_90, "Acts_CivilInjuredArms_1"],
			[DEF_MARKER_FACE_RANDOM_DIR, "Acts_CivilInjuredGeneral_1"],
			[DEF_MARKER_FACE_RANDOM_DIR, "Acts_CivilInjuredHead_1"],
			[DEF_MARKER_FACE_RANDOM_DIR, "Acts_CivilShocked_1"],
			[DEF_MARKER_FACE_PLAYER, "Acts_Executioner_Standing", "Acts_Executioner_Squat", "Acts_Executioner_Squat_End", DEF_MARKER_END_ANIMATION],
			[DEF_MARKER_FACE_PLAYER, "Acts_ExecutionVictim_Loop", "Acts_ExecutionVictim_Kill", "Acts_ExecutionVictim_Kill_End", "Acts_ExecutionVictim_KillTerminal"],
			[DEF_MARKER_ROTATE_330, "Acts_Helping_Wake_Up_1", "Acts_Helping_Wake_Up_2", "Acts_Helping_Wake_Up_3", DEF_MARKER_END_ANIMATION_REVIVE_PLAYER],
			[DEF_MARKER_FACE_RANDOM_DIR, "Acts_Injured_Driver_Loop"],
			[DEF_MARKER_ATTACH_TO_PLAYER, "Acts_TreatingWounded01", DEF_MARKER_END_ANIMATION_REVIVE_PLAYER]
		];

		private _sequence = selectRandom _animations;
		DEF_NPC_VAR setVariable [DEF_GLOBAL_ANIM_SEQUENCE, _sequence, true];

		private _id = DEF_NPC_VAR addEventHandler ["AnimDone", {
			params ["_unit", "_anim"];
			private _sequence = _unit getVariable [DEF_GLOBAL_ANIM_SEQUENCE, []];
			
			private _currentIndex = _sequence findIf {_x == _anim};
			if (_currentIndex > 0) then 
			{
				private _sequenceFinished = (_currentIndex + 1) >= count _sequence; 
				if (!_sequenceFinished) then { _sequenceFinished = (_sequence select (_currentIndex + 1)) == DEF_MARKER_END_ANIMATION; };
				
				if (_sequenceFinished) exitWith 
				{
					_unit removeEventHandler [_thisEvent, _thisEventHandler];
					
					DEF_FNC_RELEASE_LOCK(DEF_NPC_VAR,DEF_GLOBAL_ANIM_DONE_EH_ID);
					diag_log format ["(ShizaWounded @ %1) Graceful finish of %2", clientOwner, _sequence];
				};
				
				private _nextAnim = _sequence select (_currentIndex + 1);
				
				switch (_nextAnim) do 
				{
					case DEF_MARKER_END_ANIMATION_REVIVE_PLAYER : {
					//-- Reviving player 
						DEF_CURRENT_PLAYER setVariable ["vn_revive_incapacitated", false, true];
						_unit removeEventHandler [_thisEvent, _thisEventHandler];
						
						DEF_FNC_RELEASE_LOCK(DEF_NPC_VAR,DEF_GLOBAL_ANIM_DONE_EH_ID);
						diag_log format ["(ShizaWounded @ %1) Player revived, graceful finish of %2", clientOwner, _sequence];
					};
					
					default {
					//-- Queueing next animation in the sequence 
						diag_log format ["(ShizaWounded @ %1) Finished=%2, Next=%3", clientOwner, _anim, _nextAnim];
						[DEF_NPC_VAR, _nextAnim] remoteExec ["switchMove", 0];
					};
				};
			};
		}];
		DEF_FNC_LOCK(DEF_NPC_VAR,_id,DEF_GLOBAL_ANIM_DONE_EH_ID);

		//-------------------------------------------------------------------------------------------------------------
		#include "ShizaWoundedWaitCondition.hpp" //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		//-------------------------------------------------------------------------------------------------------------
		
		private _placeFound = DEF_NPC_VAR setVehiclePosition [ASLToATL eyePos DEF_CURRENT_PLAYER, [], 1, "NONE"];

		if (!_placeFound) exitWith {
			DEF_FNC_RELEASE_LOCK(DEF_NPC_VAR,DEF_GLOBAL_ANIM_DONE_EH_ID);
			diag_log format ["(ShizaWounded @ %1) Could not find enough space near %2, terminating", clientOwner, DEF_CURRENT_PLAYER];
			DEF_CURRENT_ILLUSION_VAR = nil;
		};
		
		call _fnc_doBefore;
		
		DEF_NPC_VAR enableSimulation true;
		DEF_NPC_VAR hideObject false;
		
		switch (_sequence select 0) do {
			case DEF_MARKER_FACE_PLAYER: {
				private _vectorDir = position DEF_NPC_VAR vectorFromTo eyepos DEF_CURRENT_PLAYER;
				[DEF_NPC_VAR, _vectorDir] remoteExec ["setVectorDir", DEF_NPC_VAR];
			};
			case DEF_MARKER_FACE_RANDOM_DIR: {
				[DEF_NPC_VAR, random 360] remoteExec ["setDir", DEF_NPC_VAR];
			};
			case DEF_MARKER_ATTACH_TO_PLAYER: {
				DEF_NPC_VAR attachTo [DEF_CURRENT_PLAYER, [0,0,0]];
			};
			case DEF_MARKER_ROTATE_90: 
			{
				private _dir = position DEF_NPC_VAR vectorFromTo position DEF_CURRENT_PLAYER;
				_dir = [_dir, 90] call _fnc_rotateVector2D;
				[DEF_NPC_VAR, _dir] remoteExec ["setVectorDir", DEF_NPC_VAR];
			};
			case DEF_MARKER_ROTATE_330: 
			{
				private _dir = position DEF_NPC_VAR vectorFromTo position DEF_CURRENT_PLAYER;
				_dir = [_dir, 330] call _fnc_rotateVector2D;
				[DEF_NPC_VAR, _dir] remoteExec ["setVectorDir", DEF_NPC_VAR];
			};
			default {  };
		};
		
		[DEF_NPC_VAR, _sequence select 1] remoteExec ["switchMove", 0];

		//-------------------------------------------------------------------------------------------------------------
		#include "ShizaWoundedExitCondition.hpp" //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		//-------------------------------------------------------------------------------------------------------------
		
		call _fnc_doAfter;
		
		[DEF_NPC_VAR, ""] remoteExec ["switchMove", 0]; 
		DEF_NPC_VAR enableSimulation false;
		DEF_NPC_VAR hideObject true;
		
		DEF_FNC_RELEASE_LOCK(DEF_NPC_VAR,DEF_GLOBAL_ANIM_DONE_EH_ID);
	};
	
	case DEF_ILLUSION_GRAVE: {
		DEF_CURRENT_JUKEBOX_VAR = DEF_GRAVES_JUKEBOX;
		DEF_CURRENT_ATMOSPHERE_VAR = DEF_GRAVES_ATMOSPHERE;
		DEF_CURRENT_ILLUSION_VAR = DEF_ILLUSION_GRAVE;
		
		//-------------------------------------------------------------------------------------------------------------
		#include "ShizaWoundedWaitCondition.hpp" //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		//-------------------------------------------------------------------------------------------------------------
		
		call _fnc_doBefore;
		
		(selectRandom DEF_GRAVES_FENCE_CLASSES) params ["_fenceClass", "_rotation"];
		private _fence = _fenceClass createVehicleLocal [0,0,0];
		
		_fence hideObject true;
		_fence enableSimulation false;
		
		_fence hideObject false;
		_fence enableSimulation true;
		
		_fence setPos getPos player;
		_fence setDir ((getDir player) + _rotation);
		
		
		(selectRandom DEF_GRAVES_GRAVE_CLASSES) params ["_graveClass", "_rotation"];
		private _grave = _graveClass createVehicleLocal [0,0,0];
		
		_grave setPos getPos player;
		_grave setDir ((getDir player) + _rotation);
		
		
		private _shovel = "Land_Shovel_F" createVehicleLocal [0,0,0];
		_shovel hideObject true;
		_shovel enableSimulation false;
		
		if (_shovel setVehiclePosition [DEF_CURRENT_PLAYER modelToWorld (DEF_CURRENT_PLAYER selectionPosition "leftfoot"), [], 0, "NONE"]) then {
			_shovel hideObject false;
			
			private _pos = getPos _shovel;
			_shovel setPos [_pos # 0, _pos # 1, 0.3];
			_shovel setVectorDirAndUp [[0,0.192385,-0.981319], [0.0319868,0.980817,0.192287]];
		};
		
		//-------------------------------------------------------------------------------------------------------------
		#include "ShizaWoundedExitCondition.hpp" //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		//-------------------------------------------------------------------------------------------------------------
		
		deleteVehicle _shovel;
		deleteVehicle _grave;
		deleteVehicle _fence;
		
		call _fnc_doAfter;
	};
	
	case DEF_ILLUSION_BODIES: {
		DEF_CURRENT_JUKEBOX_VAR = DEF_BODIES_JUKEBOX;
		DEF_CURRENT_ATMOSPHERE_VAR = DEF_BODIES_ATMOSPHERE;
		DEF_CURRENT_ILLUSION_VAR = DEF_ILLUSION_BODIES;
		
		//-------------------------------------------------------------------------------------------------------------
		#include "ShizaWoundedWaitCondition.hpp" //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		//-------------------------------------------------------------------------------------------------------------
		
		call _fnc_doBefore;
		
		private _bodies = [];
		
		for [{private _i = 0},{_i < 6},{_i = _i + 1}] do 
		{
			private _body = (selectRandom DEF_BODIES_CLASSES) createVehicleLocal [0,0,0];
			_body hideObject true;
			_body enableSimulation false;
			
			if (_body setVehiclePosition [getPosATL DEF_CURRENT_PLAYER, [], 0, "NONE"]) then 
			{	
				private _vectorDir = position _body vectorFromTo eyepos DEF_CURRENT_PLAYER;
				
				private _pos = getPos _body;
				_body setPos [_pos # 0, _pos # 1, _pos # 2 + 0.74];
				
				_body setVectorDirAndUp [[0,0,1], _vectorDir];
				_body hideObject false;
				_bodies pushBack _body;
			} else {
				deleteVehicle _body;
			};
		};
		
		private _code = {
			{ 
				private _vectorDir = position _x vectorFromTo eyepos DEF_CURRENT_PLAYER;
				_x setVectorDirAndUp [[0,0,1], _vectorDir];
			} forEach _this;
		};
		
		["ShizaBodiesBehaviour", "OnEachFrame", _code, _bodies] call BIS_fnc_addStackedEventHandler;
		
		private _skeleton = "Land_HumanSkeleton_F" createVehicleLocal [0,0,0];
		_skeleton setDir random 360;
		
		_skeleton hideObject true;
		if (_skeleton setPosATL getPosATL DEF_CURRENT_PLAYER) then {
			private _pos = getPosATL _skeleton;
			_skeleton setPosATL [_pos # 0, _pos # 1, -0.2];
			_skeleton hideObject false;
			_skeleton enableSimulation false;
		} else {
			deleteVehicle _skeleton;
		};
		
		//-------------------------------------------------------------------------------------------------------------
		#include "ShizaWoundedExitCondition.hpp" //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		//-------------------------------------------------------------------------------------------------------------
		
		
		["ShizaBodiesBehaviour", "OnEachFrame"] call BIS_fnc_removeStackedEventHandler;
		{ deleteVehicle _x } forEach _bodies;
		deleteVehicle _skeleton;
		
		DEF_CURRENT_ILLUSION_VAR = nil;
		call _fnc_doAfter;
	};
	
	case DEF_ILLUSION_MEMORIAL: {
		DEF_CURRENT_JUKEBOX_VAR = nil;
		DEF_CURRENT_ATMOSPHERE_VAR = nil;
		DEF_CURRENT_ILLUSION_VAR = DEF_ILLUSION_MEMORIAL;
		
		//-------------------------------------------------------------------------------------------------------------
		#include "ShizaWoundedWaitCondition.hpp" //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		//-------------------------------------------------------------------------------------------------------------
		
		call _fnc_doBefore;
		
		
		//-------------------------------------------------------------------------------------------------------------
		#include "ShizaWoundedExitCondition.hpp" //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		//-------------------------------------------------------------------------------------------------------------
		
		call _fnc_doAfter;
	};
	
	case DEF_ILLUSION_LITERALLY_ME: {
		DEF_CURRENT_JUKEBOX_VAR = DEF_LITERALLY_ME_JUKEBOX;
		DEF_CURRENT_ATMOSPHERE_VAR = DEF_LITERALLY_ME_ATMOSPHERE;
		DEF_CURRENT_ILLUSION_VAR = DEF_ILLUSION_LITERALLY_ME;
		
		//-------------------------------------------------------------------------------------------------------------
		#include "ShizaWoundedWaitCondition.hpp" //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		//-------------------------------------------------------------------------------------------------------------
		
		call _fnc_doBefore;
		
		private _cam = "camera" camCreate (player modelToWorld [0, 0, 5]);
		_cam camSetTarget player;
		_cam camCommit 0;
		
		_cam switchCamera "INTERNAL";
		
		cameraEffectEnableHUD false;
		
		player switchMove "Acts_InjuredLyingRifle02_180";
		
		private _code = 
		{
			params ["_cam", "_target", "_originalVector", "_time", "_fnc_rotateVector2D"];
			if (isNull(_cam) || isNull(_target)) exitWith {	["ShizaLiterallyMeCamera", "OnEachFrame"] call BIS_fnc_removeStackedEventHandler;	};
			private _currentAngle = linearConversion [_time, _time + DEF_TIMEOUT, time, 0, DEF_LITERALLY_ME_ROTATION];
			private _dir = [_originalVector, _currentAngle] call _fnc_rotateVector2D;
			private _currentHeight = linearConversion [_time, _time + DEF_TIMEOUT, time, DEF_LITERALLY_ME_START_HEIGHT, DEF_LITERALLY_ME_END_HEIGHT];
			private _pos = getPosATL _target;
			_pos set [2, _currentHeight];
			_cam setPosATL _pos;
			_cam setVectorDirAndUp [[0,0,-1], _dir];
			_cam camSetFocus [_currentHeight, 1];
			_cam camCommit 0;
		};
		
		["ShizaLiterallyMeCamera", "OnEachFrame", _code, [_cam, player, vectorDir player, time, _fnc_rotateVector2D]] call BIS_fnc_addStackedEventHandler;
		
		//-------------------------------------------------------------------------------------------------------------
		#include "ShizaWoundedExitCondition.hpp" //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		//-------------------------------------------------------------------------------------------------------------
		
		["ShizaLiterallyMeCamera", "OnEachFrame"] call BIS_fnc_removeStackedEventHandler;
		
		_cam cameraEffect ["terminate", "back"];
		
		player switchMove DEF_WOUNDED_ANIM;
		player switchCamera "INTERNAL";
		
		camDestroy _cam;
		
		
		call _fnc_doAfter;
	};
	
	case DEF_ILLUSION_HEAVEN: {
		DEF_CURRENT_JUKEBOX_VAR = DEF_HEAVEN_JUKEBOX;
		DEF_CURRENT_ATMOSPHERE_VAR = DEF_HEAVEN_ATMOSPHERE;
		DEF_CURRENT_ILLUSION_VAR = DEF_ILLUSION_HEAVEN;
		
		//-------------------------------------------------------------------------------------------------------------
		#include "ShizaWoundedWaitCondition.hpp" //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		//-------------------------------------------------------------------------------------------------------------
		
		call _fnc_doBefore;
		
		player hideObject true;
		
		private _fakePlayer = typeOf player createVehicleLocal [0,0,0];
		_fakePlayer allowDamage false;
		_fakePlayer setDir getDir player;
		_fakePlayer setPos (player modelToWorld [0, 0, 0]);
		[_fakePlayer, [missionNameSpace, DEF_LOADOUT_NAME], []] call BIS_fnc_loadInventory;
		removeAllWeapons _fakePlayer;
		
		//_fakePlayer switchMove "Acts_InjuredLyingRifle02_180";
		//_fakePlayer switchMove "Acts_Stunned_Unconscious_end";
		_fakePlayer switchMove "Acts_Undead_Coffin";
		
		private _cam = "camera" camCreate (player modelToWorld [5, 5, 15]);
		_cam camSetTarget _fakePlayer;
		_cam cameraEffect ["internal", "back"];
		_cam camCommit 15;
		
		cameraEffectEnableHUD false;
		
		private _code = 
		{
			params ["_target", "_time", "_startAtHeight"];
			if (isNull(_target)) exitWith {	["ShizaHeavenCamera", "OnEachFrame"] call BIS_fnc_removeStackedEventHandler;	};
			
			private _currentHeight = linearConversion [_time, _time + 400, time, _startAtHeight, _startAtHeight + DEF_HEAVEN_END_HEIGHT];
			
			private _pos = getPosATL player;
			_pos set [2, _currentHeight];
			_target setPosATL _pos;
		};
		
		["ShizaHeavenCamera", "OnEachFrame", _code, [_fakePlayer, time, (player modelToWorld [0, 0, 0]) select 2]] call BIS_fnc_addStackedEventHandler;
		
		//-------------------------------------------------------------------------------------------------------------
		#include "ShizaWoundedExitCondition.hpp" //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		//-------------------------------------------------------------------------------------------------------------
		
		["ShizaHeavenCamera", "OnEachFrame"] call BIS_fnc_removeStackedEventHandler;
		
		_cam cameraEffect ["terminate", "back"];
		
		player hideObject false;
		player switchCamera "INTERNAL";
		deleteVehicle _fakePlayer;
		
		camDestroy _cam;
		
		call _fnc_doAfter;
	};
	
	case DEF_ILLUSION_PLANE: {
		DEF_CURRENT_JUKEBOX_VAR = DEF_ILLUSION_PLANE_JUKEBOX;
		DEF_CURRENT_ATMOSPHERE_VAR = DEF_PRIGOZHIN_ATMOSPHERE;
		DEF_CURRENT_ILLUSION_VAR = DEF_ILLUSION_PLANE;
		
		//-------------------------------------------------------------------------------------------------------------
		#include "ShizaWoundedWaitCondition.hpp" //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		//-------------------------------------------------------------------------------------------------------------
		
		call _fnc_doBefore;
		
		private _planePos = [position player # 0, position player # 1, 200];
		private _planeLocal =  createVehicleLocal [DEF_ILLUSION_PLANE_CLASS, _planePos, [], 0, "FLY"];
		_planeLocal setPos _planePos;
		_planeLocal setVelocity [0,100,0];
		
		private _npcPos = getPos DEF_NPC_VAR;
		DEF_NPC_VAR enableSimulation true;
		DEF_NPC_VAR hideObject false;
		DEF_NPC_VAR moveInDriver _planeLocal;
		
		private _fakePlayer = typeOf player createVehicle [0,0,0];
		_fakePlayer hideObjectGlobal true;
		_fakePlayer allowDamage false;
		_fakePlayer setDir getDir player;
		_fakePlayer setPos (player modelToWorld [0, 0, 0]);
		[_fakePlayer, [missionNameSpace, DEF_LOADOUT_NAME], []] call BIS_fnc_loadInventory;
		_fakePlayer switchMove "Acts_InjuredLyingRifle02_180";
		
		private _playerPos = getPos player;
		player hideObjectGlobal true;
		player hideObject false;
		
		_fakePlayer hideObjectGlobal false;
		
		player moveInTurret [_planeLocal, [0]];
		
		private _hasMap = false;
		if ("vn_b_item_map" in ((assignedItems player) apply {tolowerANSI _x})) then {
			player unassignItem "vn_b_item_map";
			_hasMap = true;
		};
		
		DEF_FNC_LOCK(DEF_NPC_VAR,DEF_ILLUSION_PLANE,DEF_GLOBAL_ANIM_DONE_EH_ID);
		
		_planeLocal spawn 
		{
			sleep 4;
			
			private _lightningPos = [];
			private _center = createCenter sideLogic;
			private _group = createGroup _center;
			private _logic = _group createUnit ["LOGIC", position player, [], 0, "NONE"];
			
			for [{private _i = 0},{_i < 1},{_i = _i + 1}] do {
				_lightningPos = (_this modelToWorld [0,100,0]);
				_logic setPos _lightningPos;
				[_logic, [], true] call BIS_fnc_moduleLightning;
			};
			
			sleep 1;
			
			deleteVehicle _logic;
			deleteGroup _group;
		};
		
		//-------------------------------------------------------------------------------------------------------------
		#include "ShizaWoundedExitCondition.hpp" //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		//-------------------------------------------------------------------------------------------------------------
		
		if (_hasMap) then {
			if ("vn_b_item_map" in ((items player) apply {tolowerANSI _x})) then {
				player assignItem "vn_b_item_map";
			} else {
				player linkItem "vn_b_item_map";
			};
		};
		
		deleteVehicle _fakePlayer;
		deleteVehicle _planeLocal;
		
		moveOut DEF_NPC_VAR;
		DEF_NPC_VAR enableSimulation false;
		DEF_NPC_VAR hideObject true;
		DEF_NPC_VAR setPos _playerPos;
		DEF_FNC_RELEASE_LOCK(DEF_NPC_VAR,DEF_GLOBAL_ANIM_DONE_EH_ID);
		
		moveOut player;
		player setVelocity [0,0,0]; // otherwise death after moving too fast from moveOut :D
		player setPos _playerPos;
		player switchMove "unconsciousrevivedefault";
		player hideObjectGlobal false;
		
		call _fnc_doAfter;
	};
};

