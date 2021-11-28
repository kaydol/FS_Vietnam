
params ["_group", "_mkrtype"];

{
	private _marker = [getPos _x, _mkrtype] call FS_fnc_CreateDebugMarker;
	
	if (hasInterface) then 
	{
		[_x, _marker] spawn 
		{
			while {alive (_this select 0)} do {
				(_this select 1) setMarkerPosLocal getPos (_this select 0);
				sleep 0.05;
			};
			deleteMarkerLocal (_this select 1);
		};
		sleep 0.5;
	} 
	else 
	{
		[_x, _marker] spawn 
		{
			while {alive (_this select 0)} do {
				(_this select 1) setMarkerPos getPos (_this select 0);
				sleep 0.05;
			};
			deleteMarker (_this select 1);
		};
		sleep 0.5;
	};
}
forEach units _group;