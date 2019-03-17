params ["_aircraft"];

// TODO add low on ammo check...

_most_damaged_part = selectMax (getAllHitPointsDamage _aircraft select 2);

fuel _aircraft < 0.3 || _most_damaged_part > 0.5