
params ["_dir", "_angle360"];

private _x = 0; // center of rotation, X
private _y = 0; // center of rotation, Y

private _dx = _x - (_dir select 0); 
private _dy = _y - (_dir select 1); 

_dir = [ 
	_x - ((_dx * cos (_angle360)) - (_dy * sin (_angle360))), 
	_y - ((_dx * sin (_angle360)) + (_dy * cos (_angle360))),
	0 
];

_dir

