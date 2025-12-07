scriptName "3Dmarkers.sqf";
/*
	Version - 1.0
	
	Shows all user placed map markers as icons on the screen, icons can be toggled on and off by pressing Y.
	MUST be executed on mission start in order to work correctly.
	
	Examples of usage:
	
	init.sqf -
		nul = [] execVM "3Dmarkers.sqf";
	
	or
	
	description.ext -
		class params
		{
			class marker3D
			{
				title = "3D markers";
				values[] = {0,1};
				texts[] = {$STR_DISABLED,$STR_ENABLED};
				default = 1;
				isGlobal = 1;		
				file = "3Dmarkers.sqf";
			};
		};
	
	known issues:
		- not synced properly for JIP's
		- needs to be run on mission start to work properly
*/

#include "\a3\editor_f\data\scripts\dikCodes.h"

if (isDedicated) exitWith {};
if (([_this, 0, 1, [1]] call BIS_fnc_param) == 0) exitWith {};

///////////////////////////////////////////////////////////////editable parameters//////////////////////////////////////////////////////////////////////

BH_fnc_mkr3D_toggleKey = DIK_Y; //replace with whatever key you want to use for showing/hiding 3D markers in game. DIK code macros are provided.

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

waitUntil {(!isNull player) && (player == player)};

with uiNamespace do
{
	BH_fnc_mkr3D_logGrp_global = [];
	BH_fnc_mkr3D_logGrp = [];

	BH_fnc_mkr3D_logGrp_west = [];
	BH_fnc_mkr3D_logGrp_east = [];
	BH_fnc_mkr3D_logGrp_ind = [];
	BH_fnc_mkr3D_logGrp_civ = [];

	BH_fnc_mkr3D_logGrp_dir = [];
	BH_fnc_mkr3D_logGrp_veh = [];
	BH_fnc_mkr3D_logGrp_grp = [];
	BH_fnc_mkr3D_logGrp_com = [];
};

FS_fnc_GroupMarkers = {
	private ["_group", "_mkrtype", "_marker", "_this", "_x"];
	_group = _this select 0;
	_mkrtype = _this select 1;
	{
		_marker = createMarkerLocal [str(round random(1000000)), getPos _x];
		_marker setMarkerTypeLocal _mkrtype;
		
		[_x, _marker] spawn 
		{
			[_this select 1, _this select 0] spawn FS_fnc_WH;
			while {alive (_this select 0)} do {
				(_this select 1) setMarkerPosLocal getPos (_this select 0); 
				sleep 0.05;
			};
			deleteMarkerLocal (_this select 1);
		};
		sleep 0.5;
	}
	forEach units _group;
};

FS_getWHIconSize = {
	if (_this < 50) exitWith {0.85}; 
	(42.5 / _this)
};

FS_fnc_WH =
{
	if (isDedicated) exitWith {};
	if !(missionNameSpace getVariable ["PERK_WH", FALSE]) exitWith {};
	
	private ["_path", "_pos", "_text", "_markers", "_marker", "_cfg", "_colour", "_index", "_name", "_type", "_grp", "_array", "_data"];
	
	_marker = _this select 0;
	_bindedObject = _this select 1;
	
	_cfg = configFile >> "cfgMarkers" >> markerType _marker;
	_path = getText (_cfg >> "texture");
	
	_pos = getMarkerPos _marker;
	
	_colour = [(profilenamespace getvariable ['Map_OPFOR_R',0]),(profilenamespace getvariable ['Map_OPFOR_G',1]),(profilenamespace getvariable ['Map_OPFOR_B',1]),(profilenamespace getvariable ['Map_OPFOR_A',0.8])];
	
	_logic = "logic" createVehicleLocal _pos;
	
	_data = [] call BH_fnc_mkr3D_VON;
	_grp = _data select 1;
	_type = _data select 2;
	
	_array = uiNamespace getVariable _grp;
	
	_index = count _array;
	_array set [_index, _logic];
	
	uiNamespace setVariable [_grp, _array];
	
	_name = format ["BH_mkr3D_log_%1_%2", _type, _index];
	
	_logic setVehicleVarName _name;
	uiNamespace setVariable [_name, _logic];

	_code = format ['uiNamespace getVariable %1', str _name];
	
	_logic setVariable
	[
		"BH_UserMkr_EH",
		addMissionEventhandler
		[
			"draw3D",
			compile format
			[
				'
					if (count (toArray (getMarkerColor %3)) > 0) then
					{
						if (uiNamespace getVariable ["BH_fnc_mkr3D_show", true]) then
						{
							drawIcon3D
							[
								%1,
								%2,
								[getMarkerPos %3 select 0, getMarkerPos %3 select 1, 2.8],
								/*0.85,*/ (player distance getMarkerPos %3) call FS_getWHIconSize,
								/*0.85,*/ (player distance getMarkerPos %3) call FS_getWHIconSize,
								0,
								str(round (player distance getMarkerPos %3)),
								0,
								0.035
							];
						};
					}
					else
					{
						_obj = %4;
						
						if (isNull _obj) exitWith {};
						
						_type = (_obj getVariable "BH_UserMkr_Array");
						_array = uiNamespace getVariable _type;
						
						_index = _array find _obj;
						_array set [_index, objNull];
						uiNamespace setVariable [_type, _array];
						
						removeMissionEventhandler ["draw3D", _obj getVariable "BH_UserMkr_EH"];
						deleteVehicle _obj;
					};
				',
				str _path,
				_colour,
				str _marker,
				_code
			]
		]
	];
	
	_logic setVariable
	[
		"BH_UserMkr_ID",
		_marker
	];
	
	_logic setVariable
	[
		"BH_UserMkr_Array",
		_grp
	];
};



