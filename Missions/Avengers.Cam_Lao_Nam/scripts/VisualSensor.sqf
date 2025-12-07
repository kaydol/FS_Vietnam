
#define DEF_HUD_SLEEP 0.3
#define DEF_HUD_RANGE 200
#define DEF_HUD_HELMETS ["vnx_b_helmet_aph6_02_06"]

#define DEF_ZEUS_DISPLAY_ID 312

#define DEF_NEAR_UNITS_VAR FS_Helmet_Targets

#define DEF_ICON_VEHICLE "FS_Vietnam\Textures\HUD_Target_Vehicle.paa"
#define DEF_ICON_VEHICLE_SIZE 0.6
#define DEF_ICON_EMPLACEMENT "FS_Vietnam\Textures\HUD_Target_Emplacement.paa"
#define DEF_ICON_EMPLACEMENT_SIZE 0.4
#define DEF_ICON_HUMAN "FS_Vietnam\Textures\HUD_Target_Human.paa"
#define DEF_ICON_HUMAN_SIZE 0.3
#define DEF_ICON_GRENADE "FS_Vietnam\Textures\HUD_Target_Grenade.paa"
#define DEF_ICON_GRENADE_SIZE 2.2

#define DEF_ICON_COLOR_RED [1,0,0,1]
#define DEF_ICON_COLOR_NEUTRAL [1,1,0,1]
#define DEF_ICON_COLOR_ENEMY [1,0,0,1]
#define DEF_ICON_COLOR_GROUP [0.15,0.5,1,1]
#define DEF_ICON_COLOR_FRIENDLY [0.1,1,0.5,1]

["TARGETING_HUD", "onEachFrame",
{
	if (toLowerANSI headgear player in (DEF_HUD_HELMETS apply {toLowerANSI _x}) && isNull(findDisplay DEF_ZEUS_DISPLAY_ID)) then 
	{
		{
			private _unit = _x;
			if !(isObjectHidden _unit) then 
			{
				private _distance = positionCameraToWorld [0,0,0] distance _unit;
				private _icon = "";
				private _size = 0;
				private _color = [0,0,0,0];
				private _sideUnit = side _unit;
				private _sidePlayer = side player;
				private _hostileCheck = _sidePlayer getFriend _sideUnit;
				private _fov = getObjectFOV vehicle player;
				private _pos = [0,0,0];

				if (_unit isKindof "MAN") then 
				{
					_pos = _unit modelToWorldVisual (_unit selectionPosition "spine3");
					if (_sideUnit == civilian OR lifeState _unit == "INCAPACITATED") then {
						_color = DEF_ICON_COLOR_NEUTRAL;
					} 
					else 
					{
						if (_hostileCheck < 0.6) then {
							_color = DEF_ICON_COLOR_ENEMY;
						} 
						else 
						{
							if (group player isEqualTo group _unit) then {
								_color = DEF_ICON_COLOR_GROUP;
							} else {
								_color = DEF_ICON_COLOR_FRIENDLY;
							};
						};
					};
					
					_icon = DEF_ICON_HUMAN;
					_size = (DEF_ICON_HUMAN_SIZE / tan(_fov /2) / _distance) max 0.5;
				} 
				else 
				{
					if (_sideUnit == civilian OR lifeState _unit == "INCAPACITATED") then {
						_color = DEF_ICON_COLOR_NEUTRAL;
					} 
					else 
					{
						if (_hostileCheck < 0.6) then {
							_color = DEF_ICON_COLOR_ENEMY;
						} else {
							if (group player isEqualTo group _unit) then {
								_color = DEF_ICON_COLOR_GROUP;
							} else {
								_color = DEF_ICON_COLOR_FRIENDLY;
							};
						};
					};
					if (_unit isKindof "StaticWeapon") then {
						_pos = _unit modelToWorldVisual (_unit selectionPosition ["osahlavne", "Memory"]);
						_icon = DEF_ICON_EMPLACEMENT;
						_size = (DEF_ICON_EMPLACEMENT_SIZE / tan(_fov /2) / _distance) max 0.5;
					}
					else
					{
						_pos = _unit modelToWorldVisual (_unit selectionPosition ["zamerny", "Memory"]);
						_icon = DEF_ICON_VEHICLE;
						_size = (DEF_ICON_VEHICLE_SIZE / tan(_fov /2) / _distance) max 0.5;
					};
				};
				drawIcon3D [_icon,_color,_pos,_size,_size,0,"",0,0.04,"RobotoCondensed","center",false];
			};
		}
		forEach DEF_NEAR_UNITS_VAR;

		private _grenades = nearestObjects [player,["Grenade"], 30];
		{
			drawIcon3D [DEF_ICON_GRENADE, DEF_ICON_COLOR_RED, getPosATLVisual _x, DEF_ICON_GRENADE_SIZE, DEF_ICON_GRENADE_SIZE, 0,"",0,0.04,"RobotoCondensed","center",true];   
		} forEach _grenades;
	};
}] call BIS_fnc_addStackedEventHandler;


while {true} do 
{
	while {toLowerANSI headgear player in (DEF_HUD_HELMETS apply {toLowerANSI _x})} do 
	{
		private _nearUnits = nearestObjects [player, ["MAN","CAR","TANK","AIR","StaticWeapon"], DEF_HUD_RANGE, true];
	   
		DEF_NEAR_UNITS_VAR = _nearUnits select {
			private _unitBlocked = lineIntersects [eyePos player, eyePos _x, player, _x] OR terrainIntersectASL [eyepos player, eyepos _x];
			alive _x && vehicle _x != vehicle player && !_unitBlocked;
		};
		
		sleep DEF_HUD_SLEEP;
	};
	sleep 3;
};
