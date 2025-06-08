

/* 
	This function assigns fire missions
*/

#include "..\..\definitions.h"

params [
	"_aircraft", 
	"_coordinates", 
	"_estimatedVictims",
	"_supportParams",	
	["_closestFriend", objNull],
	["_debug", false, [true]]
];

private _side = _aircraft getVariable ["initSide", side _aircraft];
private _multipleCoordinates = _coordinates isEqualTypeAll [];
private _distanceTofriendlies = 1e6;

if !( isNull _closestFriend ) then 
{
	if ( _multipleCoordinates ) exitWith {
		_distanceToFriendlies = [[_closestFriend], _coordinates] call FS_fnc_DistanceBetweenArrays;
	};
	_distanceToFriendlies = _closestFriend distance _coordinates;
};

_supportParams params ["_artilleryThreshold", "_artilleryCD", "_napalmThreshold", "_napalmCD"];

private _taskAssigned = False; 

/* FAC Napalm strike */
if ( !_taskAssigned && _estimatedVictims >= _napalmThreshold && _distanceTofriendlies > SUPPORT_MINDISTANCE_NAPALM) then 
{
	private _params = [];
	if !( _multipleCoordinates ) then {
		/* 	If only one coordinate is supplied, calculate the incoming angle of the airstrike;
			FAC always strikes sideways in relation to the closest friendly unit to minimize 
			the risk of damaging friendly troops */
		private _bestAngle = (( [_coordinates, _closestFriend] call BIS_fnc_dirTo ) + 90) % 360;
		_params = [_coordinates, _bestAngle]; 
	}
	else { 
		/* two coordinates are supplied */
		_params = _coordinates;
	};
	
	private _supportName = "NAPALM";
	private _supportAvailable = [_side, "FIRETASKS", _supportName] call FS_fnc_GetSideVariable isEqualTo [];
	
	if ( _supportAvailable ) then 
	{
		_params set [count _params, _debug]; 
		_params call FS_fnc_DropNapalm;
		
		//-- Update last time the support was used
		[_side, "FIRETASKS", [format["%1_LAST_TIME", _supportName], time]] call FS_fnc_UpdateSideVariable;
		
		// Updating global variable that stores all fire tasks that are in progress
		[_side, "FIRETASKS", [_supportName, [_aircraft, _target]], _napalmCD] call FS_fnc_UpdateSideVariable;
		
		if (_closestFriend isNotEqualTo objNull) then 
		{
			private _relativeDir = _closestFriend getDir (_params # 0);
			private _messageType = "";
			
			if ((_relativeDir >= 337.5 && _relativeDir <= 360) || 
			    (_relativeDir >= 0 && _relativeDir < 22.5)) then { _messageType = "napalm_north" };
			if (_relativeDir >= 22.5 && _relativeDir < 67.5) then { _messageType = "napalm_north_east" };
			if (_relativeDir >= 67.5 && _relativeDir < 112.5) then { _messageType = "napalm_east" };
			if (_relativeDir >= 112.5 && _relativeDir < 157.5) then { _messageType = "napalm_south_east" };
			if (_relativeDir >= 157.5 && _relativeDir < 202.5) then { _messageType = "napalm_south" };
			if (_relativeDir >= 202.5 && _relativeDir < 247.5) then { _messageType = "napalm_south_west" };
			if (_relativeDir >= 247.5 && _relativeDir < 292.5) then { _messageType = "napalm_west" };
			if (_relativeDir >= 292.5 && _relativeDir < 337.5) then { _messageType = "napalm_north_west" };
			
			// Sending a radio warning
			[_side, _aircraft getVariable DEF_RADIO_TRANSMISSION_PREFIX_VAR, _messageType] remoteExec ["FS_fnc_TransmitOverRadio", 2];
		};
		
		_taskAssigned = True; 
	} 
	else 
	{
		if (_debug) then {
			diag_log format ["Pilot: A suitable target for NAPALM strike exists, but support was on cooldown"];
		};
	};
};

/* Artillery */
if ( !_taskAssigned && _estimatedVictims >= _artilleryThreshold && _distanceTofriendlies > SUPPORT_MINDISTANCE_ARTILLERY) then 
{
	if ( _multipleCoordinates ) exitWith {};
	
	private _supportName = "ARTILLERY";
	private _supportAvailable = [_side, "FIRETASKS", _supportName] call FS_fnc_GetSideVariable isEqualTo [];
	
	if ( _supportAvailable ) then 
	{
		[_coordinates, 2, 50, nil, nil, 18, _debug] spawn FS_fnc_DropMines;
		
		//-- Update last time the support was used
		[_side, "FIRETASKS", [format["%1_LAST_TIME", _supportName], time]] call FS_fnc_UpdateSideVariable;
		
		// Updating global variable that stores all fire tasks that are in progress
		[_side, "FIRETASKS", [_supportName, [_aircraft, _target]], _artilleryCD] call FS_fnc_UpdateSideVariable;
		
		if (_closestFriend isNotEqualTo objNull) then 
		{
			private _relativeDir = _closestFriend getDir (_params # 0);
			private _messageType = "";
			
			if ((_relativeDir >= 337.5 && _relativeDir <= 360) || 
			    (_relativeDir >= 0 && _relativeDir < 22.5)) then { _messageType = "arty_north" };
			if (_relativeDir >= 22.5 && _relativeDir < 67.5) then { _messageType = "arty_north_east" };
			if (_relativeDir >= 67.5 && _relativeDir < 112.5) then { _messageType = "arty_east" };
			if (_relativeDir >= 112.5 && _relativeDir < 157.5) then { _messageType = "arty_south_east" };
			if (_relativeDir >= 157.5 && _relativeDir < 202.5) then { _messageType = "arty_south" };
			if (_relativeDir >= 202.5 && _relativeDir < 247.5) then { _messageType = "arty_south_west" };
			if (_relativeDir >= 247.5 && _relativeDir < 292.5) then { _messageType = "arty_west" };
			if (_relativeDir >= 292.5 && _relativeDir < 337.5) then { _messageType = "arty_north_west" };
			
			// Sending a radio warning
			[_side, _aircraft getVariable DEF_RADIO_TRANSMISSION_PREFIX_VAR, _messageType] remoteExec ["FS_fnc_TransmitOverRadio", 2];
		};
		
		_taskAssigned = True;
	}
	else 
	{
		if (_debug) then {
			diag_log format ["Pilot: A suitable target for ARTILLERY strike exists, but support was on cooldown"];
		};
	};
};

_taskAssigned