BH_fnc_mkr3D =
{
	if (isDedicated) exitWith {};
	private ["_path", "_pos", "_text", "_markers", "_marker", "_cfg", "_colour", "_index", "_name", "_type", "_grp", "_array", "_data"];
	
	_path = _this select 0;
	_text = _this select 1;
	_markers = _this select 2;
	
	_marker = allMapMarkers - _markers;
	if (count _marker > 1) exitWith {};
	_marker = [_marker, 0, ""] call BIS_fnc_param;
	
	_pos = getMarkerPos _marker;
	
	_cfg = _path call
	{
		private ["_return"];
		
		_return = configFile >> "cfgMarkers";
		
		{
			if ((getText (_x >> "icon")) == _this) exitWith {_return = _x};
		} forEach BH_fnc_mkr3D_cfgMarkers;
		
		_return
	};
	
	_colour = getArray (_cfg >> "color");
	if (count _colour == 0) then {_colour = [1,1,1,1]};
	
	_logic = "logic" createVehicleLocal _pos;
	
	_data = [] call BH_fnc_mkr3D_VON;
	_grp = _data select 1;
	_type = _data select 2;
	
	_array = uiNamespace getVariable _grp;
	
	_index = count _array;
	_array set [_index, _logic];
	
	uiNamespace setVariable [_grp, _array];
	
	_name = format ["BH_mkr3D_log_%1_%2", _type, _index];
	
	_logic setVehicleVarName _name;
	uiNamespace setVariable [_name, _logic];

	_code = format ['uiNamespace getVariable %1', str _name];
	
	_logic setVariable
	[
		"BH_UserMkr_EH",
		addMissionEventhandler
		[
			"draw3D",
			compile format
			[
				'
					if (count (toArray (getMarkerColor %5)) > 0) then
					{
						if (uiNamespace getVariable ["BH_fnc_mkr3D_show", true]) then
						{
							drawIcon3D
							[
								%1,
								%2,
								%3,
								1,
								1,
								0,
								%4,
								0,
								0.05
							];
						};
					}
					else
					{
						_obj = %6;
						
						if (isNull _obj) exitWith {};
						
						_type = (_obj getVariable "BH_UserMkr_Array");
						_array = uiNamespace getVariable _type;
						
						_index = _array find _obj;
						_array set [_index, objNull];
						uiNamespace setVariable [_type, _array];
						
						removeMissionEventhandler ["draw3D", _obj getVariable "BH_UserMkr_EH"];
						deleteVehicle _obj;
					};
				',
				str _path,
				_colour,
				_pos,
				str _text,
				str _marker,
				_code
			]
		]
	];
	
	_logic setVariable
	[
		"BH_UserMkr_ID",
		_marker
	];
	
	_logic setVariable
	[
		"BH_UserMkr_Array",
		_grp
	];
};

