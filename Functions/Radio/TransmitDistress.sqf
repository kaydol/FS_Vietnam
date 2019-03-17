
params ["_caller"];

if !( _caller call FS_fnc_HasRadioAround ) exitWith {};

if ( _caller getVariable ["DISTRESSED", False] ) exitWith {};

[_caller, "DISTRESSED", True, 180, nil, True] spawn FS_fnc_SetVarLifespan;

// [side _caller, "RequestCAS"] remoteExec ["FS_fnc_TransmitOverRadio", 2];

/*
"to_c01_m01_brief_001_br_briefing_a_OLYMPOS_0"
okay

"to_c02_m02_brief_002_br_inf_briefing_GUARDIAN_12"
alright

"to_c02_m02_brief_006_br_sf_briefing_out_GUARDIAN_4"
ok gentlemen

"to_c03_m01_brief_001_br_briefing_BOWKER_20"
the fuck

"to_c03_m01_brief_001_br_briefing_PILOT02_2"
mayday

"to_c03_m02_brief_001_br_briefing_COLLINS_12"
shit

"to_c03_m02_brief_001_br_briefing_COLLINS_2"
casualtiees are high ...

 "to_c03_m02_brief_001_br_briefing_PARIAH_6"
 exactly
  
 "to_c03_m03_brief_001_br_briefing_a_BARKLEM_0"
 um yes sir
 
 "to_c03_m03_brief_001_br_briefing_a_COLLINS_0"
 sir
 
 "to_c03_m03_brief_007_br_briefing_c_GUARDIAN_0"
 alright then
 */
 