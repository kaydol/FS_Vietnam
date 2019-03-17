
params ["_obj", "_varname", "_value", "_lifetime", ["_fallbackValue", nil], ["_isGlobal", False]];

_obj setVariable [_varname, _value, _isGlobal];

sleep _lifetime;

if !(isNull _obj) then 
{
	_obj setVariable [_varname, _fallbackValue, _isGlobal];
};