BH_fnc_mkr3D_VON =
{
	private ["_r"];
	
	if (isDedicated) exitWith {};
	
	_r = switch (uiNamespace getVariable ['VON_curSelChannel', '']) do
	{
		case localize "str_channel_global" : {[true, "BH_fnc_mkr3D_logGrp_global", 0]};
		case localize "str_channel_side" : 
		{
			[
				side player, 
				switch (side player) do
				{
					case west: {"BH_fnc_mkr3D_logGrp_west"};
					case east: {"BH_fnc_mkr3D_logGrp_east"};
					case resistance: {"BH_fnc_mkr3D_logGrp_ind"};
					case civilian: {"BH_fnc_mkr3D_logGrp_civ"};
				},
				1
			]
		};
		case localize "str_channel_command" : {[player, "BH_fnc_mkr3D_logGrp_com", 2]};
		case localize "str_channel_group" : {[group player, "BH_fnc_mkr3D_logGrp_grp", 3]};
		case localize "str_channel_vehicle" : {[crew vehicle player, "BH_fnc_mkr3D_logGrp_veh", 4]};
		case localize "str_channel_direct" : {[player, "BH_fnc_mkr3D_logGrp_dir", 5]};
		default {[player, "BH_fnc_mkr3D_logGrp_dir", 5]};
	};
	
	_r
};

disableSerialization;

waitUntil {!isNull ([] call BIS_fnc_displayMission)};

BH_fnc_mkr3D_cfgMarkers = [(configFile >> "cfgMarkers")] call BIS_fnc_subClasses;

uiNamespace setVariable ["VON_curSelChannel", (localize "str_channel_group")];
uiNamespace setVariable ["BH_fnc_mkr3D_show", true];

_map = (findDisplay 12) displayCtrl 51;

[] spawn
{
	private ["_display"];
	
	disableSerialization;
	
	while {true} do
	{
		sleep 0.1;
		
		if (!isNull (findDisplay 63)) then
		{
			_display = findDisplay 63;
			_text = ctrlText (_display displayCtrl 101);
			
			uiNamespace setVariable ["VON_curSelChannel", _text];
		};
	};
};

([] call BIS_fnc_displayMission) displayAddEventhandler
[
	"keydown",
	{
		if ((_this select 1) == BH_fnc_mkr3D_toggleKey) then  //default DIK_Y (0x15)
		{
			_toggle = !(uiNamespace getVariable "BH_fnc_mkr3D_show");
			uiNamespace setVariable ["BH_fnc_mkr3D_show", _toggle];
			
			_layer = "BH_marker3D_indic" call BIS_fnc_rscLayer;
			_layer cutRsc ["RscDynamicText", "PLAIN"];
			
			_ctrl = (uiNamespace getVariable "BIS_dynamicText") displayCtrl 9999;
			
			_ctrl ctrlSetPosition
			[
				0.4 * safezoneW + safezoneX,
				0.05 * safezoneH + safezoneY,
				0.2 * safezoneW,
				0.05 * safezoneH
			];
			
			_ctrl ctrlCommit 0;
			
			_format = if (_toggle) then {"on"} else {"off"};
			
			_text = format
			[
				"<t align = 'center' shadow = '0' size = '0.7'>3D markers: %1</t>",
				_format
			];
			
			_ctrl ctrlSetStructuredText parseText _text;
			
			_ctrl ctrlSetFade 1;
			_ctrl ctrlCommit 2;
		};
	}
];

_map ctrlAddEventHandler
[
	"MouseButtonDblClick",
	{
		_this spawn
		{
			disableSerialization;
			
			waitUntil {!isNull (findDisplay 54)}; //RscDisplayInsertMarker
			_display = findDisplay 54;

			_display displayAddEventhandler
			[
				"unload",
				{
					disableSerialization;
					
					_display = _this select 0;
					//_map = (findDisplay 12) displayCtrl 51;
					
					if ((_this select 1) == 1) then
					{
						_path = ctrlText (_display displayCtrl 102);
						_text = ctrlText (_display displayCtrl 101);
						
						_params = [_path, _text, allMapMarkers];
						
						[
							_params,
							'BH_fnc_mkr3D',
							([] call BH_fnc_mkr3D_VON) select 0,
							false,
							false
						] spawn BIS_fnc_MP;
					};
				}
			]
		};
		false
	}
];