
params ["_caller"];

if !( player call FS_fnc_HasRadioAround ) exitWith {
	"You need a radio to do that" call FS_fnc_ShowMessage;
};

/* TODO include the mention of tanks when present */
_knownEnemies = count ( _caller nearTargets 500 select { [_x # 2, side _caller] call BIS_fnc_sideIsEnemy } );
_friendliesAround = _caller nearEntities ["MAN", 30] select { !(_x isKindOf "Animal") && [side _x, side _caller] call BIS_fnc_sideIsFriendly };

if !( [player, _friendliesAround] call FS_fnc_IsRankingOfficer ) exitWith {
	"You are not the ranking officer\nOnly ranking officers are to provide situational reports" call FS_fnc_ShowMessage;
};

[_caller, "KNOWN_ENEMIES_AROUND", _knownEnemies, 180] spawn FS_fnc_SetVarLifespan;

/* If the caller is all alone */
if ( count _friendliesAround <= 1) then {
	// ...
};

/* Defining part of the message describing the number of enemies */
 
_infoAboutEnemies = "";

if ( _knownEnemies isEqualTo 0 ) then {
	_infoAboutEnemies = [
		"All clear, we are proceeding further.", 
		"No enemy activity spotted.", 
		"The area seems to be clear.", 
		"It's getting too quiet here...", 
		"Haven't encountered any enemies so far.", 
		"The area looks clear, haven't seen or heard any VC yet.", 
		"Nothing to report so far. Proceeding as ordered.", 
		"Our sector is clear. No enemies spotted." 
	] call BIS_fnc_SelectRandom;
}
else 
{
	_pronounce = ["ten","twenty","thirty","fourty","fifty","sixty","seventy","eighty","ninety"];
	_floor = ( floor ( _knownEnemies / 10 ) - 1 ) max 0;
	_ceil = ( ceil ( _knownEnemies / 10 ) - 1 ) max 0;
	
	// Too may enemies to count
	if ( _ceil >= count _pronounce || _floor >= count _pronounce ) exitWith 
	{
		_infoAboutEnemies = [
			"We have a lot of people down here!",
			"We have at least a company sized enemy force lurking around us!",
			"We have not less than a hundred of VC around us.",
			"We are under attack of a company sized force..."
		
		] call BIS_fnc_SelectRandom;
	};
	
	// Amount of enemies % 10 == 0 
	if ( _floor isEqualTo _ceil ) then {
		_infoAboutEnemies = [
			"There are around %1 VC on our position. We are locked in combat with them.",
			"We are in a fight with approximately %1 enemies or so.",
			"We are engaging approximately %1 enemies.",
			"Currently in a fight with around %1 or more hostiles.",
			"We have encountered an enemy, approximately %1 or more of them are closing in on us.",
			"There are %1 or more VC closing in on us.",
			"We have VC, not less than %1 of them."
		] call BIS_fnc_SelectRandom;
	}
	else {
		// Describing a range of enemies
		_infoAboutEnemies = [
			"We have encountered an enemy, there are %1 to %2 of them. We are in a fight.",
			"There are %1 to %2 enemies close to our location...",
			"There are %1, maybe %2 VC in our area.",
			"We are engaging %1 to %2 enemies...",
			"We got %2 or %1 enemies close to our position."
		] call BIS_fnc_SelectRandom;
	};
	
	_infoAboutEnemies = format [_infoAboutEnemies, _pronounce # _floor, _pronounce # _ceil];
	
};

/* Defining part of the message describing the casualties suffered */

_infoAboutCasualties = "";
_unscratched = count _friendliesAround;

for [{_i = 0},{_i < count _friendliesAround},{_i = _i + 1}] do {
	_soldier = _friendliesAround # _i;
	if ( (vehicle _soldier == _soldier) && (!canStand _soldier || damage _soldier > 0.3) ) then { 
		_unscratched = _unscratched - 1; 
	};
};
_injured = count _friendliesAround - _unscratched; 

if ( _injured isEqualTo 0 ) then {
	_infoAboutCasualties = [
		"We are all unscratched.",
		"No casualties.",
		"Nobody's hurt.",
		"We haven't suffered any casualties yet.",
		"No wounded."
	] call BIS_fnc_SelectRandom;
}
else {
	_infoAboutCasualties = [
		"I have %1 men and %2 of them %3 are wounded.",
		"We have %2 wounded, and a total of %1 men.",
		"We suffered casualties and have %2 wounded.",
		"There are %1 of us and %2 %3 wounded."
	] call BIS_fnc_SelectRandom;
	_isare = if ( _injured <= 1 ) then [{"is"},{"are"}];
	_infoAboutCasualties = format [_infoAboutCasualties, count _friendliesAround, _injured, _isare];
};



/* Adding up if the unit is low on ammo */
// ...


/* Compiling all into one */

_template = [
	"This is %1, %2 company, reporting. %3 %4",
	"HQ, this is %2, reporting %1. %3 %4",
	"This is %1 from %2 company. %3 %4",
	"This is %1, %2. %3 %4",
	"%1 speaking, %2 company. %3 %4"
] call BIS_fnc_SelectRandom;

_nameAndRank = rank _caller + " " + name _caller;
_companyName = str group _caller;

_format = format [_template, _nameAndRank, _companyName, _infoAboutEnemies, _infoAboutCasualties];

[[_caller, _format], {
	
	if !(hasInterface) exitWith {};
	if !( player call FS_fnc_HasRadioAround ) exitWith {};
	
	params ["_caller", "_message"];
	
	[side _caller, "HQ"] sideRadio "RadioMsgStatic";
	_caller sideChat _message;
	
}] remoteExec ["call", 0];