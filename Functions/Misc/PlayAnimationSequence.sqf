/*
	Author: kaydol
	
	Description:
		Makes a local unit play a sequence of animations globally.
		
	Sequence array must be unique because the current index is found 
	via `_seqience findIf {_x == _anim}` and repeating animations will
	lead to calculating a wrong index.  
	
	First item in the sequence is always treated as a special marker 
	
*/

params ["_target", "_sequence", ["_args", []], ["_timeout", -1], ["_timeoutExitCode", {}], ["_debug", false]];

#define DEF_MARKER_DISABLE_AI_ANIM "disableAI_ANIM"
#define DEF_MARKER_ENABLE_AI_ANIM "enableAI_ANIM"
#define DEF_MARKER_FACE_ARGS0 ""
#define DEF_MARKER_ROTATE_90 "90"
#define DEF_MARKER_ROTATE_330 "330"
#define DEF_MARKER_ATTACH_TO_ARGS0 "-"
#define DEF_MARKER_FACE_RANDOM_DIR "."
#define DEF_MARKER_END_ANIMATION ".."
#define DEF_MARKER_END_ANIMATION_REVIVE_ARGS0 "..."

#define DEF_GLOBAL_ANIM_DONE_EH_ID "FS_EH_AnimDone"
#define DEF_GLOBAL_ANIM_SEQUENCE "FS_AnimSequence" 
#define DEF_GLOBAL_ANIM_SEQUENCE_ARGS "FS_AnimSequence_Args"
#define DEF_GLOBAL_ANIM_SEQUENCE_DEBUG "FS_AnimSequence_Debug"

_target setVariable [DEF_GLOBAL_ANIM_SEQUENCE, _sequence, true];
_target setVariable [DEF_GLOBAL_ANIM_SEQUENCE_ARGS, _args, true];
_target setVariable [DEF_GLOBAL_ANIM_SEQUENCE_DEBUG, _debug, true];

private _id = _target addEventHandler ["AnimDone", {
	params ["_unit", "_anim"];
	private _sequence = _unit getVariable [DEF_GLOBAL_ANIM_SEQUENCE, []];
	private _args = _unit getVariable [DEF_GLOBAL_ANIM_SEQUENCE_ARGS, []];
	private _debug = _unit getVariable [DEF_GLOBAL_ANIM_SEQUENCE_DEBUG, []];
	
	private _currentIndex = _sequence findIf {_x == _anim};
	if (_currentIndex > 0) then 
	{
		private _sequenceFinished = (_currentIndex + 1) >= count _sequence; 
		if (!_sequenceFinished) then { _sequenceFinished = (_sequence select (_currentIndex + 1)) == DEF_MARKER_END_ANIMATION; };
		
		if (_sequenceFinished) exitWith 
		{
			_unit removeEventHandler [_thisEvent, _thisEventHandler];
			if (_debug) then {
				diag_log format ["(PlayAnimationSequence @ %1) Graceful finish of %2", clientOwner, _sequence];
			};
		};
		
		private _nextAnim = _sequence select (_currentIndex + 1);
		
		switch (_nextAnim) do 
		{
			case DEF_MARKER_END_ANIMATION_REVIVE_ARGS0 : {
			//-- Reviving unit at args[0] 
				(_args # 0) setVariable ["vn_revive_incapacitated", false, true];
				_unit removeEventHandler [_thisEvent, _thisEventHandler];
				
				if (_debug) then {
					diag_log format ["(PlayAnimationSequence @ %1) Player revived, graceful finish of %2", clientOwner, _sequence];
				};
			};
			
			case DEF_MARKER_DISABLE_AI_ANIM: {
				[[_unit, "ANIM"], { params ["_t", "_a"]; _t enableAI _a; }] remoteExec ["call", _unit];
				
				if (_debug) then {
					diag_log format ["(PlayAnimationSequence @ %1) Disabling AI ANIM %2", clientOwner, _sequence];
				};
			};
			case DEF_MARKER_ENABLE_AI_ANIM: {
				[[_unit, "ANIM"], { params ["_t", "_a"]; _t disableAI _a; }] remoteExec ["call", _unit];
				
				if (_debug) then {
					diag_log format ["(PlayAnimationSequence @ %1) Enabling AI ANIM %2", clientOwner, _sequence];
				};
			};
			
			default {
			//-- Queueing next animation in the sequence 
				if (_debug) then {
					diag_log format ["(PlayAnimationSequence @ %1) Finished=%2, Next=%3", clientOwner, _anim, _nextAnim];
				};
				[_unit, _nextAnim] remoteExec ["switchMove", 0];
			};
		};
	};
}];

//-- Special actions executed as first position in the sequence 
switch (_sequence select 0) do {
	//-- Make _target face the eyePos of _args[0]
	case DEF_MARKER_FACE_ARGS0: {
		private _vectorDir = position _target vectorFromTo eyepos (_args # 0);
		[_target, _vectorDir] remoteExec ["setVectorDir", _target];
	};
	//-- Make _target face random direction
	case DEF_MARKER_FACE_RANDOM_DIR: {
		[_target, random 360] remoteExec ["setDir", _target];
	};
	//-- Attach _target to object at _args[0]
	case DEF_MARKER_ATTACH_TO_ARGS0: {
		_target attachTo [_args # 0, [0,0,0]];
	};
	//-- Rotate _target 90 degrees relative to the object at _args[0]
	case DEF_MARKER_ROTATE_90:
	{
		private _dir = position _target vectorFromTo position (_args # 0);
		_dir = [_dir, 90] call FS_fnc_RotateVector2D;
		[_target, _dir] remoteExec ["setVectorDir", _target];
	};
	// Rotate _target 330 degrees relative to the object at _args[0]
	case DEF_MARKER_ROTATE_330:
	{
		private _dir = position _target vectorFromTo position (_args # 0);
		_dir = [_dir, 330] call FS_fnc_RotateVector2D;
		[_target, _dir] remoteExec ["setVectorDir", _target];
	};
	case DEF_MARKER_DISABLE_AI_ANIM: {
		[[_target, "ANIM"], { params ["_t", "_a"]; _t disableAI _a; }] remoteExec ["call", _target];
	};
	default {  };
};

[_target, _sequence select 1] remoteExec ["switchMove", 0];

if (_timeout >= 0) then {
	private _time = time;
	waitUntil { time > _time + _timeout };
	
	if (_debug) then {
		diag_log format ["(PlayAnimationSequence @ %1) Timed out", clientOwner];
	};
	
	_target removeEventHandler ["AnimDone", _id];
	_this spawn _timeoutExitCode;
};