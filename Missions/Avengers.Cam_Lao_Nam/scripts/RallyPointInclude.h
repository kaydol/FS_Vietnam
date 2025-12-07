
private _fnc_deployRallyPoint = {

	params ["_target", "_caller", "_actionId", "_arguments"];
	
	private _markerName = "";
	private _markerColor = "";
	
	switch (side _caller) do
	{
		case WEST: { _markerName = "respawn_west_rally_point"; _markerColor = "ColorBLUFOR"; };
		case EAST: { _markerName = "respawn_east_rally_point"; _markerColor = "ColorOPFOR"; };
		case INDEPENDENT: { _markerName = "respawn_guerrila_rally_point"; _markerColor = "ColorGUER"; };
		default { /* _markerName = "respawn_civilian_rally_point"; _markerColor = "ColorCIV"; */ };
	};
	
	if (_markerName == "") exitWith {
		/* Tried to deploy rally point while setCaptive == true */
	};
	
	DEF_GLOBAL_VARIABLE_MARKER_NAME = _markerName;
	
	//--------------------------
	
	private _marker = createMarkerLocal [_markerName, getPos _caller];
	if (_marker == "") then {
		// Marker with such name exists. Move existing instead
		_marker = _markerName;
		_marker setMarkerPosLocal (getPos _caller);
	};
	
	_marker setMarkerTypeLocal "mil_flag";
	_marker setMarkerColorLocal _markerColor;
	_marker setMarkerText "Rally Point";
	
	//--------------------------
	
	if (!isNil{ respawn_west_rally_point_flagpole }) then {
		respawn_west_rally_point_flagpole setVehiclePosition [getPos _caller, [], 1, "NONE"];
	};
	
	//--------------------------
	
	_markerName = "rally_point_vanity_marker_1";
	
	private _marker = createMarkerLocal [_markerName, getPos _caller];
	if (_marker == "") then {
		// Marker with such name exists. Move existing instead
		_marker = _markerName;
		_marker setMarkerPosLocal (getPos _caller);
	};
	
	_marker setMarkerBrushLocal "Border";
	_marker setMarkerShapeLocal "ELLIPSE";
	_marker setMarkerSizeLocal [10, 10];
	
	_marker setMarkerColor _markerColor;
	
	//-------------------------
	
	_markerName = "rally_point_vanity_marker_2";
	
	private _marker = createMarkerLocal [_markerName, getPos _caller];
	if (_marker == "") then {
		// Marker with such name exists. Move existing instead
		_marker = _markerName;
		_marker setMarkerPosLocal (getPos _caller);
	};
	
	_marker setMarkerBrushLocal "Border";
	_marker setMarkerShapeLocal "ELLIPSE";
	_marker setMarkerSizeLocal [DEF_MIN_DISTANCE_MOVED_TO_DROP_RALLY, DEF_MIN_DISTANCE_MOVED_TO_DROP_RALLY];
	_marker setMarkerColor "colorRed";
	
	[_caller, "rally_point_dropped"] remoteExec ["say3D", 0];
	"Rally Point was relocated" remoteExec ["systemChat", 0];
	
};