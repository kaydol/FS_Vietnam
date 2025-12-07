
params ["_player", "_didJIP"];


[] execVM "InitButJIPfriendly.sqf";


if (hasInterface) then 
{
	if (isMultiplayer) then 
	{
		0 cutText ["", "BLACK IN", 100, true, true]; 
		while {time < 3} do {
			sleep 0.1;
			endLoadingScreen;
		};
		
		waitUntil { sleep 0.1; !dialog };
		
		0 cutText ["", "BLACK IN", 20, true, true]; 
	};
	
	[parseText format ["<t font='PuristaBold' size='1.6' color='#FFA500' >%2</t><br />%1", "Group Nigga", "Avengers"], true, nil, 7, 0.7, 0] spawn BIS_fnc_textTiles; 


	//-- Needed for bullet trace framework to work for everyone  
	[] execVM "scripts\BulletTrace.sqf";
	//----------------------------------------------------------

	//-- Give admins a hold-action to become Zeus 
	[] execVM "scripts\AssignSelfAsZeus.sqf";

	//-- Sync players to Zeus
	[] execVM "scripts\SyncToZeusOnRespawn.sqf";
	
	//-- This makes sense only if Respawn Templates contain both "Select Respawn Position" and "Spectator" enabled 
	[] execVM "scripts\MenuPositionWithSpectator.sqf";

	//-- Makes player a support requester as long as they have radio backpack equipped 
	
	//-- Makes player play stand up animation after respawn 
	[] execVM "scripts\StandUpOnRespawn.sqf";
	
	//-- Adds loadout persistency
	//-- Also prevents the hat being shot off the head (for when "goko_bi_patched" addon is installed)
	player execVM "scripts\PersistentLoadout.sqf";
	
	//-- Shows names above player models
	player execVM "scripts\Nametags.sqf"; 
	
};

//-------------------------------------------------------------------------------

// Medic 
if (_player == group_nigga_medic) then 
{
	_player execVM "scripts\MiracleWorker.sqf"; 
	_player execVM "scripts\CanProvideIFAKs.sqf"; 
	_player execVM "scripts\CanSeeHealthbars.sqf"; 
};

// Sniper
if (_player == group_nigga_sniper) then 
{
	_player execVM "scripts\SuperiorAwareness.sqf"; 
	_player execVM "scripts\BulletTrajectory.sqf"; 
	_player execVM "scripts\CanProvideAmmo.sqf"; 
	_player execVM "scripts\AddTeamMapMarkers.sqf"; 
};

// Point Man
if (_player == group_nigga_pointman) then 
{
	_player execVM "scripts\ReduceDamageTaken.sqf"; 
};

// Leader 
if (_player == group_nigga_leader) then 
{
	_player execVM "scripts\ShizaVietCongBehind.sqf";
	_player execVM "scripts\Encourage.sqf"; 
	_player execVM "scripts\RallyPoint.sqf";
	_player execVM "scripts\AddTeamMapMarkers.sqf"; 
	_player execVM "scripts\SelectLeader.sqf";
};

_player execVM "scripts\IAmAFreeBird.sqf"; 
_player execVM "scripts\BananaOfFlight.sqf"; 

[] execVM "scripts\DynamicSupportRequester.sqf";
[] execVM "scripts\VisualSensor.sqf";


//-----------


