
params ["_queue", "_elem", ["_newMaxSize", 0, [0]]];

_queue params ["_maxQueueSize", "_data"];

if ( _newMaxSize > 0 ) then {
	_queue set [0, _newMaxSize];
	
	if ( _newMaxSize < _maxQueueSize ) then {
		_data resize _newMaxSize;
	};
	_maxQueueSize = _newMaxSize;
};

private _size = count _data;

if ( _size + 1 < _maxQueueSize ) then {
	_size = _size + 1;
	_data resize _size;
}; 

private "_i";
for [{_i = _size - 1},{_i > 0},{_i = _i - 1}] do {
	_data set [_i, _data # (_i - 1)];
};

_data set [0, _elem]; 