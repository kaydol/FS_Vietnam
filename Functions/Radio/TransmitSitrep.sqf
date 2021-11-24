
params ["_caller"];

if (isNil{RADIOCOMMS_REQUIRE_RANKING_OFFICER}) then {
	RADIOCOMMS_REQUIRE_RANKING_OFFICER = getNumber (ConfigFile >> "CfgVehicles" >> "FS_ModuleRadioSettings" >> "Attributes" >> "RequireRankingOfficer" >> "defaultValue") == 1;
	RADIOCOMMS_AUDIBLE_RADIUS = getNumber (ConfigFile >> "CfgVehicles" >> "FS_ModuleRadioSettings" >> "Attributes" >> "AudibleRadius" >> "defaultValue");
};

/* TODO include the mention of tanks when present */

private _friendliesAround = _caller nearEntities ["MAN", 30] select { !(_x isKindOf "Animal") && [side _x, side _caller] call BIS_fnc_sideIsFriendly };
private _canTransmit = ((_caller nearEntities RADIOCOMMS_AUDIBLE_RADIUS) select { _x call FS_fnc_CanTransmit }) > 0;

if ( !_canTransmit ) exitWith {
	format["You need an RTO or a vehicle with comm system within %1 meters to do that", RADIOCOMMS_AUDIBLE_RADIUS] call FS_fnc_ShowMessage;
};

if ( RADIOCOMMS_REQUIRE_RANKING_OFFICER && ![_caller, _friendliesAround] call FS_fnc_IsRankingOfficer ) exitWith {
	"You are not the ranking officer\nOnly ranking officers are to provide situational reports" call FS_fnc_ShowMessage;
};

private _knownEnemies = count ( _caller nearTargets 500 select { [_x # 2, side _caller] call BIS_fnc_sideIsEnemy } );
[_caller, "KNOWN_ENEMIES_AROUND", _knownEnemies, 180] spawn FS_fnc_SetVarLifespan;

/* If the caller is all alone */
if ( count _friendliesAround <= 1) then {
	// ...
};

/* Defining part of the message describing the number of enemies */
 
private _infoAboutEnemies = "";

if ( _knownEnemies isEqualTo 0 ) then {
	_infoAboutEnemies = selectRandom [
		"All clear, we are proceeding further.", 
		"No enemy activity spotted.", 
		"The area seems to be clear.", 
		"Didn't see any VC. It's getting too quiet here...", 
		"Haven't encountered any enemies so far.", 
		"The area looks clear, haven't seen or heard any VC yet.", 
		"Nothing to report so far. Proceeding as ordered.", 
		"Our sector is clear. No enemies spotted." 
	];
}
else 
{
	private _pronounce = ["ten","twenty","thirty","fourty","fifty","sixty","seventy","eighty","ninety"];
	private _floor = ( floor ( _knownEnemies / 10 ) - 1 ) max 0;
	private _ceil = ( ceil ( _knownEnemies / 10 ) - 1 ) max 0;
	
	// Too may enemies to count
	if ( _ceil >= count _pronounce || _floor >= count _pronounce ) exitWith 
	{
		_infoAboutEnemies = selectRandom [
			"We have a lot of people down here!",
			"We have at least a company sized enemy force lurking around us!",
			"We have not less than a hundred of VC around us.",
			"We are under attack of a company sized force..."
		
		];
	};
	
	// Amount of enemies % 10 == 0 
	if ( _floor isEqualTo _ceil ) then {
		_infoAboutEnemies = selectRandom [
			"There are around %1 VC on our position. We are locked in combat with them.",
			"We are in a fight with approximately %1 enemies or so.",
			"We are engaging approximately %1 enemies.",
			"Currently in a fight with around %1 or more hostiles.",
			"We have encountered an enemy, approximately %1 or more of them are closing in on us.",
			"There are %1 or more VC closing in on us.",
			"We have VC, not less than %1 of them."
		];
	}
	else {
		// Describing a range of enemies
		_infoAboutEnemies = selectRandom [
			"We have encountered an enemy, there are %1 to %2 of them. We are in a fight.",
			"There are %1 to %2 enemies close to our location...",
			"There are %1, maybe %2 VC in our area.",
			"We are engaging %1 to %2 enemies...",
			"We got %2 or %1 enemies close to our position."
		];
	};
	
	_infoAboutEnemies = format [_infoAboutEnemies, _pronounce # _floor, _pronounce # _ceil];
	
};

/* Defining part of the message describing the casualties suffered */

private _infoAboutCasualties = "";
private _unscratched = count _friendliesAround;

for [{_i = 0},{_i < count _friendliesAround},{_i = _i + 1}] do {
	private _soldier = _friendliesAround # _i;
	if ( (vehicle _soldier == _soldier) && (!canStand _soldier || damage _soldier > 0.3) ) then { 
		_unscratched = _unscratched - 1; 
	};
};
private _injured = count _friendliesAround - _unscratched; 

if ( _injured isEqualTo 0 ) then {
	_infoAboutCasualties = selectRandom [
		"We are all unscratched.",
		"No casualties.",
		"Nobody's hurt.",
		"We haven't suffered any casualties yet.",
		"No wounded."
	];
}
else {
	_infoAboutCasualties = selectRandom [
		"I have %1 men and %2 of them %3 are wounded.",
		"We have %2 wounded, and a total of %1 men.",
		"We suffered casualties and have %2 wounded.",
		"There are %1 of us and %2 %3 wounded."
	];
	private _isare = if ( _injured <= 1 ) then [{"is"},{"are"}];
	_infoAboutCasualties = format [_infoAboutCasualties, count _friendliesAround, _injured, _isare];
};



/* Adding up if the unit is low on ammo */
// ...


/* Compiling all into one */

private _template = selectRandom [
	"This is %1, %2 company, reporting. %3 %4",
	"HQ, this is %2, reporting %1. %3 %4",
	"This is %1 from %2 company. %3 %4",
	"This is %1, %2. %3 %4",
	"%1 speaking, %2 company. %3 %4"
];

private _nameAndRank = rank _caller + " " + name _caller;
private _companyName = str group _caller;

private _format = format [_template, _nameAndRank, _companyName, _infoAboutEnemies, _infoAboutCasualties];

[[_caller, _format], {
	
	if !(hasInterface) exitWith {};
	if !( _caller call FS_fnc_CanReceive ) exitWith {};
	
	params ["_caller", "_message"];
	
	[side _caller, "HQ"] sideRadio "RadioMsgStatic";
	_caller sideChat _message;
	
}] remoteExec ["call", 0];