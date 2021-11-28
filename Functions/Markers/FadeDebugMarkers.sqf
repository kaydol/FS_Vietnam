// Multiplayer optimisation: Global marker commands always broadcast the entire marker state over the network. As such, the number of network messages exchanged when creating or editing a marker can be reduced by performing all but the last operation using local marker commands, then using a global marker command for the last change (and subsequent global broadcast of all changes applied to the marker).

params ["_markers", ["_lifeTime", 0], ["_delayBeforeFading", 0]];

if (_delayBeforeFading > 0) then {
	sleep _delayBeforeFading;
};

if (hasInterface) then 
{
	[_markers, _lifetime] spawn {
		params ["_markers", "_lifetime"];
		for [{_i = 0},{_i < _lifetime},{_i = _i + _lifetime / 10}] do {
			sleep (_lifetime / 10);
			{
				_x setMarkerAlphaLocal linearConversion [0, _lifetime, _i, 1, 0];
			} forEach _markers;
		};
		{ deleteMarkerLocal _x } forEach _markers;
	};
} 
else 
{
	[_markers, _lifetime] spawn {
		params ["_markers", "_lifetime"];
		for [{_i = 0},{_i < _lifetime},{_i = _i + _lifetime / 10}] do {
			sleep (_lifetime / 10);
			{
				_x setMarkerAlpha linearConversion [0, _lifetime, _i, 1, 0];
			} forEach _markers;
		};
		{ deleteMarker _x } forEach _markers;
	};
};


