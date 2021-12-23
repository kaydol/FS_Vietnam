
/* ----------------------------------------------------------------------------
Function: FS_fnc_VisualizeBestPlaces

Description:
	This is a debug function that is used to work with selectBestPlaces command.
	You can use it whenever you want to visualize the results of the expression 
	you want to test. The function does not delete anything that it'd created,
	this is why it's not suited for anything besides testing and debugging.
	
Parameters:
    _pos - Object, Position3D or Position2D
    _expression - STRING: Expression, see https://community.bistudio.com/wiki/Ambient_Parameters 
	_radius - NUMBER: radius of searching.
	_precision - NUMBER: grid size for searching.
	_maxResults - NUMBER: this amount of positions will be drawn.
	
Returns:
    Nothing.

Author:
    kaydol
---------------------------------------------------------------------------- */

#define DEF_HANDLER_VARNAME "VisualizeBestPlaces_HandlerId"
#define DEF_PLACES_VARNAME "VisualizeBestPlaces_Places"
#define DEF_MARKERS_VARNAME "VisualizeBestPlaces_Markers"

params ["_position", "_expression", ["_radius", 50], ["_precision", 1], ["_maxResults", 20]];

private _places = selectBestPlaces [_position, _radius, _expression, _precision, _maxResults];

if (!isNil{missionNameSpace getVariable DEF_HANDLER_VARNAME}) then {
	[DEF_HANDLER_VARNAME, "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
	
	private _markers = missionNameSpace getVariable [DEF_MARKERS_VARNAME, []];
	{ deleteMarker _x } forEach _markers;
	
	missionNameSpace setVariable [DEF_HANDLER_VARNAME, nil];
	missionNameSpace setVariable [DEF_PLACES_VARNAME, nil];
	missionNameSpace setVariable [DEF_MARKERS_VARNAME, nil];
};

private _id = [DEF_HANDLER_VARNAME, "onEachFrame", 
{
	private _places = missionNameSpace getVariable [DEF_PLACES_VARNAME, []];
	{
		_x params ["_pos2D", "_value"];
		
		private _k = 10 / (player distance2D _pos2D);
		
		[1*_k, 1*_k, 0, true, 0.04*_k, "RobotoCondensed", "center", true, 0.005*_k, -0.035*_k] params [
			"_width", 
			"_height", 
			"_angle", 
			"_drawOutline",
			"_textSize", 
			"_font", 
			"_textAlign", 
			"_drawSideArrows", 
			"_offsetX", 
			"_offsetY"
		];
		
		drawIcon3D [
			"\a3\ui_f\data\igui\cfg\simpletasks\types\mine_ca.paa", 
			[1,1,1,1], 
			_pos2D, 
			_width min 2,
			_height min 2, 
			_angle, 
			str _value, 
			_drawOutline, 
			_textSize min 0.15, 
			_font, 
			_textAlign, 
			_drawSideArrows//,
			//_offsetX,
			//_offsetY
		];
		
		drawLine3D [player modelToWorldVisual [0,0,1], _pos2D, [1,0,0,1]];
		
	} forEach _places;
}] call BIS_fnc_addStackedEventHandler;

if (_id != DEF_HANDLER_VARNAME) then {
	//-- Failed to add stacked event handler
	missionNameSpace setVariable [DEF_HANDLER_VARNAME, nil];
	missionNameSpace setVariable [DEF_PLACES_VARNAME, nil];
	missionNameSpace setVariable [DEF_MARKERS_VARNAME, nil];
	
	systemChat "Failed to add stacked event handler";
} else {
	//-- Handler added
	private _markers = [];
	{
		_x params ["_pos2D", "_value"];
		private _marker = [_pos2D, "loc_mine", "ColorRed", str _value] call FS_fnc_CreateDebugMarker;
		_markers pushBack _marker;
	} forEach _places;
	
	missionNameSpace setVariable [DEF_HANDLER_VARNAME, _id];
	missionNameSpace setVariable [DEF_PLACES_VARNAME, _places];
	missionNameSpace setVariable [DEF_MARKERS_VARNAME, _markers];
};

