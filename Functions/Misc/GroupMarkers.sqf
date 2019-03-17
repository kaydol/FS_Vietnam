
params ["_group", "_mkrtype"];

{
	_marker = createMarkerLocal [str(round random(1000000)), getPos _x];
	_marker setMarkerTypeLocal _mkrtype;
	
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
forEach units _group;
