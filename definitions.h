
//-- Used to define whether unit has any wire mines or punjis
//-- Also used in the function that makes unit place a mine
#define DEF_PUT_MUZZLE_WIREMINE "ClassicMineWireMuzzle"
#define DEF_PUT_MUZZLE_PUNJI "vn_punji_muzzle"

//-- The ambush is spawned in range between current direction of movement +- cone angle / 2
//-- Value of zero will only spawn ambushes dead ahead, while 180 may occasionally spawn ambushes abeam 
#define DEF_GOOK_MANAGER_AMBUSH_CONE_ANGLE 30

//-- Prefer sappers, so they would lay down traps in front of the advancing enemy cluster 
//#define DEF_GOOK_MANAGER_AMBUSH_PROPOSED_CLASSES ["vn_o_men_vc_local_09","vn_o_men_vc_local_23","vn_o_men_vc_local_30","vn_o_men_vc_09","vn_o_men_vc_regional_09", "vn_o_men_vc_local_10","vn_o_men_vc_local_24","vn_o_men_vc_local_31","vn_o_men_vc_local_11","vn_o_men_vc_local_04","vn_o_men_vc_local_12"]

//-- Places in forest next to trees, far from houses or water
#define DEF_GOOK_MANAGER_TRAPS_BEST_PLACES "(forest + 2*trees) * (1-houses) * (1-sea) * (1-(waterDepth interpolate [0,1,0,100]))"
#define DEF_GOOK_MANAGER_BUILDINGS_BEST_PLACES "forest*meadow*(1-trees)*(1-houses)*(1-sea)*(1-(waterDepth interpolate [0,1,0,100]))"
#define DEF_GOOK_MANAGER_VEHICLES_BEST_PLACES "forest*(1-meadow)*(1-trees)*(1-houses)*(1-sea)*(1-(waterDepth interpolate [0,1,0,100]))"

//-- Prefer semi-auto snipers because of the custom script for their ROF in FSM
#define DEF_TREE_SNIPERS ["vn_o_men_vc_10", "vn_o_men_vc_regional_10", "vn_o_men_nva_65_24"]

#define DEF_GC_EXCLUDE_VAR "ExcludeFromGarbageCollector"
#define DEF_GC_EXCLUDE_GROUP_VAR "ExcludeGroupFromGarbageCollector"

#define DEF_SNIPER_FSM_HANDLE "SniperFSM"

#define DEF_CURRENT_PLAYER (missionNameSpace getVariable ["bis_fnc_moduleRemoteControl_unit", player])
