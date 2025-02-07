/*
	Gook Senses is essentially a wallhack that allows Gooks to slowly
	but surely identify the enemy around them. 
	
	This is being put in place in order to make sure the Gooks 
	live up to an image of their vigilant and cunning real counterparts.
*/

params ["_group", ["_radius", 200], ["_debug", false]];

if (_radius <= 0) exitWith {};

while { true } do 
{
	private _alive = units _group select { alive _x };
	if ( _alive isEqualTo [] ) exitWith {};
	private _rndAlive = selectRandom _alive;
	
	private _objectsToReveal = getPos _rndAlive nearEntities ["Land", _radius] select { !(_x isKindOf "Animal") };
	
	{
		private _knowledge = _rndAlive knowsAbout _x;
		_knowledge = ( _knowledge + 0.1 ) min 4;
		_rndAlive reveal [_x, _knowledge];
	}
	forEach _objectsToReveal;
	
	sleep 5;
};



