params ["_aircraft"];
//-- canMove is not a sufficient check when the aircraft is controlled by a player, 
//-- because a skilled player can still land even a critically damaged aircraft 
(!canMove _aircraft && crew _aircraft findIf {isPlayer _x} == -1) || !alive _aircraft 