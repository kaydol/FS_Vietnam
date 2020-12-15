
/*
	This function manages 3DEN draw3D event handlers 
	that visualize the area of the module (if _drawMode == "Logic") 
	or areas around synced objects (if _drawMode == "Synced")
*/

params ["_mode", "_input", ["_drawMode", "Logic"]];

_logic = _input param [0,objNull,[objNull]];

_logic setVariable ["DrawMode", _drawMode];

switch _mode do 
{
	// Default object init
	case "init": 
	{
		//	After the game was started, the Draw3D EH should not be visible anymore
		//	Removing Draw3D EventHandler
		if !( isNil { TG_VMR_EH } ) then {
			if !( TG_VMR_EH isEqualTo "" ) then {
				[TG_VMR_EH, "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
			};
			TG_VMR_EH = nil;
		};
		if !( isNil { TG_VMR_ARRAY } ) then {
			TG_VMR_ARRAY resize 0;
			TG_VMR_ARRAY = nil;
		};
	};
	
	// When removed from the world (i.e., by deletion or undoing creation)
	case "unregisteredFromWorld3DEN": 
	{
		//	Removing this logic from the list serviced by Draw3D EH
		if ( isNil { TG_VMR_ARRAY }) then {
			TG_VMR_ARRAY = [];
		};
		_index = TG_VMR_ARRAY findIf { _x isEqualTo _logic };
		if ( _index >= 0 ) then {
			TG_VMR_ARRAY set [_index, nil];
			TG_VMR_ARRAY = TG_VMR_ARRAY arrayIntersect TG_VMR_ARRAY; //	removes nils
		};
	};
	
	default 
	{
		_fieldRadius = _logic getVariable "Radius";
		
		//	Adding this logic to the list serviced by Draw3D EH
		if ( isNil { TG_VMR_ARRAY }) then {
			TG_VMR_ARRAY = [];
		};
		_index = TG_VMR_ARRAY findIf { _x isEqualTo _logic };
		if ( _index < 0 && _fieldRadius > 0 ) then {
			TG_VMR_ARRAY pushBack _logic;
		};
		
		//	Creating the Draw3D EH that will serve all the logics
		if ( isNil { TG_VMR_EH } ) then {
			TG_VMR_EH = "";
		};
		
		//	Add draw3D EH if there were none
		if ( TG_VMR_EH isEqualTo "" ) then 
		{
			//	Code that calculates circles for all mission placed modules and then draws them all. 
			// If _drawMode == "Logic" then the circles are drawn around the logic
			// If _drawMode == "Synced" then the circles are drawn around the objects synced to the logic
			_code = {
				_circles = [];
				{
					_logi = _x;
					_fieldRadius = _logi getVariable "Radius";
					_drawMode = _logi getVariable "DrawMode";
					_synced = [];
					
					if ( _drawMode == "Logic" ) then {
						_synced = [_logi];
					};
					if ( _drawMode == "Synced" ) then {
						_synced = (( get3DENConnections _logi ) select { _x # 0 == "Sync" } ) apply { _x # 1 };
					};
					
					{
						_connectedEntity = _x;
						_corners = [];
						_cornersCount = 20;
						_turnAngle = 360 / _cornersCount;
						_i = 0;
						for [{_i = 0},{_i < _cornersCount},{_i = _i + 1}] do {
							_pos = _connectedEntity getPos [_fieldRadius, _i * _turnAngle];
							_pos set [2, 0.25];
							_corners pushBack _pos;
						};
						_circles pushBack _corners;
					}
					forEach _synced;
				}
				forEach TG_VMR_ARRAY;
				
				{
					_size = count _x;
					for [{_i = 0},{_i < _size},{_i = _i + 1}] do {
						drawLine3D [_x # _i, _x # (( _i + 1 ) % _size ), [1,1,0,1]];
					};
				} 
				forEach _circles;		
			};
			TG_VMR_EH = ["TG_VMR_EH", "onEachFrame", _code] call BIS_fnc_addStackedEventHandler;
			if ( TG_VMR_EH isEqualTo "" ) then {
				//	failed to add stacked event handler...
			};
		};
	};
};
