params ["_module"];

if ( typeOf _module == "SideBLUFOR_F" ) exitWith { WEST };
if ( typeOf _module == "SideOPFOR_F" ) exitWith { EAST };
if ( typeOf _module == "SideResistance_F" ) exitWith { RESISTANCE };

_side = sideLogic;

{
	if ( typeOf _x == "SideBLUFOR_F" ) exitWith { _side = WEST };
	if ( typeOf _x == "SideOPFOR_F" ) exitWith { _side = EAST };
	if ( typeOf _x == "SideResistance_F" ) exitWith { _side = RESISTANCE };
}
forEach synchronizedObjects _module;

_side
