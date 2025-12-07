
#define DEF_DEBUG false  


if !(player diarySubjectExists "Readme") then 
{
	player createDiarySubject ["Readme","Your abilities"];
	player setDiarySubjectPicture ["Readme","Your abilities"];
};

player createDiaryRecord ["Readme", ["Radio Man", "<br/>Your radio backpack allows you to request support.<br/><br/>The access to support is removed if you unequip the backpack.<br/><br/>"]];

//--

private _code = {
	params ["_unit", "_targetContainer"];
	
	//-- Requester check
	private _supportRequesters = allMissionObjects "SupportRequester";
	if (_supportRequesters isEqualTo []) exitWith {
		"No Support Requester modules found" call BIS_fnc_error;
	};
	if (count _supportRequesters > 1) exitWith {
		"Multiple Support Requester modules found" call BIS_fnc_error;
	};
	private _supportRequesterModule = _supportRequesters # 0;
	
	//-- Provider check 
	private _supportProviders = allMissionObjects "SupportProvider_Artillery";
	if (_supportProviders isEqualTo []) exitWith {
		"No Support Provider modules found" call BIS_fnc_error;
	};
	if (count _supportProviders > 1) exitWith {
		"Multiple Support Provider modules found" call BIS_fnc_error;
	};
	private _supportProviderModule = _supportProviders # 0;
	
	//-- Syncing 
	if (_unit call FS_fnc_CanTransmit) then 
	{
		[_unit, _supportRequesterModule, _supportProviderModule] call BIS_fnc_addSupportLink;
		
		if (DEF_DEBUG) then {
			systemChat "Synced to Support Requester";
		};
	} 
	else 
	{
		[_unit, _supportRequesterModule, _supportProviderModule] call BIS_fnc_removeSupportLink;
		
		if (DEF_DEBUG) then {
			systemChat "Desynced from Support Requester";
		};
	};
};


player addEventHandler ["InventoryClosed", _code];

player call _code; 

