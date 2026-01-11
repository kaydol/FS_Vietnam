
_this spawn {

	params ["_player"];

	if (player != _player) exitWith {};

	private _side = EAST;
	private _newGrp = createGroup _side;

	private _unit1 = _newGrp createUnit ["vn_o_men_vc_local_14", getPos _player, [], 10, "NONE"];
	private _unit2 = _newGrp createUnit ["vn_o_men_vc_local_14", getPos _player, [], 10, "NONE"];

	{
		removeAllWeapons _x;
		removeAllMagazines _x;
		removeAllItems _x;
		_x hideObjectGlobal true;
		_x enableSimulationGlobal false;
		_x enableSimulation true;
		_x setVariable ["IMS_IsUnitInvicibleScripted", 1, true]; // Improved Melee System addon 
		_x allowDamage false;
		[_x, 99999999] remoteExec ["FS_fnc_AddGodmodeTimespan", _x];
		
		// This disables VC voicelines
		// but without this the turret is aggroed at the VC 
		//_x setCaptive true;
	} 
	forEach [_unit1, _unit2];
	
	[[_unit1, _unit2]] call FS_fnc_AmnesiaAddTargets;
	
	while {true} do {
		
		if (!isNull player && ((attachedTo _unit1) isNotEqualTo player)) then {
			
			_unit1 attachTo [player, [-10 - (random 30),10 + (random 30),0]];
			_unit1 reveal [player, 4];
			
			_unit2 attachTo [player, [10 + (random 30),10 + (random 30),0]];
			_unit2 reveal [player, 4];
		};
		
		sleep 5;
	};
	
};