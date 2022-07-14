
params [["_logic", objNull]];

if (isNull _logic) exitWith {
	"Jukebox module was deleted, music couldn't be played" call BIS_fnc_Error;
};

private _announceTracks = _logic getVariable "AnnounceTracks";
private _poolWeighted = _logic getVariable "TrackPool";
private _playLocally = _logic getVariable "PlayLocally";

if ( !_playLocally && !isServer ) exitWith {};
	
/* 1) If there is only one track in the pool, let it have non-zero weight */
if ( count _poolWeighted == 2 ) then { _poolWeighted set [1, 1] };

/* 2) Select the first track */
private _newTrack = selectRandomWeighted _poolWeighted;
private _newTrackID = _poolWeighted findIf { _x isEqualTo _newTrack };

/* 3) Increase all the weights by the increment */
if (count _poolWeighted > 2) then { // do nothing if there is only 1 track in the pool
	_poolWeighted = _poolWeighted apply {
		if ( _x isEqualType 0 ) then {
			_x = _x + 1.0 / ((count _poolWeighted - 2) / 2);
			_w = [_x, 1.0] select (_x > 1.0);
			_x = _w;
		};
		_x
	};
};

/* 4) Set the weight of the currently selected track to be 0 */
if (count _poolWeighted > 2) then { // do nothing if there is only 1 track in the pool
	_poolWeighted set [_newTrackID + 1, 0];
};

/* 5) Store the track pool in the Logic namespace */
_logic setVariable ["TrackPool", _poolWeighted];

/* 6) Run the track locally or on all connected clients */
if ( _playLocally ) then {
	playMusic _newTrack;
} else {
	[_newTrack] remoteExec ["playMusic", 0];
};

/* 7) Write track name in chat if enabled */
if ( _announceTracks ) then {
	_name = getText (configFile >> "CfgMusic" >> _newTrack >> "name");
	[format ["Now playing: %1", _name]] remoteExec ["SystemChat", 0];
};