

/* 
	This function assigns fire missions
*/

params [
	"_caller", 
	"_coordinates", 
	"_estimatedVictims",
	"_supportParams",	
	["_closestFriend", objNull]
];

_side = _caller getVariable ["initSide", side _caller];
_multipleCoordinates = _coordinates isEqualTypeAll [];
_distanceTofriendlies = 1e6;

if !( isNull _closestFriend ) then 
{
	if ( _multipleCoordinates ) exitWith {
		_distanceToFriendlies = [[_closestFriend], _coordinates] call FS_fnc_DistanceBetweenArrays;
	};
	_distanceToFriendlies = _closestFriend distance _coordinates;
};

_supportParams params ["_artilleryThreshold", "_artilleryCD", "_napalmThreshold", "_napalmCD", "_napalmDuration"];

_taskAssigned = False; 

/* FAC Napalm strike */
if ( !_taskAssigned && _estimatedVictims >= _napalmThreshold && _distanceTofriendlies > 150) then 
{
	_params = [];
	if !( _multipleCoordinates ) then {
		/* 	If only one coordinate is supplied, calculate the incoming angle of the airstrike;
			FAC always strikes sideways in relation to the closest friendly unit to minimize 
			the risk of damaging friendly troops */
		_bestAngle = (( [_coordinates, _closestFriend] call BIS_fnc_dirTo ) + 90) % 360;
		_params = [[_coordinates], _bestAngle];
	}  
	else { 
		/* two coordinates are supplied */
		_params = [_coordinates];
	};
	
	_supportName = "NAPALM";
	_supportAvailable = [_side, "FIRETASKS", _supportName] call FS_fnc_GetSideVariable isEqualTo [];
	
	if ( _supportAvailable ) then 
	{
		_params pushBack _napalmDuration;
		_params call FS_fnc_DropNapalm;
		
		// Updating global variable that stores all fire tasks that are in progress
		[_side, "FIRETASKS", [_supportName, [_caller, _target]], _napalmCD] call FS_fnc_UpdateSideVariable;
		// Sending a radio warning
		[_side, "InboundTactical"] remoteExec ["FS_fnc_TransmitOverRadio", 2];
	
		_taskAssigned = True; 
	};
};

/* Artillery */
if ( !_taskAssigned && _estimatedVictims >= _artilleryThreshold && _distanceTofriendlies > 120) then 
{
	if ( _multipleCoordinates ) exitWith {};
	
	_supportName = "ARTILLERY";
	_supportAvailable = [_side, "FIRETASKS", _supportName] call FS_fnc_GetSideVariable isEqualTo [];
	
	if ( _supportAvailable ) then 
	{
		[_coordinates, _estimatedVictims, 50, 1.1, nil, nil, 18, true] spawn FS_fnc_DropMines;
	
		// Updating global variable that stores all fire tasks that are in progress
		[_side, "FIRETASKS", [_supportName, [_caller, _target]], _artilleryCD] call FS_fnc_UpdateSideVariable;
		// Sending a radio warning
		[_side, "InboundArty"] remoteExec ["FS_fnc_TransmitOverRadio", 2];
		
		_taskAssigned = True;
	
	};
};



_taskAssigned

