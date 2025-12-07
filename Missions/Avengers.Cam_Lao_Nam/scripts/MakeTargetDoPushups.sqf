
#define DEF_MARKER_DISABLE_AI_ANIM "disableAI_ANIM"
#define DEF_MARKER_ENABLE_AI_ANIM "enableAI_ANIM"
#define DEF_MARKER_FACE_ARGS0 ""
#define DEF_MARKER_ROTATE_90 "90"
#define DEF_MARKER_ROTATE_330 "330"
#define DEF_MARKER_ATTACH_TO_ARGS0 "-"
#define DEF_MARKER_FACE_RANDOM_DIR "."
#define DEF_MARKER_END_ANIMATION ".."
#define DEF_MARKER_END_ANIMATION_REVIVE_ARGS0 "..."

params ["_target"];

if (isPlayer _target && _target != player) exitWith {};

if (!isPlayer _target && !local _target) then {
	[_target, { _this execVM "scripts\MakeTargetDoPushups.sqf" }] remoteExec ["spawn", _target];
};

if ((!isPlayer _target && local _target) || _target == player) then {
	
	private _sequence = [];
	
	_sequence pushBack DEF_MARKER_DISABLE_AI_ANIM;
	
	//-- Pushup
	
	if (currentWeapon _target isNotEqualTo "" && currentWeapon _target == primaryWeapon _target) then {
		private _unequipRifle = "AmovPercMstpSrasWrflDnon_AwopPercMstpSoptWbinDnon";
		_sequence pushBack _unequipRifle;
	};
	
	if (currentWeapon _target isNotEqualTo "" && currentWeapon _target == secondaryWeapon _target) then {
		private _unequipPistol_1 = "AmovPercMstpSrasWpstDnon_AmovPercMstpSnonWnonDnon";
		private _unequipPistol_2 = "AmovPercMstpSrasWpstDnon_AmovPercMstpSnonWnonDnon_end";
		_sequence pushBack _unequipPistol_1;
		_sequence pushBack _unequipPistol_2;
	};
	
	_sequence pushBack "AmovPercMstpSnonWnonDnon_SaluteIn";
	_sequence pushBack "AmovPercMstpSnonWnonDnon_SaluteOut";
	_sequence pushBack "AmovPercMstpSnonWnonDnon_exercisePushup";
	
	//_sequence pushBack DEF_MARKER_ENABLE_AI_ANIM;
	//_sequence pushBack DEF_MARKER_END_ANIMATION;
	
	private _timeoutExitCode = {
		params ["_target"]; 
		_target enableAI "ANIM";
		//_target switchMove ""; 
	};
	
	[_target, _sequence, [], 18, _timeoutExitCode, true] call FS_fnc_PlayAnimationSequence;
	
	
	// Sits AmovPercMstpSnonWnonDnon_exercisekneeBendB AmovPercMstpSnonWnonDnon_exercisekneeBendA
};
