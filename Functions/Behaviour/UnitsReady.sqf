
params ["_collection"];

_ready = True;

{
	// Players are always ready
	if (!isPlayer _x && !unitReady _x) exitWith { _ready = False; }; 
}
forEach _collection;

_ready	
