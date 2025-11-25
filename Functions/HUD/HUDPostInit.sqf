
#include "..\..\definitions.h"

#define DEF_RSC_TITLE "FS_Vietnam_HUD"
#define DEF_ICON_WIDTH 0.1
#define DEF_ICON_HEIGHT 0.1

#define DEF_TOPMOST_ICON_X 2
#define DEF_TOPMOST_ICON_Y 0
#define DEF_ICON_OFFSET_Y 0.12

#define DEF_INVISIBLE 0
#define DEF_VISIBLE 1

if (!hasInterface) exitWith {};

[] spawn 
{
	waitUntil {sleep 1; !(isNull player) && alive player};
	
	disableSerialization;

	if (isNull( uiNamespace getVariable [DEF_RSC_TITLE, displayNull] )) then 
	{
		(DEF_RSC_TITLE call BIS_fnc_rscLayer) cutRsc [DEF_RSC_TITLE, "PLAIN"];
	};
	
	private _ctrl = objNull;
	private _hudIcons = [];
	
	//==============//
	//	Radio Icon  //
	//==============//
	
	private _fnc_radioIconUpdateTexture = {
		params ["_ctrl"];
		
		if (!isNull DEF_CURRENT_PLAYER) then 
		{
			private _textures = [
				"\FS_Vietnam\Textures\signal_no_signal_icon.paa"
				,"\FS_Vietnam\Textures\signal_receive_icon.paa"
				,"\FS_Vietnam\Textures\signal_transmit_icon.paa"
			];
			
			private _texture = _textures # 0;
			if (DEF_CURRENT_PLAYER call FS_fnc_CanReceive) then { _texture = _textures # 1; };
			if (DEF_CURRENT_PLAYER call FS_fnc_CanTransmit) then { _texture = _textures # 2; };
			
			_ctrl ctrlSetText _texture;
		};
	};
	
	_ctrl = (uiNamespace getVariable DEF_RSC_TITLE) ctrlCreate ["RscPicture", -1];
	_ctrl ctrlSetTextColor [0,0,0, DEF_INVISIBLE];
	_ctrl ctrlCommit 0;
	
	_hudIcons pushBack [
		{true}, // aways visible
		_ctrl,
		_fnc_radioIconUpdateTexture
	];
	
	//================//
	//	Healing Icon  //
	//================//
	
	private _fnc_healingIconIsVisible = { 
		if (isNil {DEF_CURRENT_PLAYER}) exitWith {false};
		if (isNull DEF_CURRENT_PLAYER) exitWith {false};
		((DEF_CURRENT_PLAYER getVariable [DEF_HEALING_GRENADE_EFFECT_ENDS_AT, 0]) - time) > 0
	};
	
	_ctrl = (uiNamespace getVariable DEF_RSC_TITLE) ctrlCreate ["RscPicture", -1];
	_ctrl ctrlSetText "\FS_Vietnam\Textures\healing_icon.paa";
	_ctrl ctrlSetTextColor [0,0,0, DEF_INVISIBLE];
	_ctrl ctrlCommit 0;
	
	_hudIcons pushBack [
		_fnc_healingIconIsVisible,
		_ctrl,
		{}
	];
	
	//=================//
	//	Immortal Icon  //
	//=================//
	
	private _fnc_immortalIconIsVisible = { 
		if (isNil {DEF_CURRENT_PLAYER}) exitWith {false};
		if (isNull DEF_CURRENT_PLAYER) exitWith {false};
		!isDamageAllowed DEF_CURRENT_PLAYER
	};
	
	_ctrl = (uiNamespace getVariable DEF_RSC_TITLE) ctrlCreate ["RscPicture", -1];
	_ctrl ctrlSetText "\FS_Vietnam\Textures\shielded_icon.paa";
	_ctrl ctrlSetTextColor [0,0,0, DEF_INVISIBLE];
	_ctrl ctrlCommit 0;
	
	_hudIcons pushBack [
		_fnc_immortalIconIsVisible,
		_ctrl,
		{}
	];
	
	//============================================
	
	while {sleep 0.5; true} do 
	{
		private _coordX = DEF_TOPMOST_ICON_X;
		private _coordY = DEF_TOPMOST_ICON_Y;
		
		{
			_x params ["_conditionToShow", "_ctrl", "_fnc_ctrlUpdateTexture"];
			
			if (call _conditionToShow) then 
			{
				_ctrl ctrlSetPosition [_coordX, _coordY, DEF_ICON_WIDTH, DEF_ICON_HEIGHT];
				_ctrl ctrlSetTextColor [1,1,1, DEF_VISIBLE];
				_ctrl call _fnc_ctrlUpdateTexture;
				_ctrl ctrlCommit 0;
				
				_coordY = _coordY + DEF_ICON_OFFSET_Y;
			}
			else 
			{
				_ctrl ctrlSetTextColor [0,0,0, DEF_INVISIBLE];
				_ctrl ctrlCommit 0;
			};
			
		} forEach _hudIcons;
	};
};