/* ----------------------------------------------------------------------------
Function: FS_GookArea_Module

Description:
	
	
Parameters:
    _module - The module logic.
	
Returns:
    Nothing.

Author:
    kaydol
---------------------------------------------------------------------------- */

_mode = param [0,"",[""]];
_input = param [1,[],[[]]];

[_mode, _input, "Logic"] call FS_fnc_VisualizeModuleRadius3DEN;

switch _mode do {
	// Default object init
	case "init": 
	{
		_logic = _input param [0,objNull,[objNull]]; // Module logic
		_isActivated = _input param [1,true,[true]]; // True when the module was activated, false when it's deactivated
		_isCuratorPlaced = _input param [2,false,[true]]; // True if the module was placed by Zeus
		
		_synced = synchronizedObjects _logic; 
		_showError = true;
		{
			if ( typeOf _x == "FS_GookManager_Module" ) then 
			{ 
				_showError = false;
			};
		}
		forEach _synced;
		if (_showError) then {
			["Area Modules need to have at least 1 Gook Manager module synchronized"] call BIS_fnc_error;
		};
	};
	
	default {};
};

true

