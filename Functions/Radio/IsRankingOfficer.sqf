
params ["_unit", ["_collection", []]];

_ranks = [];
{
	_ranks = _ranks + [gettext (_x >> "displayName")];
} 
foreach ("isclass _x" configclasses (configfile >> "CfgRanks"));

_isRankingOfficer = True;
{
	_iterable = _x;
	_iterRank = _ranks findIf {_x == rank _iterable};
	_unitRank = _ranks findIf {_x == rank _unit};
	if ( _iterRank > _unitRank ) exitWith { _isRankingOfficer = False };

} forEach _collection;

_isRankingOfficer
