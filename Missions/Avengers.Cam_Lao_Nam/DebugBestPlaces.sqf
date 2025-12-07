

//-- Places in forest next to trees, far from houses or water
#define DEF_GOOK_MANAGER_TRAPS_BEST_PLACES "(forest + 2*trees) * (1-houses) * (1-sea) * (1-(waterDepth interpolate [0,1,0,100]))"
#define DEF_GOOK_MANAGER_BUILDINGS_BEST_PLACES "(forest + meadow)*(1-trees)*(1-houses)*(1-sea)*(1-(waterDepth interpolate [0,1,0,100]))"
#define DEF_GOOK_MANAGER_VEHICLES_BEST_PLACES "(forest + trees)*(1-trees)*(1-houses)*(1-sea)*(1-(waterDepth interpolate [0,1,0,100]))"

#define DEF_DEBUG_MARKERS_VARIABLE "DebugBestPlaces_Markers"
#define DEF_DEBUG_DRAW3D_EH "DebugBestPlaces_EH"

/*

forest
trees
meadow
hills
houses
sea
coast
night
rain
windy
deadBody
waterDepth


*/

if (isNil{ missionNameSpace getVariable DEF_DEBUG_DRAW3D_EH }) then {

missionNameSpace setVariable [
	DEF_DEBUG_DRAW3D_EH, 
	addMissionEventhandler
	[
		"draw3D",
		{
			{
				//[texture, color, positionAGL, width, height, angle, text, shadow, textSize, font, textAlign, drawSideArrows, offsetX, offsetY]
				drawIcon3D [%1, %2, %3, 1, 1, 0, %4, 0, 0.05];
			}
			forEach (missionNameSpace getVariable [DEF_DEBUG_MARKERS_VARIABLE, []]);
		}
	]
];



};





private _radius = 50;
private _precision = 2;
private _threshold = 0.2;
private _maxResults = 20 min (2 * (_radius / _precision));
private _places = (selectBestPlaces [_coords, _radius, _expression, _precision, _maxResults]) select {_x # 1 >= _threshold};

if !(_places isEqualTo []) then 
{
	_amountToSpawn = _amountToSpawn min (count _places);
	
	private _i = 0;
	for "_i" from 0 to (count _places)-1 do 
	{
		private _pos2D = (_places # _i) # 0;
		private _expr = (_places # _i) # 1;
		
		//-- Check if the topmost point of the object's is visible to _unitsToHideFrom
		private _isPosHidden = true;
		if !(_unitsToHideFrom isEqualTo []) then {
			private _objHeight = _type call _getObjectHeight;
			private _posASL = [_pos2D # 0, _pos2D # 1, (getTerrainHeightASL _pos2D) + _objHeight];
			_isPosHidden = [_posASL, _unitsToHideFrom] call FS_fnc_IsPosHidden;
		};
		
		//-- If hidden, spawn object 
		if (_isPosHidden) then {
			
			
			
			
			
			
			
			
		};
		
		if (_amountToSpawn <= 0) exitWith {};
	};
};



