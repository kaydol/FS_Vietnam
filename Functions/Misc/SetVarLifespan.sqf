
params ["_obj", "_varname", "_value", "_lifetime", "_fallbackValue", ["_isGlobal", False]];

_obj setVariable [_varname, _value, _isGlobal];

sleep _lifetime;

if (!isNull _obj) then 
{
	if (isNil{ _fallbackValue }) then 
	{
		_obj setVariable [_varname, nil, _isGlobal];
	} 
	else 
	{
		_obj setVariable [_varname, _fallbackValue, _isGlobal];
	};
	
};