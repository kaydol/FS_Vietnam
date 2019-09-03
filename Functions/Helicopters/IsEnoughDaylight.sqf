
private _sunriseSunset = date call BIS_fnc_sunriseSunsetTime; 

// [0,-1] - polar summer (i.e., no sunset)
if ( _sunriseSunset # 1 < 0 ) exitWith { true };

// [-1,0] - polar winter (i.e., no sunrise). 
if ( _sunriseSunset # 0 < 0 ) exitWith { false };

(daytime > ((_sunriseSunset # 0) - 0.5) && daytime < ((_sunriseSunset # 1) + 0.5))

