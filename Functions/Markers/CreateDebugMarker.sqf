
// Multiplayer optimisation: Global marker commands always broadcast the entire marker state over the network. As such, the number of network messages exchanged when creating or editing a marker can be reduced by performing all but the last operation using local marker commands, then using a global marker command for the last change (and subsequent global broadcast of all changes applied to the marker).

params ["_markerPos", ["_markerType", objNull], ["_markerColor", objNull], ["_markerText", objNull], ["_markerAlpha", objNull], ["_markerName", format ["marker_%1",round random 1000000]]];

private _hasInterface = hasInterface;

private _markerFunctions = [
	// function name without "local", command parameter, use local version
	["setMarkerAlpha", _markerAlpha, _hasInterface],
	["setMarkerType", _markerType, _hasInterface],
	["setMarkerColor", _markerColor, _hasInterface],
	["setMarkerText", _markerText, _hasInterface]
];

private _i = 0;
for [{_i = count _markerFunctions - 1},{_i >= 0},{_i = _i - 1}] do {
	if !(((_markerFunctions # _i) select 1) isEqualTo objNull) exitWith { 
		(_markerFunctions # _i) set [2, true];
	};
};

//-- If headless or if only _markerPos was supplied, use global function 
if (!_hasInterface || {!((_x # 1) isEqualTo objNull)} count _markerFunctions == 0) then {
	_markerName = createMarker [_markerName, _markerPos];
} else {
	_markerName = createMarkerLocal [_markerName, _markerPos];
};

//-- Other parameters besides _markerPos were supplied and marker was created successfully 
if (_markerName != "" && {!((_x # 1) isEqualTo objNull)} count _markerFunctions > 0) then 
{
	//-- Get rid of functions that dont need to be used because the respective parameters weren't set
	_markerFunctions = _markerFunctions select { !((_x # 1) isEqualTo objNull) };
	
	//-- Make the last function in the bunch use the global version if needed
	if !(_hasInterface) then {
		(_markerFunctions select (count _markerFunctions - 1)) set [2, false];
	};
	
	//-- Do work
	{
		_x params ["_functionName", "_functionParameter", "_useLocal"];
		
		private _code = compile format ["%1 %2%3 %4", 
			str _markerName, 
			_functionName, 
			["", "Local"] select _useLocal, 
			[_functionParameter, str _functionParameter] select (_functionParameter isEqualType "")
		]; 
		//copyToClipBoard str _code;
		call _code;
	} forEach _markerFunctions;
};

if (_markerName isEqualTo "") then {
	"Marker name is not unique" call BIS_fnc_error;
};

_markerName
