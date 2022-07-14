
#define JUKEBOX_PRESET_ARSENAL 0
#define JUKEBOX_PRESET_CUSTOM 3

params ["_logic", ["_units", []], ["_activated", false]];

if !(_activated) exitWith {};

/* A little hack to make the logic have a nice string-friendly name */
private _logicName = format ["ModuleJukebox_%1", round random 1000000];
_logic call compile ( _logicName + "=_this" );

/* Retreiving variables stored in the module */
private _announceTracks = _logic getVariable "AnnounceTracks";
private _playLocally = _logic getVariable "PlayLocally";
private _stopMusic = _logic getVariable "StopMusic";
private _startCondition = compile ( _logic getVariable "StartCondition" );
private _stopCondition = compile ( _logic getVariable "StopCondition" );
private _loopConditions = _logic getVariable "LoopConditions";
private _DisableACEVolumeUpdate = _logic getVariable "DisableACEVolumeUpdate";
private _presetMode = _logic getVariable "Preset";
private _customTracks = _logic getVariable "CustomTracks";
private _aceEnabled = isClass (configFile >> "CfgPatches" >> "ace_main");

if ( !_playLocally && !isServer ) exitWith {};

if ( _aceEnabled && _DisableACEVolumeUpdate ) then 
{
	if ( _playLocally ) then 
	{
		[] spawn {
			WaitUntil { sleep 1; !isNil{ ace_hearing_disableVolumeUpdate }};
			ace_hearing_disableVolumeUpdate = false;
		};
	} 
	else {
		{
			WaitUntil { sleep 1; !isNil{ ace_hearing_disableVolumeUpdate }};
			ace_hearing_disableVolumeUpdate = false;
		}
		remoteExec ["spawn", 0, True];
	};
};

/* Construct a track pool based on selected preset */
private _pool = [];

switch _presetMode do {
	case JUKEBOX_PRESET_ARSENAL: { 
		_pool = ["arsenal_1", "arsenal_2", "arsenal_3", "arsenal_4", "arsenal_5"];
	};
	case JUKEBOX_PRESET_CUSTOM: { 
		_pool = call compile _customTracks; 
	};
	default {};
};

/* This check mainly fires if the user screwed up when entering Custom track pool */
if !( _pool isEqualType [] ) exitWith {
	["Invalid track list for Jukebox: '%1'. Exiting...", _pool] call BIS_fnc_error;
};
if !( _pool isEqualTypeAll "" ) exitWith {
	["Invalid track list for Jukebox: '%1'. Exiting...", _pool] call BIS_fnc_error;
};

/* This check fires if one or more tracks don't exist in the CfgMusic */
{
	if (!isClass (configFile >> "CfgMusic" >> _x) && 
		!isClass (missionConfigFile >> "CfgMusic" >> _x)) then {
		["CfgMusic does not contain '%1', missing addon or was it removed?", _x] call BIS_fnc_error;
	};
} 
forEach _pool;

/* Adding weights */
private _poolWeighted = [];
_poolWeighted resize ( count _pool * 2 );

for [{_i = 0},{_i < count _poolWeighted },{ _i = _i + 1}] do {
	_poolWeighted set [_i, [_pool # round ( _i / 2 ), 1.0] select ( _i % 2 == 1 )];
};

/* Store the track pool in the Logic namespace */
_logic setVariable ["TrackPool", _poolWeighted];

while { true } do 
{
	/* Wait until a user-defined condition is true */
	WaitUntil { sleep 1; call _startCondition }; 
	
	[_logic] call FS_fnc_JukeboxPlayMusic;

	/* Add event handler that starts another track once the current one ends */
	private _code = compile format ["[%1] call FS_fnc_JukeboxPlayMusic;", _logicName];
	private _id = addMusicEventHandler ["MusicStop", _code];

	if ( _id == -1 ) exitWith {
		["Error: addMusicEventHandler returned -1"] call BIS_fnc_error;
	};

	/* Wait until a user-defined condition is true */
	WaitUntil { sleep 1; call _stopCondition };

	removeMusicEventHandler ["MusicStop", _id];

	/* If enabled, stop the currently playing track */
	if ( _stopMusic ) then 
	{
		if ( _playLocally ) then {
			3 fadeMusic 0;
			sleep 3;
			playMusic "";
			0 fadeMusic 1;
		} 
		else 
		{
			[3,0] remoteExec ["fadeMusic", 0];
			sleep 3;
			[""] remoteExec ["playMusic", 0];
			[0,1] remoteExec ["fadeMusic", 0];
		};
	};
	
	if !( _loopConditions ) exitWith {};

};

//-- Deleting is not an option if the module is supposed to play locally
//-- Deletion is global for all players
if (!_playLocally) then {
	deleteVehicle _logic;
};
