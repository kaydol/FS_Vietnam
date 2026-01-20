
#include "..\..\definitions.h"

#define DEF_SMART_HELMET_SFX "FS_Necrons_Sound"
#define DEF_SMART_HELMET_SFX_DISTANCE 15
#define DEF_SMART_HELMET_SFX_LENGTH 16

#define DEF_ATTACHED_SPEAKERS "FS_AddObjectSFX_AttachedSpeakers"
#define DEF_SMART_HELMET_IS_FIRST_ACTIVATION_VAR "FS_SmartHelmet_Intro_Video_Was_Played"

params ["_target"];

//-- Adds discharge loop, stops the old one first  
private _fnc_addDischargeLoop = {

	private _handle = 0 spawn {};
	_handle = missionNameSpace getVariable [DEF_HUD_HELMET_DISCHARGE_LOOP_VAR, _handle];
	if !(scriptDone _handle) then {
		terminate _handle;
	};
	missionNameSpace setVariable [DEF_HUD_HELMET_CHARGE_LEFT_VAR, DEF_HUD_HELMET_MAX_CHARGE];
	_handle = 0 spawn {
		while {
		((missionNameSpace getVariable [DEF_HUD_HELMET_CHARGE_LEFT_VAR, 0]) > 0) && 
		((missionNameSpace getVariable [DEF_EQUIPMENT_ENABLE_HUD_VAR, false]) == true)} do 
		{
			private _seconds = missionNameSpace getVariable [DEF_HUD_HELMET_CHARGE_LEFT_VAR, 0];
			missionNameSpace setVariable [DEF_HUD_HELMET_CHARGE_LEFT_VAR, _seconds - 1];
			sleep 1;
		};
		// Turn off HUD when charge drops to 0
		missionNameSpace setVariable [DEF_EQUIPMENT_ENABLE_HUD_VAR, false];
		missionNameSpace setVariable [DEF_HUD_HELMET_CHARGE_LEFT_VAR, 0];
	};
	missionNameSpace setVariable [DEF_HUD_HELMET_DISCHARGE_LOOP_VAR, _handle];
};

//-- Plays sound for local and remote players 
private _fnc_playSoundForAll = {

	[DEF_CURRENT_PLAYER, 
	{
		if (!hasInterface) exitWith {};
		
		// 1. Delete old speakers
		private _attachedSpeakers = _this getVariable [DEF_ATTACHED_SPEAKERS, []];
		private _allGroups = [];
		if !(_attachedSpeakers isEqualTo []) then {
			_allGroups = _attachedSpeakers apply {group _x};
			_allGroups = _allGroups arrayIntersect _allGroups;
		};
		{ deleteVehicle _x } forEach _attachedSpeakers;
		{ if !(isNull _x) then { deleteGroup _x } } forEach _allGroups;
		
		// 2. Add new speaker
		private _center = createCenter sideLogic;
		private _group = createGroup _center;
		_speaker = _group createUnit ["LOGIC", [0,0,0], [], 0, "CAN_COLLIDE"];
		_speaker attachTo [_this, [0,0,0], "head"];
		_attachedSpeakers pushBack _speaker;
		_this setVariable [DEF_ATTACHED_SPEAKERS, _attachedSpeakers, TRUE];
		
		// 3. Play sound
		_speaker say3D [DEF_SMART_HELMET_SFX, DEF_SMART_HELMET_SFX_DISTANCE];
		
		sleep DEF_SMART_HELMET_SFX_LENGTH;
		
		// 4. Delete speaker
		if !(isNull _group) then {
			deleteGroup _group;
		};
		if !(isNull _speaker) then {
			deleteVehicle _speaker;
		};
		
	}] remoteExec ["spawn", 0];
};

//-- Stops the sound if it is being played
private _fnc_stopPlayingSoundsForAll = {

	[DEF_CURRENT_PLAYER, 
	{
		if (!hasInterface) exitWith {};
		
		// Next part is only for other clients
		if (_this == DEF_CURRENT_PLAYER) exitWith {};
		
		// 1. Delete old speakers
		private _attachedSpeakers = _this getVariable [DEF_ATTACHED_SPEAKERS, []];
		private _allGroups = [];
		if !(_attachedSpeakers isEqualTo []) then { 
			_allGroups = _attachedSpeakers apply {group _x};
			_allGroups = _allGroups arrayIntersect _allGroups;
		};
		{ deleteVehicle _x } forEach _attachedSpeakers;
		{ if !(isNull _x) then { deleteGroup _x } } forEach _allGroups;
		
	}] remoteExec ["spawn", 0];
};

//========================================================================================================

private _hasHelmet = toLowerANSI headgear DEF_CURRENT_PLAYER in (DEF_HUD_HELMETS apply {toLowerANSI _x});
private _enabled = false;

if (_hasHelmet) then 
{
	_enabled = missionNameSpace getVariable [DEF_EQUIPMENT_ENABLE_HUD_VAR, false];
	_enabled = !_enabled;
	
	if (DEF_HUD_HELMET_ENABLE_CHARGE_MECHANIC) then 
	{
		if (_enabled) then 
		{
			if (missionNameSpace getVariable [DEF_SMART_HELMET_IS_FIRST_ACTIVATION_VAR, true]) then 
			{
				["FS_Vietnam\Videos\necrons.ogv"] spawn bis_fnc_playVideo;
				
				[DEF_CURRENT_PLAYER, 
				{ 
					_this switchMove "Acts_Shocked_1_Loop";
					
				}] remoteExec ["spawn", 0];
			}
			else 
			{
				DEF_CURRENT_PLAYER playMoveNow selectRandom [
					"AmovPercMstpSnonWnonDnon_exercisekneeBendA",
					"AmovPercMstpSnonWnonDnon_exercisekneeBendB",
					"AmovPercMstpSnonWnonDnon_exercisePushup"
				];
			};
			
			[] call _fnc_addDischargeLoop;
			[] call _fnc_playSoundForAll;
		}
		else
		{
			//[""] spawn bis_fnc_playVideo;
			
			[] call _fnc_stopPlayingSoundsForAll;
		};
	};
};

missionNameSpace setVariable [DEF_EQUIPMENT_ENABLE_HUD_VAR, _enabled];

missionNameSpace setVariable [DEF_SMART_HELMET_IS_FIRST_ACTIVATION_VAR, false]; // prevent video to be played a second time 
