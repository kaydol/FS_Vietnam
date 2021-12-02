
params ["_module"];

RADIOCOMMS_OBJECTS_WITH_COMMS = _module getVariable "EntitiesWithComms";
RADIOCOMMS_AUDIBLE_RADIUS = _module getVariable "AudibleRadius";
RADIOCOMMS_ITEMS_BACKPACKS = _module getVariable "RTOItemsAndBackpacks";
RADIOCOMMS_REQUIRE_RANKING_OFFICER = _module getVariable "RequireRankingOfficer";
RADIOCOMMS_ENABLE_BROKEN_ARROW = _module getVariable "EnableBrokenArrow";

if (RADIOCOMMS_OBJECTS_WITH_COMMS 	isEqualType "") then { RADIOCOMMS_OBJECTS_WITH_COMMS = call compile RADIOCOMMS_OBJECTS_WITH_COMMS; };
if (RADIOCOMMS_ITEMS_BACKPACKS 		isEqualType "") then { RADIOCOMMS_ITEMS_BACKPACKS = call compile RADIOCOMMS_ITEMS_BACKPACKS; };
