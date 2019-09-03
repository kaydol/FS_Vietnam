params ["_aircraft", ["_debug", false]];

private _repairAt = missionNameSpace getVariable ["MAINTENANCE_REPAIR_AT", 0.5];
private _refuelAt = missionNameSpace getVariable ["MAINTENANCE_REFUEL_AT", 0.2];

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

if ( _debug ) then {
	private _index = _damage findIf {_x == _mostDamagedPart};
	diag_log format ["Pilot: The most dammaged hitpart is %1, %2", _hitParts # _index, _mostDamagedPart];
};

fuel _aircraft < _refuelAt || _mostDamagedPart > _repairAt || _noAmmo 