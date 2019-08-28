
params ["_object"];

if ( _object call FS_fnc_HasCommSystem ) exitWith { True };

( "ItemRadio" in assignedItems _object )



