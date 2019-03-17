/*
	Gook Senses is essentially a wallhack that allows Gooks to slowly
	but surely identify the enemy around them. 
	
	This is being put in place in order to make sure the Gooks 
	live up to an image of their vigilant and cunning real counterparts.
*/

params ["_group"];

while { true } do 
{
	_alive = units _group select { alive _x };
	if ( _alive isEqualTo [] ) exitWith {};
	_rndAlive = selectRandom _alive;
	
	_objectsToReveal = getPos _rndAlive nearEntities ["Land", 200] select { !(_x isKindOf "Animal") };
	
	{
		_knowledge = _rndAlive knowsAbout _x;
		_knowledge = ( _knowledge + 0.1 ) min 4;
		_rndAlive reveal [_x, _knowledge];
	}
	forEach _objectsToReveal;
	
	sleep 10;
};



