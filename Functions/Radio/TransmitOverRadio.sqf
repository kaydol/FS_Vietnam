
/*
	Transmits text and\or plays audio if player has radio
	
	Usage:
		[_side, _messageType] remoteExec ["FS_fnc_TransmitOverRadio", 2];
		[_side, _messageType, _vehicle, _speaker] remoteExec ["FS_fnc_TransmitOverRadio", 2];
	
	_side is what side will receive the broadcast.
	
	_vehicle is to be passed if you want only the passengers of that vehicle to receive the message. Could be either a unit or a vehicle the unit is inside of. Default: objNull
		
	_messageType is either of of :
		"RequestCAS", "InboundArty", "InboundCAS", "InboundTactical", "ChopperDown", "NewPilot", "BoardingStarted"
	
	_speaker can be either a unit or an identity, e.g. "Base", "HQ", "PAPA_BEAR", "AirBase", "BLU". Default: "HQ"
	
	Example:
		[WEST, "NewPilot"] remoteExec ["FS_fnc_TransmitOverRadio", 2];
	
*/

if !(isServer) exitWith {};

params ["_side", "_messageType", ["_vehicle", objNull], ["_speaker", "HQ"]];

private _casRequested = ["mp_groundsupport_01_casrequested_BHQ_0", 
				"mp_groundsupport_01_casrequested_BHQ_1", 
				"mp_groundsupport_01_casrequested_BHQ_2"];
				
private _artyInbound = 	["mp_groundsupport_45_artillery_BHQ_0", 
				"mp_groundsupport_45_artillery_BHQ_1", 
				"mp_groundsupport_45_artillery_BHQ_2"];
				
private _casInbound = 	["mp_groundsupport_50_cas_BHQ_0", 
				"mp_groundsupport_50_cas_BHQ_1", 
				"mp_groundsupport_50_cas_BHQ_2"];
				
private _tacticalInbound = 	["mp_groundsupport_70_tacticalstrikeinbound_BHQ_0", 
					"mp_groundsupport_70_tacticalstrikeinbound_BHQ_1", 
					"mp_groundsupport_70_tacticalstrikeinbound_BHQ_2", 
					"mp_groundsupport_70_tacticalstrikeinbound_BHQ_3", 
					"mp_groundsupport_70_tacticalstrikeinbound_BHQ_4"];		
					
private _chopperDown = 	["mp_groundsupport_65_chopperdown_BHQ_2"];
				
private _newPilot = ["mp_groundsupport_05_newpilot_BHQ_0", 
			"mp_groundsupport_05_newpilot_BHQ_1", 
			"mp_groundsupport_05_newpilot_BHQ_2"];

private _boardingStarted = 	["mp_groundsupport_05_boardingstarted_BHQ_0",
					"mp_groundsupport_05_boardingstarted_BHQ_1", 
					"mp_groundsupport_05_boardingstarted_BHQ_2"];
			
private _boardingEnded = 	["mp_groundsupport_10_boardingended_BHQ_0",
					"mp_groundsupport_10_boardingended_BHQ_1", 
					"mp_groundsupport_10_boardingended_BHQ_2"];

private _crewMemberDown = 	["pilotDownNoisy"];					
					
private _text = "";
private _message = "";
					
switch ( _messageType ) do 
{
	case "RequestCAS": { 
		_text = "Requesting CAS at these coordinates!";
		_message = selectRandom _casRequested;
	};
	case "InboundArty": { 
		_text = "Friendly artillery strike is INBOUND!";
		_message = selectRandom _artyInbound;
	};
	case "InboundCAS": {
		_text = "Friendly CAS strike is INBOUND!";
		_message = selectRandom _casInbound;
	};
	case "InboundTactical": { 
		_text = "Friendly tactical strike is INBOUND!";
		_message = selectRandom _tacticalInbound;
	};
	case "ChopperDown": {
		_text = "DAMN! They shot our bird! REPEAT, friendly helo is DOWN!";
		_message = selectRandom _chopperDown;
	};
	case "NewPilot": { 
		_text = "All land units be advised, we have a new air-asset coming in the area now.";
		_message = selectRandom _newPilot;
	};
	case "BoardingStarted": { 
		_text = "Troops are boarding your helicopter.";
		_message = selectRandom _boardingStarted;
	};
	case "BoardingEnded": { 
		_text = "All troops are on-board, you're clear for take-off.";
		_message = selectRandom _boardingEnded;
	};
	case "CrewMemberDown": {
		_text = "All elements, priority message... pilot in need of medevac... repeat... pilot down, requesting medevac, respond ASAP, out.";
		_message = selectRandom _crewMemberDown;
	};
	default { _message = "RadioMsgStatic"; };
};

[[_side, _message, _text, _vehicle, _speaker], {
	
	if !(hasInterface) exitWith {};
	
	params ["_side", "_message", "_text", "_vehicle", "_speaker"];
	
	private _canReceiveMessage = false;
	
	if !(isNull _vehicle) then {
		// If the target of the message is a specific vehicle, check if it has radio comm system and player is in it
		if (_vehicle call FS_fnc_HasCommSystem && (player == _vehicle || player in _vehicle)) then {
			_canReceiveMessage = true;
		};
	} else {
		// If the message is being broadcasted to everybody (not only 1 vehicle) then check if player has radio or RTO backpack
		if (player call FS_fnc_CanReceive) then {
			_canReceiveMessage = true;
		};
	};
	
	if !( _canReceiveMessage ) exitWith {};
	
	if ( _speaker isEqualType "" ) then {
		[_side, _speaker] sideRadio _message;
		[_side, _speaker] sideChat _text;
	} else {
		[_side, "HQ"] sideRadio _message;
		_speaker sideChat _text;
	};
	
}] remoteExec ["call", 0];
