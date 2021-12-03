
params ["_logic", ["_units", []], ["_activated", false]];

if (!_activated) exitWith {};

while {sleep 1; !isNull _logic} do {
	private _synced = synchronizedObjects _logic select {_x isKindOf "MAN"};
	_logic synchronizeObjectsRemove _synced;
	
	_synced = _synced apply {group _x};
	_synced = _synced arrayIntersect _synced; 
	
	{ _x call FS_fnc_GrpPlaceTraps; } forEach _synced;
};