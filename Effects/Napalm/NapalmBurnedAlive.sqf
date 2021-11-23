/* ----------------------------------------------------------------------------
Function: FS_fnc_BurnedAlive

Description:
	Makes a person say a given sound (intended to be a scream), after that
	a person will start smoking. Killing the person is not a part of this
	function, it only provides audio\visual effects. 
	
Parameters:
    _this select 0: OBJECT - unit to whom the speaker will be attached
    _this select 1: STRING - sound to be played by the speaker
	_this select 2: NUMBER [OPTIONAL] - how long to wait until the unit starts to smoke, default 0
	_this select 3: NUMBER [OPTIONAL] - how long to keep the sound emitter alive, default 10 seconds
	
Returns:
    Nothing.

Author:
    kaydol
---------------------------------------------------------------------------- */

if !(hasInterface) exitWith {};

params ["_unit", ["_deathSound", ""], ["_smokeDelay", 0], ["_screamingTime", 10]];

_screaming = missionNameSpace getVariable ["NAPALM_VICTIMS_SCREAM", getNumber (ConfigFile >> "CfgVehicles" >> "FS_NapalmSettings_Module" >> "Attributes" >> "MakeVictimsScream" >> "defaultValue") == 1];
_smokingTime = missionNameSpace getVariable ["NAPALM_VICTIMS_SMOKE_TIME", getNumber (ConfigFile >> "CfgVehicles" >> "FS_NapalmSettings_Module" >> "Attributes" >> "VictimsSmokeTime" >> "defaultValue")];

if ( !_screaming && _smokingTime <= 0 ) exitWith {};

if ( _screaming && _deathSound != "" ) then 
{
	[_screamingTime, _unit, _deathSound] spawn 
	{
		params ["_screamingTime", "_unit", "_deathSound"];
		
		_speaker = "#particlesource" createVehicleLocal getPos _unit;
		_speaker attachTo [_unit, [0,0,0], "head_hit"];

		if ( _unit != player ) then 
		{
			_unit setRandomLip true;
			_speaker Say3D [_deathSound, 200];
		};
		
		sleep _screamingTime;
		_unit setRandomLip false;
		deleteVehicle _speaker;
	};
};

if ( _smokingTime > 0 ) then 
{
	sleep _smokeDelay;
	_smoker = "#particlesource" createVehicleLocal getPos _unit;
	_smoker setParticleCircle [0, [0, 0, 0]];
	_smoker setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 0.25, [0, 0, 0, 0], 0, 0];
	_smoker setParticleClass "NapalmVictim";
	//_smoker setParticleFire [0.3,1.0,0.01];
	_smoker attachTo [_unit, [0,0,0]];
	sleep _smokingTime;
	_smoker setDropInterval 0;
	deleteVehicle _smoker;
};
