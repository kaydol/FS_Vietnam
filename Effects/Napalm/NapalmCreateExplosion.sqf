

#define NAPALM_BURN_SOUNDS ["furnal_1", "furnal_2"]
#define DEATH_SOUNDS ["napalm_death_1", "napalm_death_2", "napalm_death_3", "napalm_death_4"]

params ["_pos"];

// Initializing default values
if (isNil{ NAPALM_BOMB_RADIUS }) then 
{
	NAPALM_BOMB_RADIUS = getNumber (ConfigFile >> "CfgVehicles" >> "FS_NapalmSettings_Module" >> "Attributes" >> "NapalmBombRadius" >> "defaultValue");
	NAPALM_LIFE_TIME = getNumber (ConfigFile >> "CfgVehicles" >> "FS_NapalmSettings_Module" >> "Attributes" >> "NapalmLifeTime" >> "defaultValue");
	NAPALM_DAMAGE = getNumber (ConfigFile >> "CfgVehicles" >> "FS_NapalmSettings_Module" >> "Attributes" >> "NapalmDamage" >> "defaultValue");
	NAPALM_TICK_RATE = getNumber (ConfigFile >> "CfgVehicles" >> "FS_NapalmSettings_Module" >> "Attributes" >> "NapalmTickRate" >> "defaultValue");
	NAPALM_VICTIMS_SCREAM = getNumber (ConfigFile >> "CfgVehicles" >> "FS_NapalmSettings_Module" >> "Attributes" >> "MakeVictimsScream" >> "defaultValue") == 1;
	NAPALM_VICTIMS_SMOKE_TIME = getNumber (ConfigFile >> "CfgVehicles" >> "FS_NapalmSettings_Module" >> "Attributes" >> "VictimsSmokeTime" >> "defaultValue");
	NAPALM_SPAWN_CRATER = getNumber (ConfigFile >> "CfgVehicles" >> "FS_NapalmSettings_Module" >> "Attributes" >> "SpawnCrater" >> "defaultValue") == 1;
	NAPALM_DELETE_VEGETATION = getNumber (ConfigFile >> "CfgVehicles" >> "FS_NapalmSettings_Module" >> "Attributes" >> "DeleteVegetation" >> "defaultValue") == 1;
};

private _anchor = "#particlesource" createVehicleLocal _pos; 

if (isServer) then {
	[getPosATL _anchor] spawn FS_fnc_NapalmPhosphorusStrands; 
};

if (hasInterface) then 
{
	/* Making the men inside the bomb impact radius scream */
	if (NAPALM_VICTIMS_SCREAM || NAPALM_VICTIMS_SMOKE_TIME > 0) then 
	{
		private _victims = _pos nearEntities ["MAN", NAPALM_BOMB_RADIUS];
		{
			// Only do screams for EAST units, because as of now we only have vietnamese screams
			_deathSound = if (side _x == EAST) then [{selectRandom DEATH_SOUNDS},{""}];
			[_x, _deathSound, NAPALM_LIFE_TIME] spawn FS_fnc_NapalmBurnedAlive;
		}
		forEach _victims;
	};
	
	/* Play explosion sound */
	// this was transferred into config instead
	//_anchor say3D [selectRandom EXPLOSION_SOUNDS, 2000];
	
	/* Local Effects */
	[getPosATL _anchor] spawn FS_fnc_NapalmPuffAndSparks;
	[0.01,0.3 + random 1,[_pos, 400]] spawn FS_fnc_ShakeCam; // Camera shake
	[_anchor] spawn 
	{
		params ["_anchor"];
		sleep 2;
		[getPosATL _anchor, NAPALM_BOMB_RADIUS * 0.7, NAPALM_LIFE_TIME] spawn FS_fnc_NapalmAfterEffect;
		
		/* Play fire sound */
		_anchor spawn {
			while {!isNull _this} do {
				_sound = selectRandom NAPALM_BURN_SOUNDS;
				_this Say3D [_sound, 2000];
				sleep 10;	
			};
		};
	};
	
	// Only run this part if the client hasInterface and not a server
	// Server removes _anchor separately from clients
	if (!isServer) then {
		sleep NAPALM_LIFE_TIME;
		deleteVehicle _anchor; 
	};
};


if ( isServer ) then 
{
	/* Damage over time */
	if ( NAPALM_DAMAGE > 0 ) then {
		[_anchor] spawn 
		{
			params ["_anchor"];
			
			while {!isNull _anchor} do 
			{
				_objects = _anchor nearEntities ["MAN", NAPALM_BOMB_RADIUS];
				
				{
					[[_x, NAPALM_DAMAGE], {
						if (isDamageAllowed _x) then {
							(_this # 0) setDamage (( getDammage ( _this # 0 )) + ( _this # 1 ));  
						};
					}] remoteExec ["call", _x]
				}
				forEach _objects;
				
				sleep NAPALM_TICK_RATE;
			};
		};
	};

	/* Gradually deleting bushes in the napalm area over time */
	if (NAPALM_DELETE_VEGETATION) then 
	{
		private _nearestTerrainObjects = nearestTerrainObjects [_pos, ["bush"], NAPALM_BOMB_RADIUS];
		private _count = count _nearestTerrainObjects;
		if ( _count == 0 ) then {
			sleep NAPALM_LIFE_TIME;
		}
		else {
			{ 
				sleep ( NAPALM_LIFE_TIME / _count ); 
				_x hideObjectGlobal true; 
			} foreach _nearestTerrainObjects;
		};
	} else {
		sleep NAPALM_LIFE_TIME;
	};
	
	/* Spawning crater */
	if ( NAPALM_SPAWN_CRATER ) then {
		createSimpleObject ["FS_Vietnam\Effects\Napalm\krater.p3d", position _anchor, false];
	};
	
	// Clients delete _anchor separately from the server
	deleteVehicle _anchor; 
};


