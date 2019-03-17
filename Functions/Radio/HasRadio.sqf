

if ( _this call FS_fnc_HasCommSystem ) exitWith { True };

_radios = ["ItemRadio", "UNS_Alice_LRP1", "UNS_Alice_LRP2"];

count ( _radios arrayIntersect (items _this + assignedItems _this + [backpack _this]) ) > 0


