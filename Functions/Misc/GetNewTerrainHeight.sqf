params ["_start", "_a", "_b", "_h"]; 
private _newPositions = []; 
for "_xStep" from 0 to _a do 
{
	for "_yStep" from 0 to _b do 
	{
		private _newHeight = _start vectorAdd [_xStep, _yStep, 0]; 
		_newHeight set [2, _h]; 
		_newPositions pushBack _newHeight; 
	}; 
};
_newPositions
