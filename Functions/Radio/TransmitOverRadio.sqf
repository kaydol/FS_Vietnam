
/*
	Transmits text and\or plays audio if player has radio
*/

#include "..\..\definitions.h"

if !(isServer) exitWith {};

params ["_side", ["_prefix", ""], "_messageType", ["_vehicle", objNull], ["_speaker", objNull]];

private _data = createHashMapFromArray [
	//-- Vanilla radio messages
	[toLowerANSI DEF_RADIO_TRANSMISSION_PREFIX_NONE, createHashMapFromArray [
		 [toLowerANSI "Arty_North", 		["mp_groundsupport_45_artillery_BHQ_0", "mp_groundsupport_45_artillery_BHQ_1", "mp_groundsupport_45_artillery_BHQ_2"]]
		,[toLowerANSI "Arty_North_East", 	["mp_groundsupport_45_artillery_BHQ_0", "mp_groundsupport_45_artillery_BHQ_1", "mp_groundsupport_45_artillery_BHQ_2"]]
		,[toLowerANSI "Arty_East", 			["mp_groundsupport_45_artillery_BHQ_0", "mp_groundsupport_45_artillery_BHQ_1", "mp_groundsupport_45_artillery_BHQ_2"]]
		,[toLowerANSI "Arty_South_East", 	["mp_groundsupport_45_artillery_BHQ_0", "mp_groundsupport_45_artillery_BHQ_1", "mp_groundsupport_45_artillery_BHQ_2"]]
		,[toLowerANSI "Arty_South", 		["mp_groundsupport_45_artillery_BHQ_0", "mp_groundsupport_45_artillery_BHQ_1", "mp_groundsupport_45_artillery_BHQ_2"]]
		,[toLowerANSI "Arty_South_West", 	["mp_groundsupport_45_artillery_BHQ_0", "mp_groundsupport_45_artillery_BHQ_1", "mp_groundsupport_45_artillery_BHQ_2"]]
		,[toLowerANSI "Arty_West", 			["mp_groundsupport_45_artillery_BHQ_0", "mp_groundsupport_45_artillery_BHQ_1", "mp_groundsupport_45_artillery_BHQ_2"]]
		,[toLowerANSI "Arty_North_West", 	["mp_groundsupport_45_artillery_BHQ_0", "mp_groundsupport_45_artillery_BHQ_1", "mp_groundsupport_45_artillery_BHQ_2"]]
		
		,[toLowerANSI "Napalm_North", 		["mp_groundsupport_70_tacticalstrikeinbound_BHQ_0", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_1", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_2", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_3", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_4"]]
		,[toLowerANSI "Napalm_North_East", 	["mp_groundsupport_70_tacticalstrikeinbound_BHQ_0", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_1", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_2", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_3", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_4"]]
		,[toLowerANSI "Napalm_East", 		["mp_groundsupport_70_tacticalstrikeinbound_BHQ_0", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_1", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_2", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_3", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_4"]]
		,[toLowerANSI "Napalm_South_East", 	["mp_groundsupport_70_tacticalstrikeinbound_BHQ_0", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_1", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_2", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_3", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_4"]]
		,[toLowerANSI "Napalm_South", 		["mp_groundsupport_70_tacticalstrikeinbound_BHQ_0", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_1", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_2", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_3", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_4"]]
		,[toLowerANSI "Napalm_South_West", 	["mp_groundsupport_70_tacticalstrikeinbound_BHQ_0", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_1", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_2", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_3", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_4"]]
		,[toLowerANSI "Napalm_West", 		["mp_groundsupport_70_tacticalstrikeinbound_BHQ_0", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_1", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_2", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_3", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_4"]]
		,[toLowerANSI "Napalm_North_West", 	["mp_groundsupport_70_tacticalstrikeinbound_BHQ_0", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_1", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_2", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_3", "mp_groundsupport_70_tacticalstrikeinbound_BHQ_4"]]
		
		,[toLowerANSI "Introduction", 		["mp_groundsupport_05_newpilot_BHQ_0", "mp_groundsupport_05_newpilot_BHQ_1", "mp_groundsupport_05_newpilot_BHQ_2"]]
		,[toLowerANSI "Replacement", 		["mp_groundsupport_05_newpilot_BHQ_0", "mp_groundsupport_05_newpilot_BHQ_1", "mp_groundsupport_05_newpilot_BHQ_2"]]
		,[toLowerANSI "RefuelAndResupply", 	["RadioMsgStatic"]]
		,[toLowerANSI "Returned", 			["mp_groundsupport_05_newpilot_BHQ_0", "mp_groundsupport_05_newpilot_BHQ_1", "mp_groundsupport_05_newpilot_BHQ_2"]]
		
		,[toLowerANSI "RequestCAS", 		["mp_groundsupport_01_casrequested_BHQ_0", "mp_groundsupport_01_casrequested_BHQ_1", "mp_groundsupport_01_casrequested_BHQ_2"]]
		,[toLowerANSI "InboundCAS", 		["mp_groundsupport_50_cas_BHQ_0", "mp_groundsupport_50_cas_BHQ_1", "mp_groundsupport_50_cas_BHQ_2"]]
		,[toLowerANSI "ChopperDown", 		["mp_groundsupport_65_chopperdown_BHQ_2"]]
		,[toLowerANSI "BoardingStarted", 	["mp_groundsupport_05_boardingstarted_BHQ_0","mp_groundsupport_05_boardingstarted_BHQ_1", "mp_groundsupport_05_boardingstarted_BHQ_2"]]
		,[toLowerANSI "BoardingEnded", 		["mp_groundsupport_10_boardingended_BHQ_0", "mp_groundsupport_10_boardingended_BHQ_1", "mp_groundsupport_10_boardingended_BHQ_2"]]
		,[toLowerANSI "CrewMemberInjured", 	["RadioMsgStatic"]]
	]]
	//-- Custom radio messages 
	,[toLowerANSI DEF_RADIO_TRANSMISSION_PREFIX_GODSPEED_NIGGA, createHashMapFromArray [
		 [toLowerANSI "Arty_North", 		["artillery_north"]]
		,[toLowerANSI "Arty_North_East", 	["artillery_north_east"]]
		,[toLowerANSI "Arty_East", 			["artillery_east"]]
		,[toLowerANSI "Arty_South_East", 	["artillery_south_east"]]
		,[toLowerANSI "Arty_South", 		["artillery_south"]]
		,[toLowerANSI "Arty_South_West", 	["artillery_south_west"]]
		,[toLowerANSI "Arty_West", 			["artillery_west"]]
		,[toLowerANSI "Arty_North_West", 	["artillery_north_west"]]
		
		,[toLowerANSI "Napalm_North", 		["napalm_north"]]
		,[toLowerANSI "Napalm_North_East", 	["napalm_north_east"]]
		,[toLowerANSI "Napalm_East", 		["napalm_east"]]
		,[toLowerANSI "Napalm_South_East", 	["napalm_south_east"]]
		,[toLowerANSI "Napalm_South", 		["napalm_south"]]
		,[toLowerANSI "Napalm_South_West", 	["napalm_south_west"]]
		,[toLowerANSI "Napalm_West", 		["napalm_west"]]
		,[toLowerANSI "Napalm_North_West", 	["napalm_north_west"]]
		
		,[toLowerANSI "Introduction", 		["introduction_1", "introduction_2", "introduction_3"]]
		,[toLowerANSI "Replacement", 		["replacement_1"]] 												// TODO cfgRadio
		,[toLowerANSI "RefuelAndResupply", 	["resupply_1"]] 												// TODO cfgRadio
		,[toLowerANSI "Returned", 			["returned_1", "returned_2", "returned_3"]]
		
		//,[toLowerANSI "RequestCAS", 		["RadioMsgStatic"]]
		//,[toLowerANSI "InboundCAS", 		["RadioMsgStatic"]]
		//,[toLowerANSI "ChopperDown", 		["RadioMsgStatic"]]
		//,[toLowerANSI "BoardingStarted", 	["RadioMsgStatic"]]
		//,[toLowerANSI "BoardingEnded", 		["RadioMsgStatic"]]
		
		,[toLowerANSI "InjuredCrewChief", 	["injured_crew_chief_1"]]
		,[toLowerANSI "InjuredCopilot", 	["injured_copilot_1"]]
		,[toLowerANSI "Injured", 			["injured_1"]]
		,[toLowerANSI "Damaged", 			["vehicle_damaged_1"]]
	]]
];


private _dictionary = _data get DEF_RADIO_TRANSMISSION_PREFIX_NONE;
if ((toLowerANSI _prefix) in _data) then {
	_dictionary = _data get toLowerANSI _prefix;
};


private _text = "";
private _cfgRadio = "RadioMsgStatic";


if ( (toLowerANSI _messageType) in _dictionary ) then 
{
	private _pool = _dictionary get toLowerANSI _messageType;
	
	switch (toLowerANSI _messageType) do {
		case toLowerANSI "InjuredCrewChief": { _prefix = (_prefix splitString "_" select 0); };
		case toLowerANSI "InjuredCopilot": { _prefix = (_prefix splitString "_" select 0); };
		case toLowerANSI "Injured": { _prefix = (_prefix splitString "_" select 0); };
		case toLowerANSI "Damaged": { _prefix = (_prefix splitString "_" select 0); };
		default {};
	};
	
	_cfgRadio = _prefix + "_" + selectRandom _pool;
	if (isText(ConfigFile >> "CfgRadio" >> _cfgRadio >> "text")) then {
		private _str = getText (ConfigFile >> "CfgRadio" >> _cfgRadio >> "text");
		_text = _str;
	};
	diag_log format ["TransmitOverRadio: %1", _cfgRadio];
};


if (_speaker isEqualTo objNull && _prefix isNotEqualTo "") then 
{
	if (_prefix find "_" > 0) then {
		_prefix = _prefix splitString "_" select 0;
	};
	
	private _isClass = isClass(ConfigFile >> "CfgHQIdentities" >> _prefix);
	if (_isClass) then {
		_speaker = _prefix;
	};
};


[[_side, _cfgRadio, _text, _vehicle, _speaker], {
	
	if !(hasInterface) exitWith {};
	
	params ["_side", "_cfgRadio", "_text", "_vehicle", "_speaker"];
	
	private _canReceiveMessage = false;
	
	if !(isNull _vehicle) then {
		// If the target of the message is a specific vehicle, check if it has radio comm system and player is in it
		if (_vehicle call FS_fnc_HasCommSystem && (DEF_CURRENT_PLAYER == _vehicle || DEF_CURRENT_PLAYER in _vehicle)) then {
			_canReceiveMessage = true;
		};
	} else {
		// If the message is being broadcasted to everybody (not only 1 vehicle) then check if player has radio or RTO backpack
		if (DEF_CURRENT_PLAYER call FS_fnc_CanReceive) then {
			_canReceiveMessage = true;
		};
	};
	
	if !( _canReceiveMessage ) exitWith {};
	
	if (DEF_CURRENT_PLAYER call FS_fnc_CanTransmit) then {
		//-- Play a nice 2D radio sound
		if ( _speaker isEqualType "" ) then {
			if (_cfgRadio isNotEqualTo "") then {	[_side, _speaker] sideRadio _cfgRadio;	};
			if (_text isNotEqualTo "") then 	{	[_side, _speaker] sideChat _text;		};
		} else {
			if (_cfgRadio isNotEqualTo "") then {	[_side, "HQ"] sideRadio _cfgRadio;		};
			if (_text isNotEqualTo "") then 	{	_speaker sideChat _text;				};
		};
	} else {
		//-- Emit 3D radio sounds from the receivers in range
		private _3Dspeakers = DEF_CURRENT_PLAYER call FS_fnc_CanReceiveFrom;
		{ _x say3D _cfgRadio } forEach _3Dspeakers;
	};
	
}] remoteExec ["call", 0];
