
/*	
	as = group player execVM "scripts\Nametags.sqf"
	
	//[texture, color, pos, width, height, angle, text, shadow, textSize, font, textAlign, drawSideArrows]
*/	

params ["_unit"];

if (_unit != player) exitWith {};


FS_GetPosOverhead = {
	_xyz = _this selectionPosition 'head';
	_z = _xyz select 2;
	_xyz set [2, _z + 0.5];
	_this modelToWorldVisual _xyz
};

/*
	Description:
		Client only. Persistently adds name+level above unit's head. 
		
	Usage:
		player spawn FS_addNametag;
*/
FS_addNametag = {
	
	if (!hasInterface) exitWith {};

	params ["_unit", ["_alias", format ["VRF_Unit%1", round random 1000000]], "_id", "_code", "_respHandler"];
	
	if ( isNull _unit ) exitWith {};
	
	// A very geniously invented way to avoid dealing with names like 'B Alpha 1-2:1'
	_unit call compile ( _alias + "=_this;" );
	_unit setVariable ["FS_NametagName", _alias];
	
	// "Respawn" event handler is only persistent if the unit is local
	// We want it to be persistent, so here goes
	[_unit, {
		// This remoteExec's scope is executed only where the unit is local, and, because of the next check, only once
		if !(isNil{_this getVariable 'FS_Nametags_RespHandler'}) exitWith {};
		
		_respHandler = _this addEventHandler ["Respawn", {
			params ['_unit', '_corpse', '_handler'];
			//_handler = _unit getVariable 'FS_Nametags_RespHandler';
			//_unit removeEventHandler ["respawn", _handler];
			
			[_unit, {
				[_this, _this getVariable 'FS_NametagName'] call FS_addNametag;
			}] remoteExec ["call", 0, TRUE];
		}];	
		_this setVariable ["FS_Nametags_RespHandler", _respHandler];
		
	}] remoteExec ["call", _unit];
	
	if (isNil{_unit getVariable 'FS_Nametags_Draw3DHandler'}) then 
	{
		_code = compile format ["
			params ['_id'];
			private _id = addMissionEventHandler ['Draw3D', {
				if (alive %1) then {
					private _dist = player distance %1;
					private _viewdist = 40;
					if (_dist < _viewdist) then {
						private _maxFontSize = 0.05;
						private _minFontSize = 0;
						private _name = name %1;
						private _size = linearConversion [_viewdist, 0, _dist, _minFontSize, _maxFontSize, true];
						private _transparency = linearConversion [_minFontSize, _maxFontSize, _size, 0, 1, true];
						drawIcon3D ['', [1,1,1,_transparency], %1 call FS_GetPosOverhead, 0, 0, 0, _name, 2, _size];
					};
				};
			}];
			%1 setVariable ['FS_Nametags_Draw3DHandler', _id];
		", _alias];
		
		call _code;
	};
};


private _codeForLocalUnitRespawn = format ["
	
		params ['_localUnit', ['_corpse', objNull]];
		_localUnit remoteExec ['FS_addNametag', %1];
		
", clientOwner];

private _codeForPlayers = {
	params ["_clientOwner", ["_code", {}]];
	if (
		clientOwner != _clientOwner && // do not execute code for the medic player 
		!isNull player // do not execute code on the headless server
	) then {
		player addEventHandler ["Respawn", compile _code];
		diag_log format ["(Machine @ %1) Adding respawn code on player (%2 @ %3): %4", clientOwner, player, owner player, _code];
	};
};


private _codeForBots = {
	params ["_unit", ["_code", {}]];
	if (local _unit) then {
		_unit addEventHandler ["Respawn", compile _code];
		diag_log format ["(Machine @ %1) Adding respawn code on bot (%2 @ %3): %4", clientOwner, _unit, owner _unit, _code];
	};
};

// This should take care of all players, including JIP players 
[[clientOwner, _codeForLocalUnitRespawn], _codeForPlayers] remoteExec ["spawn", 0, true];

// This should take care of bots 
{
	//[[_x, _codeForLocalUnitRespawn], _codeForBots] remoteExec ["spawn", _x, true];
	_x spawn FS_addNametag;
}
forEach ((units group player) select {!isPlayer _x && _x != player});

/*
MISSION_ROOT = call 
{
    private "_arr";
    _arr = toArray __FILE__;
    _arr resize (count _arr - 19);
    toString _arr
};
*/
