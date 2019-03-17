

if ( typeName _this == "GROUP" ) exitWith { False };

if ( _this isKindOf "uns_willys_base" || _this isKindOf "Air" || _this isKindOf "Tank" ) exitWith { True };

False 