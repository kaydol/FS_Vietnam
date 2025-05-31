
#include "..\..\definitions.h"

#define DEF_RSC_TITLE "FS_Vietnam_Radio_HUD"

if (!hasInterface) exitWith {};

[] spawn 
{
	disableSerialization;

	if (isNull( uiNamespace getVariable [DEF_RSC_TITLE, displayNull] )) then 
	{
		(DEF_RSC_TITLE call BIS_fnc_rscLayer) cutRsc [DEF_RSC_TITLE, "PLAIN"];
	};

	private _textures = [
		"\FS_Vietnam\Textures\signal_no_signal_icon.paa"
		,"\FS_Vietnam\Textures\signal_receive_icon.paa"
		,"\FS_Vietnam\Textures\signal_transmit_icon.paa"
	];

	private _texture = "";
	private _prevTexture = "";

	_texture = _textures # 0;
	if (DEF_CURRENT_PLAYER call FS_fnc_CanReceive) then { _texture = _textures # 1; };
	if (DEF_CURRENT_PLAYER call FS_fnc_CanTransmit) then { _texture = _textures # 2; };

	_prevTexture = _texture;

	private _ctrl = (uiNamespace getVariable DEF_RSC_TITLE) ctrlCreate ["RscPicture", -1];
	_ctrl ctrlSetPosition [2,0,0.1,0.1];
	_ctrl ctrlSetTextColor [1,1,1,1];
	_ctrl ctrlSetText _texture;
	_ctrl ctrlCommit 0;

	while {true} do 
	{
		sleep 1;
		
		if (!isNull DEF_CURRENT_PLAYER) then 
		{
			_texture = _textures # 0;
			if (DEF_CURRENT_PLAYER call FS_fnc_CanReceive) then { _texture = _textures # 1; };
			if (DEF_CURRENT_PLAYER call FS_fnc_CanTransmit) then { _texture = _textures # 2; };
			
			if (_texture != _prevTexture) then {
				_prevTexture = _texture;
				_ctrl ctrlSetText _texture;
				_ctrl ctrlCommit 0;
			};
		};
	};
};