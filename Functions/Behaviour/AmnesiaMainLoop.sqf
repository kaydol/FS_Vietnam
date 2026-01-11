
/*
	Amnesia Framework was created for a unique use case when you need 
	to make certain targets be invisible to AI without making them captive.
	
	Author: kaydol
*/

#include "..\..\definitions.h"
#include "AmnesiaFrameworkDefinitions.h"

[] spawn {
	
	//-- Even if this code is executed multiple times, the event handler should simply overwrite itself without creating duplicates  
	[DEF_AMNESIA_FRAMEWORK_EH_NAME, 'onEachFrame', { 
	
		private _targets = [] call FS_fnc_AmnesiaGetTargets;
		private _localGroups = [] call FS_fnc_AmnesiaGetLocalGroups;
		
		{ 
			private _thisGroup = _x;
			private _hiddenTargets = (_thisGroup targets [true]) select { isObjectHidden _x }; 
			{ 
				_thisGroup forgetTarget _x; 
				//systemChat format ["Making %1 forget about %2", _thisGroup, _x];
				
			} forEach _hiddenTargets; 
		} forEach _localGroups; 
		
	}] spawn BIS_fnc_addStackedEventHandler;
};