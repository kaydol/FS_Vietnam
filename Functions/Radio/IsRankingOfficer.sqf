
params ["_unit", ["_collection", []]];

private _ranks = [];
{
	_ranks = _ranks + [gettext (_x >> "displayName")];
} 
foreach ("isclass _x" configclasses (configfile >> "CfgRanks"));

private _isRankingOfficer = True;
{
	private _iterable = _x;
	private _iterRank = _ranks findIf {_x == rank _iterable};
	private _unitRank = _ranks findIf {_x == rank _unit};
	if ( _iterRank > _unitRank ) exitWith { _isRankingOfficer = False };

} forEach _collection;

_isRankingOfficer
