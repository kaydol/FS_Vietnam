
disableSerialization;
params ["_unit", "_id"];

if (!isNil{ _unit getVariable 'FS_Healthbars_Draw3DHandler' }) then {
	private _id = _unit getVariable 'FS_Healthbars_Draw3DHandler';
	removeMissionEventHandler ['Draw3D', _id];
	_unit setVariable ["FS_Healthbars_Draw3DHandler", nil];
};

private _display = uiNamespace getVariable ['FS_HealthBar', displayNull];

if (!isNil{ _unit getVariable 'FS_Healthbars_Ctrl' }) then {	
	private _ctrl = _display displayCtrl ( _unit getVariable 'FS_Healthbars_Ctrl' );
	ctrlDelete _ctrl;
	_unit setVariable ["FS_Healthbars_Ctrl", nil];
};

