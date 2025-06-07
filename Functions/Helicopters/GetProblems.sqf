params ["_aircraft", ["_debug", false]];

/* Ammo check */
private _noAmmo = { _x # 2 != 0} count (magazinesAllTurrets _aircraft) == 0;

/* Damage check*/
getAllHitPointsDamage _aircraft params ["_hitParts", "_selections", "_damage"];

{
	private _ignore = false;

	// Ignore broken glass
	if ((_x select [0,5]) == "glass") then { _ignore = true; }; 
	
	// Ignore broken lights
	if ((_x select [0,6]) == "svetlo") then { _ignore = true; }; 
	
	if (_ignore) then {
		_damage set [_forEachIndex, 0];
	};

} forEach _selections;

private _mostDamagedPart = selectMax _damage;

private _problems = [];

private _repairAt = missionNameSpace getVariable ["MAINTENANCE_REPAIR_AT", 0.5];
private _refuelAt = missionNameSpace getVariable ["MAINTENANCE_REFUEL_AT", 0.2];

if (_mostDamagedPart > _repairAt) then { _problems pushBack "DAMAGE" };
if (fuel _aircraft < _refuelAt) then { _problems pushBack "FUEL" };
if (_noAmmo) then { _problems pushBack "AMMO" };


// Check crew HEALTH 
private _maxDamage = missionNameSpace getVariable ["MAINTENANCE_HEAL_AT", 0.35];
{
	if ( !alive _x ) then { _problems pushBack "DEAD" };
	if ( alive _x && damage _x > _maxDamage ) then { _problems pushBack "INJURED" };
} 
forEach crew _aircraft;

_problems
