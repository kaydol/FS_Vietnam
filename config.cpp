
class CfgPatches
{
	class FS_Vietnam
	{
		//-- Units available to spawn as Zeus must be in units[]
		//-- Of course, they didn't write about it on the wiki
		units[] = {"FS_NapalmCAS_Module", "FS_ArtyStrike_Module", "FS_ForceToPlaceTraps_Module"};
		weapons[] = {};
		requiredAddons[] = {"A3_Data_F", "A3_Weapons_F_Mark", "weapons_f_vietnam_c"};
		requiredVersion = 0.100000;
		author = "kaydol";
		url = "";
	};
};

class CfgMusic {
	tracks[] = {""};
	class arsenal_1 {
		name = "FS Arsenal Theme";
		sound[] = {"\FS_Vietnam\Music\arsenal_1.ogg", db+0, 1.0};
	};
	class arsenal_2 {
		name = "FS Arsenal Theme";
		sound[] = {"\FS_Vietnam\Music\arsenal_2.ogg", db+0, 1.0};
	};
	class arsenal_3 {
		name = "FS Arsenal Theme";
		sound[] = {"\FS_Vietnam\Music\arsenal_3.ogg", db+0, 1.0};
	};
	class arsenal_4 {
		name = "FS Arsenal Theme";
		sound[] = {"\FS_Vietnam\Music\arsenal_4.ogg", db+0, 1.0};
	};
	class arsenal_5 {
		name = "FS Arsenal Theme";
		sound[] = {"\FS_Vietnam\Music\arsenal_5.ogg", db+0, 1.0};
	};
	class arsenal_6 {
		name = "FS Arsenal Theme";
		sound[] = {"\FS_Vietnam\Music\arsenal_6.ogg", db+0, 1.0};
	};
	class arsenal_7 {
		name = "FS Arsenal Theme";
		sound[] = {"\FS_Vietnam\Music\arsenal_7.ogg", db+0, 1.0};
	};
	class arsenal_8 {
		name = "FS Arsenal Theme";
		sound[] = {"\FS_Vietnam\Music\arsenal_8.ogg", db+0, 1.0};
	};
	class arsenal_9 {
		name = "FS Arsenal Theme";
		sound[] = {"\FS_Vietnam\Music\arsenal_9.ogg", db+0, 1.0};
	};
	class arsenal_10 {
		name = "FS Arsenal Theme";
		sound[] = {"\FS_Vietnam\Music\arsenal_10.ogg", db+0, 1.0};
	};
};


/*
	Artillery & Napalm sounds
*/
class CfgSounds {
	
	#include "SupportSounds.hpp"

};


/*
	Editor category
*/
class CfgFactionClasses {
	class NO_CATEGORY;	
	class FS_Vietnam : NO_CATEGORY {
		displayName = "FS Vietnam Modules";
		author = "kaydol";
		//icon = "";
	};
};

class CfgCloudlets {
	class Default;
	class MediumSmoke;
	class NapalmVictim : MediumSmoke {
		interval = 0.5;
		lifeTime = 2;
		rubbing = 0.025;
		size[] = {1.2,2.5};
	};
	class FS_ScriptedNapalmExplosion : Default {
		size[] = {0};
		interval = 1000;
		lifeTime = 0;
		beforeDestroyScript = "\FS_Vietnam\Effects\Napalm\CustomNapalm.sqf";
	};
	
};

class vn_vfx_napalm_container_explosion_effect {
	class Scripted {
		simulation = "particles";
		type = "FS_ScriptedNapalmExplosion";
		lifeTime = 1;
	};
	class vn_vfx_napalm_vehicle_explosion_TrailEffect {
		simulation = "particles";
		type = "vn_vfx_napalm_vehicle_explosion_TrailEffect";
		position[] = {0,0,0};
		intensity = 1;
		interval = 1;
		lifeTime = 0.5;
	};
	class vn_vfx_napalm_vehicle_explosion_ShardsEffect {
		simulation = "particles";
		type = "vn_vfx_napalm_vehicle_explosion_ShardsEffect";
		position[] = {0,5,0};
		intensity = 2;
		interval = 1;
		lifeTime = 3;
		qualityLevel = 2;
	};
	class vn_vfx_napalm_vehicle_explosion_CloudPlusDamage {
		simulation = "particles";
		type = "vn_vfx_napalm_vehicle_explosion_CloudPlusDamage";
		position[] = {0,0,0};
		intensity = 0.9;
		interval = 1;
		lifeTime = 10;
	};
	class vn_vfx_Napalm_ExpSparksBig {
		simulation = "particles";
		type = "ExpSparks";
		position[] = {0,0,0};
		intensity = 1;
		interval = 1;
		lifeTime = 2;
		enabled = "distToWater interpolate [0,0.0001,-1,1]";
	};
	class vn_vfx_Napalm_fire_linger {
		simulation = "particles";
		type = "vn_vfx_napalm_fire_linger";
		position[] = {0,0,0};
		intensity = 1;
		interval = 1;
		start = 2;
		enable = 1;
		lifeTime = 15;
	};
	class vn_vfx_Napalm_LightExpBig {
		simulation = "light";
		type = "ExploLight";
		position[] = {0,1.5,0};
		intensity = 0.001;
		interval = 1;
		lifeTime = 34;
	};
	class vn_vfx_Napalm_Explosion1Big {
		simulation = "particles";
		type = "VehExplosionParticles";
		position[] = {0,0,0};
		intensity = 1;
		interval = 1;
		lifeTime = 0.2;
	};
	class vn_vfx_Napalm_Explosion2Big {
		simulation = "particles";
		type = "FireBallBright";
		position[] = {0,0,0};
		intensity = 1;
		interval = 1;
		lifeTime = 1;
	};
	class vn_vfx_Napalm_Smoke1Big {
		simulation = "particles";
		type = "VehExpSmoke";
		position[] = {0,0,0};
		intensity = 1;
		interval = 2;
		start = 2;
		lifeTime = 15;
	};
	class vn_vfx_Napalm_SmallSmoke1Big {
		simulation = "particles";
		type = "VehExpSmoke2";
		position[] = {0,0,0};
		intensity = 1;
		interval = 2;
		start = 2;
		lifeTime = 25;
	};
	class vn_vfx_Napalm_Refract {
		simulation = "particles";
		type = "ObjectDestructionRefractSmall";
		position[] = {0,0,0};
		intensity = 0.15;
		interval = 1;
		lifeTime = 20;
		start = 2;
	};
};

class CfgVehicles 
{
	/*
		Modules
	*/
	class Logic;
	class Module_F: Logic
	{
		class AttributesBase
		{
			class Default;
			class Edit; // Default edit box (i.e., text input field)
			class Combo; // Default combo box (i.e., drop-down menu)
			class Checkbox; // Default checkbox (returned value is Bool)
			class CheckboxNumber; // Default checkbox (returned value is Number)
			class ModuleDescription; // Module description
			class Units; // Selection of units on which the module is applied
		};
		// Description base classes
		class ModuleDescription
		{
			class Anything; // Any object - persons, vehicles, static objects, etc.
			class AnyBrain; // Any AI or player. Not empty objects
			class EmptyDetector; // Any trigger
			class AnyPerson; // Any person. Not vehicles or static objects.
			class AnyVehicle; // Any vehicle. No persons or static objects.
			class GroupModifiers; // ?
			class AnyStaticObject; // Any static object. Not persons or vehicles.
			class AnyAI; //	Any AI unit. Not players or empty objects
			class AnyPlayer; // Any player. Not AI units or empty objects
		};
	};
	
	class FS_Vietnam_Module : Module_F {
		author = "kaydol";
		scope = 1;
		is3DEN = 0;
		isGlobal = 0; // 0 for server only execution, 1 for global execution, 2 for persistent global execution
		displayName = "FS Vietnam Module";
		category = "FS_Vietnam";
	};
	
	class FS_AirBase_Module : FS_Vietnam_Module {
		_generalMacro = "FS_AirBase_Module";
		icon = "\a3\Missions_F_Curator\data\img\iconMPTypeSectorControl_ca.paa";
		portrait = "\a3\Missions_F_Curator\data\img\portraitMPTypeSectorControl_ca.paa";
		scope = 2;
		displayName = "Helicopter Air Base";
		function = "FS_fnc_ModuleCreateAirBase";
		class ModuleDescription : ModuleDescription {
			description = "This module is required for Vietnam helicopter crews.";
			sync[] = {"RespawnPoints", "Side"};
			position = 1;
			direction = 0;
			class RespawnPoints {
				description[] = { // Multi-line descriptions are supported
					"Respawn Points define where the crew replacements will be spawned. After spawn, they will run to the helicopter and board it, replacing the dead crew. Consider placing respawn points in tents or houses, unless you want the crew to spawn in the open. If no RP were provided, the new crew teleports directly into transport."
				};
				position = 1; // Position is taken into effect
				direction = 0; // Direction is taken into effect
				optional = 1; // Synced entity is optional
				duplicate = 1; // Multiple entities of this type can be synced
				synced[] = {"LocationRespawnPoint_F"}; 
			};
			class Side {
				description[] = { // Multi-line descriptions are supported
					"This module requires to be synced with a Side who owns it.",
					"Make sure only one side is synced, or you may get unexpected results.",
					"If no side was synced, the error will be displayed.",
				};
				position = 0; // Position is taken into effect
				direction = 0; // Direction is taken into effect
				optional = 0; // Synced entity is optional
				duplicate = 0; // Multiple entities of this type can be synced
				synced[] = {"SideBLUFOR_F", "SideOPFOR_F", "SideResistance_F"}; 
			};
		};
		class Attributes : AttributesBase {
			class ProvidesMaintenance : Checkbox {
				property = "ProvidesMaintenance";
				displayName = "Refuel, rearm, repair, heal";
				tooltip = "Landing helicopters will be refueled, rearmed & repaired; the crew will be healed";
				typeName = "BOOL";
				defaultValue = "true"; 
			};
			class ProvidesCrew : Checkbox {
				property = "ProvidesCrew";
				displayName = "Replace dead crew";
				tooltip = "Sync Respawn Points to spawn new crew there and then make them run and board the helicopter. If no RPs were synced, the new crew will be teleported into the helicopter directly.";
				typeName = "BOOL";
				defaultValue = "true"; 
			};
			class RefuelRearmTime : Edit {
				property = "RefuelRearmTime";
				displayName = "Maintenance time";
				tooltip = "How much time is needed to refuel, rearm, repair and heal up.";
				typeName = "NUMBER";
				defaultValue = 60;
			};
			class ModuleDescription : ModuleDescription {};
		};
	};
	
	class FS_AirCommand_Module : FS_Vietnam_Module {
		_generalMacro = "FS_AirCommand_Module";
		icon = "\a3\Modules_f\data\iconHQ_ca.paa";
		portrait = "\a3\Modules_f\data\portraitHQ_ca.paa";
		scope = 2;
		isTriggerActivated = 1;
		displayName = "Air Command";
		function = "FS_fnc_ModuleAirCommand";
		class ModuleDescription : ModuleDescription {
			description = "This module takes control of synced helicopters. It is possible to activate this module with a trigger.";
			sync[] = {"Helicopters"};
			class Helicopters {
				description[] = { // Multi-line descriptions are supported
					"Helicopters."
				};
				position = 1; // Position is taken into effect
				direction = 1; // Direction is taken into effect
				optional = 1; // Synced entity is optional
				duplicate = 1; // Multiple entities of this type can be synced
				synced[] = {"Air"}; 
			};
		};
		class Attributes : AttributesBase {
			class AssessmentRate : Edit {
				property = "assessmentRate";
				displayName = "Assessment rate";
				tooltip = "Minimum time between pilot's assessments of the battlefield. Based on his assessment, the pilot decides if the use of airstrike and artillery is warranted. Decreasing this may negatively impact performance.";
				typeName = "NUMBER";
				defaultValue = 20;
			};
			class ArtilleryThreshold : Edit {
				property = "artilleryThreshold";
				displayName = "Concentration for artillery strike";
				tooltip = "Minimum concentration of enemies for the pilot to consider an artillery strike.";
				typeName = "NUMBER";
				defaultValue = 10;
			};
			class ArtilleryCooldown : Edit {
				property = "artilleryCooldown";
				displayName = "Artillery cooldown";
				tooltip = "Minimum time between artillery call-ins by the pilots.";
				typeName = "NUMBER";
				defaultValue = 120;
			};
			class ArtilleryMinDist : Edit {
				property = "artilleryMinDist";
				displayName = "Artillery minimum distance";
				tooltip = "Minimum distance between the center of a cluster of enemies and the nearest friendly unit while considering an artillery strike. Low values may result in casualties from friendly fire.";
				typeName = "NUMBER";
				defaultValue = 120;
			};
			class NapalmThreshold : Edit {
				property = "napalmThreshold";
				displayName = "Concentration for napalm strike";
				tooltip = "Minimum concetration of enemies for the pilot to consider a napalm strike.";
				typeName = "NUMBER";
				defaultValue = 15;
			};
			class NapalmCooldown : Edit {
				property = "napalmCooldown";
				displayName = "Napalm cooldown";
				tooltip = "Minimum time between napalm call-ins by the pilots.";
				typeName = "NUMBER";
				defaultValue = 300;
			};
			class NapalmMinDist : Edit {
				property = "napalmMinDist";
				displayName = "Napalm minimum distance";
				tooltip = "Minimum distance between the center of a cluster of enemies and the nearest friendly unit while considering a napalm strike. Low values may result in casualties from friendly fire.";
				typeName = "NUMBER";
				defaultValue = 150;
			};
			class AnnounceOnInit : Checkbox {
				property = "announceOnInit";
				displayName = "Announce activation";
				tooltip = "A radio message will be played when the module is first activated.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class Debug : Checkbox {
				property = "debug";
				displayName = "Debug";
				tooltip = "Enable debug information.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class ModuleDescription : ModuleDescription {};
		};
	};
	
	class FS_GookManager_Module : FS_Vietnam_Module {
		_generalMacro = "FS_GookManager_Module";
		icon = "A3\Modules_F_Tacops\Data\CivilianPresence\icon32_ca.paa";
		portrait = "A3\Modules_F_Tacops\Data\CivilianPresence\icon32_ca.paa";
		scope = 2;
		displayName = "Gook Manager";
		function = "FS_fnc_ModuleGookManager";
		class ModuleDescription : ModuleDescription {
			description = "This module spawns Vietnamese around players.";
			sync[] = {};
		};
		class Attributes : AttributesBase {
			class AssignedCurator : Edit {
				property = "AssignedCurator";
				displayName = "Assigned Zeus Module";
				tooltip = "Variable name of 'Zeus' module. Curator specified in the 'Zeus' module will be able to edit Gooks spawned by Gook Manager. Leave empty if you don't want Gooks that were spawned by Manager to be editable.";
				defaultValue = "objNull";
			};
			class AILimit : Edit {
				property = "AILimit";
				displayName = "AI limit";
				tooltip = "How many alive Gooks can be present on the map simultaneously. Reduce to ease lags, increase if you have a very powerful CPU.";
				typeName = "NUMBER";
				defaultValue = 50;
			};
			class GroupSize : Edit {
				property = "GroupSize";
				displayName = "Group Size";
				tooltip = "How many Gooks will be spawned per group. Reduce to spawn a high amount of small groups, increase to spawn a small amount of large groups. Better keep this in 5-12 range, because the game's engine struggles with operating huge groups effectively.";
				typeName = "NUMBER";
				defaultValue = 6;
			};
			class GroupSizeVar : Edit {
				property = "GroupSizeVar";
				displayName = "Group Size random addition";
				tooltip = "";
				typeName = "NUMBER";
				defaultValue = 6;
			};
			class GroupsCount : Edit {
				property = "GroupsCount";
				displayName = "Groups Count";
				tooltip = "How many groups of Gooks can be spawned at once.";
				typeName = "NUMBER";
				defaultValue = 2;
			};
			class GroupsCountVar : Edit {
				property = "GroupsCountVar";
				displayName = "Groups Count random addition";
				tooltip = "";
				typeName = "NUMBER";
				defaultValue = 1;
			};
			class SpawnCondition : Edit {
				property = "SpawnCondition";
				displayName = "Spawn Condition";
				tooltip = "Condition that has to be true in order for this module to spawn a group of Gooks. Condition is evaluated every Assessment Rate seconds.";
				defaultValue = "true";
			};
			class Sleep : Edit {
				property = "Sleep";
				displayName = "Assessment Rate";
				tooltip = "The Manager evaluates Spawn Condition to decide whether to spawn a group of Gooks or not, then spawns it if the condition is true. After that, the Manager waits some time, then the whole thing is repeated. This number defines how much time passes between condition evaluations.";
				typeName = "NUMBER";
				defaultValue = 30;
			};
			class SniperTreeClasses : Edit {
				property = "SniperTreeClasses";
				displayName = "Sniper Tree classes";
				tooltip = "These buildings may be spawned in front of moving targets. Intended for sniper trees, but you can put any building with defined buildingPositions here. A sniper with special behavior will be placed in the building. Leave as [] to disable.";
				defaultValue = "['Land_vn_o_snipertree_01','Land_vn_o_snipertree_02','Land_vn_o_snipertree_03','Land_vn_o_snipertree_04']";
			};
			class VehicleClasses : Edit {
				property = "VehicleClasses";
				displayName = "Vehicle classes";
				tooltip = "These vehicles may be spawned in front of moving targets. Intended for spider holes (which are essentially static turrets), but you can put any crewed vehicle classes here. Leave as [] to disable.";
				defaultValue = "['vn_o_vc_spiderhole_01','vn_o_vc_spiderhole_02','vn_o_vc_spiderhole_03','vn_o_nva_spiderhole_01','vn_o_nva_spiderhole_02','vn_o_nva_spiderhole_03']";
			};
			class SpawnDistanceMoving : Edit {
				property = "SpawnDistanceMoving";
				displayName = "Spawn Distance (target moving)";
				tooltip = "Spawn distance when a group of players that is about to be attacked is on the move (when players have been moving through jungle for some time, etc). If players are moving, Gooks are always spawned in their path. When Garbage Collector module is present, be mindful of Gook removal distance to avoid spawned Gooks being instantly removed due to players being too far.";
				typeName = "NUMBER";
				defaultValue = 200;
			};
			class SpawnDistanceStationary : Edit {
				property = "SpawnDistanceStationary";
				displayName = "Spawn Distance (target stationary)";
				tooltip = "Spawn distance when a group of players that is about to be attacked is stationary (when players are defending a spot). When players are stationary, Gooks are spawned randomly on the circle with this radius. When Garbage Collector module is present, be mindful of Gook removal distance to avoid spawned Gooks being instantly removed due to players being too far.";
				typeName = "NUMBER";
				defaultValue = 300;
			};
			class Debug : Checkbox {
				property = "Debug";
				displayName = "Debug";
				tooltip = "Enable debug information.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class RevealTrapsToSides : Edit {
				property = "RevealTrapsToSides";
				displayName = "Reveal Traps to sides";
				tooltip = "This affects mines placed by the vietnamese. Mines are always revealed to the side that placed it. You can add other sides to the list (for debug purposes).";
				typeName = "STRING";
				defaultValue = "[]";
			};
			class ModuleDescription : ModuleDescription {};
		};
	};
	
	class FS_GookArea_Module : FS_Vietnam_Module {
		_generalMacro = "FS_GookArea_Module";
		icon = "A3\Modules_F_Tacops\Data\CivilianPresenceSafeSpot\icon32_ca.paa";
		portrait = "A3\Modules_F_Tacops\Data\CivilianPresenceSafeSpot\icon32_ca.paa";
		scope = 2;
		is3DEN = 1;
		displayName = "Define Gook-free Area";
		function = "FS_fnc_ModuleGookArea";
		class ModuleDescription : ModuleDescription {
			description = "This module affects where Vietnamese can or can't be spawned.";
			sync[] = {};
			position = 1;
			direction = 0; 
		};
		class Attributes : AttributesBase {
			class Radius : Edit {
				property = "Radius";
				displayName = "Radius";
				tooltip = "Gook Manager Module will not spawn any gooks in this area.";
				typeName = "NUMBER";
				defaultValue = 400;
			};
			class ModuleDescription : ModuleDescription {};
		};
	};
	
	class FS_Arsenal_Module : FS_Vietnam_Module {
		_generalMacro = "FS_Arsenal_Module";
		scope = 2;
		isGlobal = 2; // Persistent global execution
		isTriggerActivated = 1;
		displayName = "Arsenal Room";
		function = "FS_fnc_ModuleArsenal";
		isDisposable = 0; // 1 if modules is to be disabled once it's activated (i.e., repeated trigger activation won't work)
		class ModuleDescription : ModuleDescription {
			description = "This module opens a Virtual Arsenal. It is possible to activate this module with a trigger.";
			sync[] = {};
		};
		class Attributes : AttributesBase {
			class AllowAll : Checkbox {
				property = "allowAll";
				displayName = "Add all";
				tooltip = "Add all available weapons, magazines, items and backpacks. Disable if you want to whitelist only specific items. Whitelisting can be done elsewhere, e.g. directly in init.sqf.";
				typeName = "BOOL";
				defaultValue = "true"; 
			};
			class RespawnLoadout : Checkbox {
				property = "respawnLoadout";
				displayName = "Respawn loadout";
				tooltip = "Your gear is saved as your respawn kit each time you exit the Arsenal.";
				typeName = "BOOL";
				defaultValue = "true"; 
			};
			class RespawnLoadoutMsgStyle : Combo {
				property = "respawnLoadoutMsgStyle";
				displayName = "Notification style";
				tooltip = "Defines how 'Loadout saved' messages are shown. These messages only appear if 'Respawn loadout' is checked.";
				typeName = "NUMBER";
				class values
				{
					class WS {
						name = "Western Sahara style (BIS_fnc_textTiles)";
						value = 1;
						default = 1;
					};
					class Vanilla {
						name = "Old (BIS_fnc_showNotification)";
						value = 0;
					};
				};
			};
			class ModuleDescription : ModuleDescription {};
		};
	};
	
	class FS_GarbageCollector_Module : FS_Vietnam_Module {
		_generalMacro = "FS_GarbageCollector_Module";
		icon = "\a3\Modules_f\data\iconRespawn_ca.paa";
		portrait = "\a3\Modules_f\data\portraitRespawn_ca.paa";
		scope = 2;
		displayName = "Garbage Collector";
		function = "FS_fnc_ModuleGarbageCollector";
		class ModuleDescription : ModuleDescription {
			description = "This module deletes unnecessary objects.";
			sync[] = {};
		};
		class Attributes : AttributesBase {
			class RemoveDead : Edit {
				property = "removeDead";
				displayName = "Dead bodies removal distance";
				tooltip = "Minimum distance between players and dead bodies in order for the latter to be removed. Use -1 to disable.";
				typeName = "NUMBER";
				defaultValue = 300;
			};
			class TrapsRemovalDistance : Edit {
				property = "trapsRemovalDistance";
				displayName = "Traps removal distance";
				tooltip = "Remove traps that are too far from any of the players. Use -1 to disable traps removal.";
				typeName = "NUMBER";
				defaultValue = 300; 
			};
			class TrapsThreshold : Edit {
				property = "trapsThreshold";
				displayName = "Traps threshold";
				tooltip = "Remove random trap once their amount goes beyond threshold and the new one is placed. Use -1 to disable threshold.";
				typeName = "NUMBER";
				defaultValue = 40;
			};
			class RemovalDistance : Edit {
				property = "removalDistance";
				displayName = "Removal distance";
				tooltip = "Entities that are too far from any of the players will be mercilessly deleted. Make sure this value is greater than Spawn Distance in Gook Manager, otherwise enemies spawned by the Gook Manager will be deleted right after spawn. Use -1 to disable removal.";
				typeName = "NUMBER";
				defaultValue = 300;
			};
			class SidesToRemove : Edit {
				property = "SidesToRemove";
				displayName = "Sides to remove";
				toolTip = "These sides can be removed by the Garbage Collector when certain conditions are true.";
				typeName = "STRING";
				defaultValue = "[EAST, CIVILIAN, INDEPENDENT]";
			};
			class RemovePreplaced : Checkbox {
				property = "removePreplaced";
				displayName = "Remove preplaced groups and vehicles";
				tooltip = "If unchecked, units in preplaced EAST side groups won't be deleted due to distance checks. Does not affect preplaced mines, because they always stay until destroyed or picked up.";
				typeName = "BOOL";
				defaultValue = "false"; 
			};
			class Debug : Checkbox {
				property = "Debug";
				displayName = "Debug";
				tooltip = "Enable debug information.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class ModuleDescription : ModuleDescription {};
		};
	};
	
	class FS_NapalmSettings_Module : FS_Vietnam_Module {
		_generalMacro = "FS_NapalmSettings_Module";
		scope = 2;
		isGlobal = 2; // Persistent global execution
		displayName = "Napalm Settings";
		function = "FS_fnc_ModuleNapalmSettings";
		class ModuleDescription : ModuleDescription {
			description = "This module configures napalm settings.";
			sync[] = {};
		};
		class Attributes : AttributesBase {
			class Enable : Checkbox {
				property = "Enable";
				displayName = "Enable";
				tooltip = "If enabled, napalm bombs will have an additional scripted effects, which can be customized.";
				typeName = "BOOL";
				defaultValue = "true"; //true - 1, false - 0
			};
			class NapalmBombRadius : Edit {
				property = "NapalmBombRadius";
				displayName = "Napalm Bomb Radius";
				tooltip = "Everything within this radius from the bomb impact instantly dies. A fire circle is then spawned to mark the enflamed area.";
				typeName = "NUMBER";
				defaultValue = 40;
			};
			class DeleteVegetation : Checkbox {
				property = "DeleteVegetation";
				displayName = "Delete Vegetation";
				tooltip = "If true, vegetation will be gradually deleted during Napalm Lifetime.";
				typeName = "BOOL";
				defaultValue = "true"; //true - 1, false - 0
			};
			class SpawnCrater : Checkbox {
				property = "SpawnCrater";
				displayName = "Burn Ground";
				tooltip = "If true, the ground will appear burned after the napalm effect ends. Due to some technical limitations, the size of the burned spot is not scalable and has a radius of ~35 meters.";
				typeName = "BOOL";
				defaultValue = "true"; //true - 1, false - 0
			};
			class NapalmLifeTime : Edit {
				property = "NapalmLifeTime";
				displayName = "Napalm Lifetime";
				tooltip = "Historically, napalm burn time varied from 15 seconds up to 10 minutes, depending on the chemical composition.";
				typeName = "NUMBER";
				defaultValue = 40;
			};
			class NapalmDamage : Edit {
				property = "NapalmDamage";
				displayName = "Napalm Damage";
				tooltip = "Damage per Tick.";
				typeName = "NUMBER";
				defaultValue = 0.4;
			};
			class NapalmTickRate : Edit {
				property = "NapalmTickRate";
				displayName = "Napalm Tick Rate";
				tooltip = "How much time is passed between dealing damage to the objects inside Napalm Bomb Radius, in seconds.";
				typeName = "NUMBER";
				defaultValue = 1;
			};
			class MakeVictimsScream : Checkbox {
				property = "MakeVictimsScream";
				displayName = "Make Victims Scream";
				tooltip = "";
				typeName = "BOOL";
				defaultValue = "true"; //true - 1, false - 0
			};
			class VictimsSmokeTime : Edit {
				property = "VictimsSmokeTime";
				displayName = "Victims Smoke Time";
				tooltip = "Dead bodies will start smoking after the napalm effect ends. Set to 0 if you don't want any smoke.";
				typeName = "NUMBER";
				defaultValue = 40;
			};
			class ModuleDescription : ModuleDescription {};
		};
	};
	
	class FS_NapalmCAS_Module : FS_Vietnam_Module {
		_generalMacro = "FS_NapalmCAS_Module";
		icon = "\a3\Modules_F_Curator\Data\iconCAS_ca.paa";
		scope = 2;
		scopeCurator = 2;
		curatorCanAttach = 0;
		curatorCost = 20;
		isGlobal = 1;
		isTriggerActivated = 1;
		portrait = "\a3\Modules_F_Curator\Data\portraitCAS_ca.paa";
		displayName = "Napalm CAS";
		function = "FS_fnc_ModuleNapalmCAS";
		class ModuleDescription : ModuleDescription {
			description = "It is possible to activate this module with a trigger.";
			sync[] = {};
			position = 1;
			direction = 1; 
		};
		class Attributes : AttributesBase {
			class Vehicle : Combo {
				property = "Vehicle";
				displayName = "Plane";
				tooltip = "";
				typeName = "STRING";
				class values
				{
					class vn_b_air_f4b_navy_cas {
						name = "F4B Phantom II (CAS)";
						value = "vn_b_air_f4b_navy_cas";
						default = 1;
					};
				};
			};
			class Type : Combo {
				property = "Type";
				displayName = "Support type";
				tooltip = "";
				typeName = "NUMBER";
				class values
				{
					class Bombs {
						name = "Napalm bombs";
						value = 3;
						default = 1;
					};
				};
			};
			class Debug : Checkbox {
				property = "Debug";
				displayName = "Debug";
				tooltip = "";
				typeName = "BOOL";
				defaultValue = "false"; //true - 1, false - 0
			};
			class ModuleDescription : ModuleDescription {};
		};
	};
	
	class FS_ArtyStrike_Module : FS_Vietnam_Module {
		_generalMacro = "FS_ArtyStrike_Module";
		icon = "\a3\Modules_F_Curator\Data\iconOrdnance_ca.paa";
		scope = 2;
		scopeCurator = 2;
		curatorCanAttach = 0;
		curatorCost = 50;
		isGlobal = 1;
		isTriggerActivated = 1;
		portrait = "\a3\Modules_F_Curator\Data\portraitOrdnance_ca.paa";
		displayName = "Artillery Strike";
		function = "FS_fnc_ModuleArtyStrike";
		class ModuleDescription : ModuleDescription {
			description = "It is possible to activate this module with a trigger.";
			sync[] = {};
			position = 1;
			direction = 0; 
		};
		class Attributes : AttributesBase {
			class Type : Combo {
				property = "Type";
				displayName = "Type";
				tooltip = "";
				typeName = "STRING";
				class values
				{
					class Sh_82mm_AMOS {
						name = "82mm AMOS";
						value = "Sh_82mm_AMOS";
						default = 1;
					};
				};
			};
			class Salvos : Edit {
				property = "Salvos";
				displayName = "Salvos";
				tooltip = "";
				typeName = "NUMBER";
				defaultValue = 5;
			};
			class Radius : Edit {
				property = "Radius";
				displayName = "Radius";
				tooltip = "";
				typeName = "NUMBER";
				defaultValue = 30;
			};
			class Height : Edit {
				property = "Height";
				displayName = "Height";
				tooltip = "";
				typeName = "NUMBER";
				defaultValue = 150;
			};
			class InitDelay : Edit {
				property = "InitDelay";
				displayName = "Delay before first round";
				tooltip = "";
				typeName = "NUMBER";
				defaultValue = 0;
			};
			class Debug : Checkbox {
				property = "Debug";
				displayName = "Debug";
				tooltip = "";
				typeName = "BOOL";
				defaultValue = "false"; //true - 1, false - 0
			};
			class ModuleDescription : ModuleDescription {};
		};
	};
	
	class FS_ForceToPlaceTraps_Module : FS_Vietnam_Module {
		_generalMacro = "FS_ForceToPlaceTraps_Module";
		icon = "\a3\Modules_F_Curator\Data\iconOrdnance_ca.paa";
		scope = 2;
		scopeCurator = 2;
		curatorCanAttach = 0;
		curatorCost = 0;
		isGlobal = 0;
		isTriggerActivated = 1;
		displayName = "Force Sappers to Place Traps";
		function = "FS_fnc_ModuleForceSappersToPlaceTraps";
		class ModuleDescription : ModuleDescription {
			description = "This module forces synchronized groups to place traps. The mines can be deleted by Garbage Collector module. This module is intended to be used primarily by Zeus, who can sync spawned groups to this module to force them to place traps. It is possible to activate this module with a trigger.";
			sync[] = {"MAN"};
			position = 0;
			direction = 0; 
		};
		class Attributes : AttributesBase {
			class ModuleDescription : ModuleDescription {};
		};
	};
	
	class FS_Jukebox_Module : FS_Vietnam_Module {
		_generalMacro = "FS_Jukebox_Module";
		scope = 2;
		displayName = "Jukebox";
		function = "FS_fnc_ModuleJukebox";
		isDisposable = 1; // 1 if modules is to be disabled once it's activated (i.e., repeated trigger activation won't work)
		isGlobal = 2; // 0 for server only execution, 1 for global execution, 2 for persistent global execution
		isTriggerActivated = 1;
		class ModuleDescription : ModuleDescription {
			description = "Module that runs on server and plays music for all connected clients. It is possible to activate this module with a trigger.";
			sync[] = {};
		};
		class Attributes : AttributesBase {
			class AnnounceTracks : Checkbox { //["Default"]
				property = "AnnounceTracks";
				displayName = "Announce tracks";
				tooltip = "Announce track names in system chat.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class PlayLocally : Checkbox { //["Default"]
				property = "PlayLocally";
				displayName = "Run locally";
				tooltip = "The module will run independently for each client, allowing for everybody to have music at different time rather than the timings being controlled by the server.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class Preset: Combo {
				property = "Preset";
				displayName = "Preset";
				tooltip = "A quick way to setup the general mood of the tracks played."; // Tooltip description
				typeName = "NUMBER";
				class Values
				{
					class Arsenal {
						name = "Arsenal Room tracks";
						value = 0;
						default = 1;
					};
					class Custom {
						name = "Custom tracks";
						value = 3;
					};
				};
			};
			class CustomTracks: Edit {
				property = "CustomTracks";
				displayName = "Custom tracks";
				tooltip = "If preset is set to Custom, the tracks from this array are played instead.";
				defaultValue = "['LeadTrack01_F_EPA', 'LeadTrack04_F_EPC']";
			};	
			class StartCondition: Edit {
				property = "StartCondition";
				displayName = "Start condition";
				tooltip = "Condition that has to be true in order for this module to start working. Condition is checked every second and only on Server.";
				defaultValue = "true";
			};
			class StopCondition: Edit {
				property = "StopCondition";
				displayName = "Stop condition";
				tooltip = "Condition that has to be true in order for this module to stop working, after which the module will delete itself. Condition is checked every second and only on Server.";
				defaultValue = "false";
			};
			class LoopConditions : Checkbox { //["Default"]
				property = "LoopConditions";
				displayName = "Loop conditions";
				tooltip = "If enabled, instead of deleting itself, the module will restart after Stop Condition turned true. It allows a cycle: Start Condition -> Stop Condition -> Start Condition -> etc. Use this if you want to be able to stop and resume the work of the module.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class StopMusic : Checkbox { //["Default"]
				property = "StopMusic";
				displayName = "Stop music on Stop Condition";
				tooltip = "The track that was playing when Stop Condition evaluated true will be silenced. May need to enable ACE compatibility for this one.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class DisableACEVolumeUpdate : Checkbox { //["Default"]
				property = "DisableACEVolumeUpdate";
				displayName = "ACE compatibility";
				tooltip = "ACE addon deafness system overrides smooth music volume changes, resulting in arsenal music ending abruptly. When enabled, this will disable ACE's deafness while the player is in the arsenal, then enable it back after the music was silenced.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class ModuleDescription : ModuleDescription {};
		};
	};
	
	class FS_MaintenanceSettings_Module : FS_Vietnam_Module {
		_generalMacro = "FS_MaintenanceSettings_Module";
		scope = 2;
		isGlobal = 2; // Persistent global execution
		displayName = "Helicopter Maintenance Settings";
		function = "FS_fnc_ModuleMaintenanceSettings";
		class ModuleDescription : ModuleDescription {
			description = "This module configures helicopter maintenance settings.";
			sync[] = {};
		};
		class Attributes : AttributesBase {
			class HealAt : Edit {
				property = "HealAt";
				displayName = "Max crew damage";
				tooltip = "How badly one of the crew mates has to be wounded in order for the pilot to abandon the station and try to get medical help on the air base that provides medical help.";
				typeName = "NUMBER";
				defaultValue = 0.35;
			};
			class RefuelAt : Edit {
				property = "RefuelAt";
				displayName = "Refuel at";
				tooltip = "The pilot will abandon station if he has less fuel than this value.";
				typeName = "NUMBER";
				defaultValue = 0.2;
			};
			class RepairAt : Edit {
				property = "RepairAt";
				displayName = "Repair at";
				tooltip = "How badly the helicopter should be damaged in order for the pilot to abandon station.";
				typeName = "NUMBER";
				defaultValue = 0.5;
			};
			class RepairEffectiveness : Edit {
				property = "RepairEffectiveness";
				displayName = "The effectiveness of repairings";
				tooltip = "How well the helicopters are repaired when receiving maintenance. Maximum value - 1 (fully repaired), minimum value - the value of 'Repair at', otherwise you will be stuck in an infinite loop!";
				typeName = "NUMBER";
				defaultValue = 0.75;
			};
			class AISoftLanding : Checkbox {
				property = "AISoftLanding";
				displayName = "Soft landing for AI";
				tooltip = "AI pilots tend to slam their helicopters into the ground, damaging it in the process. Enabling this will give them a short god mode for several seconds during landing and until they landed.";
				typeName = "BOOL";
				defaultValue = "true";
			};
			class ModuleDescription : ModuleDescription {};
		};
	};
	
	class FS_RadioSettings_Module : FS_Vietnam_Module {
		_generalMacro = "FS_RadioSettings_Module";
		icon = "\a3\Modules_F_Curator\Data\iconRadioChannelCreate_ca.paa";
		scope = 2;
		isGlobal = 2; // Persistent global execution
		displayName = "Radio Settings";
		function = "FS_fnc_ModuleRadioSettings";
		class ModuleDescription : ModuleDescription {
			description = "This module configures the custom radio communication system that was written from scratch specifically for this addon. There are two levels of radio access - units that are able to receive and units that are able to both receive and transmit. Only RTOs and vehicles with radio comms can transmit. Groups with RTOs are made known to pilots and can request air and artillery support. The location of units in these groups is considered by pilots when assigning targets for CAS, artillery strikes and napalm. Units from groups that have no RTOs and members of which weren't directly spotted by pilots may die due to friendly firemissions being too close to them.";
			sync[] = {};
		};
		class Attributes : AttributesBase {
			class ObjectsWithComms : Edit {
				property = "ObjectsWithComms";
				displayName = "Entities with built-in radio comms";
				tooltip = "An array of entities that grant nearby units access to the radio communication system, which enables them to transmit and receive addon-specific messages over radio.";
				defaultValue = "['Air', 'Tank', 'uns_willys_base', 'Land_vn_b_trench_bunker_03_04']";
			};
			class AudibleRadius : Edit {
				property = "AudibleRadius";
				displayName = "Audible radius";
				tooltip = "Units within this distance from RTOs or objects & vehicles specified in the field above will be given access to comms.";
				typeName = "NUMBER";
				defaultValue = 10;
			};
			class RTOItemsAndBackpacks : Edit {
				property = "RTOItemsAndBackpacks";
				displayName = "RTO items and backpacks";
				tooltip = "Items and backpacks that give full access to comms. Units with these items or backpacks are considered Radio Telephone Operators (RTOs).";
				defaultValue = "['vn_b_pack_03_02_xm177_pl', 'vn_o_pack_t884_01', 'vn_b_pack_trp_04_02', 'vn_o_pack_t884_01', 'vn_b_pack_03_xm177_pl', 'vn_b_pack_lw_06', 'vn_b_pack_lw_06_m16_pl', 'vn_b_pack_prc77_01', 'vn_b_pack_03_02', 'vn_b_pack_03', 'vn_b_pack_t884_01', 'vn_b_pack_trp_04', 'UNS_ItemRadio_PRC_25', 'UNS_NVA_RTO', 'UNS_ARMY_RTO', 'UNS_ARMY_RTO2', 'UNS_SF_RTO', 'UNS_Alice_FR', 'UNS_USMC_RTO', 'UNS_USMC_RTO2']";
			};
			class RequireRankingOfficer : Checkbox {
				property = "RequireRankingOfficer";
				displayName = "Require Ranking Officer";
				tooltip = "Some support missions can be called only by a ranking officer. Ranking officer is the most senior officer in the group.";
				typeName = "BOOL";
				defaultValue = "true";
			};
			class EnableBrokenArrow : Checkbox {
				property = "EnableBrokenArrow";
				displayName = "Enable Broken Arrow callsign";
				tooltip = "Units with radio comms may call Broken Arrow. Broken Arrow is a special callsign that means 'Friendly unit is in danger of being overrun and will be KIA unless urgent action is taken'. Units that called Broken Arrow are treated with much higher priority when assigning escort missions to pilots. Escort mission is when a pilot is stationed above a known group of friendly units to provide aerial assistance.";
				typeName = "BOOL";
				defaultValue = "true";
			};
			class ModuleDescription : ModuleDescription {};
		};
	};
	
	class FS_RespawnPoint_Module : FS_Vietnam_Module {
		_generalMacro = "FS_RespawnPoint_Module";
		scope = 2;
		displayName = "Respawn Point";
		function = "FS_fnc_ModuleRespawnPoint";
		isDisposable = 1; // 1 if modules is to be disabled once it's activated (i.e., repeated trigger activation won't work)
		isGlobal = 0; // 0 for server only execution, 1 for global execution, 2 for persistent global execution
		isTriggerActivated = 1;
		class ModuleDescription : ModuleDescription {
			description = "This module essentually creates marker(s) named 'respawn_side_xxxxxx'. Marker(s) only exist as long as the condition is true. Side is defined by a synced Side logic. Synced vehicles have markers attached to them. If no vehicles are synced before module starts, module's position is used instead. It is possible to add and remove synchronized objects during gameplay (if module's position was used as spawn point, it will be deleted when first vehicle is synchronized). It is possible to activate this module with a trigger.";
			sync[] = {"Vehicles", "Side"};
			position = 1;
			direction = 0;
			class Vehicles {
				description[] = { // Multi-line descriptions are supported
					"This module can be synced with vehicles both at the start of the mission and on the fly. If no vehicle is synced before module starts, module's position is used as respawn point instead."
				};
				position = 1; // Position is taken into effect
				direction = 0; // Direction is taken into effect
				optional = 1; // Synced entity is optional
				duplicate = 1; // Multiple entities of this type can be synced
				synced[] = {"CAR", "TANK", "SEA", "AIR"}; 
			};
			class Side {
				description[] = { // Multi-line descriptions are supported
					"This module requires to be synced with a Side who owns it.",
					"Make sure only one side is synced, or you may get unexpected results.",
					"If no side was synced, the error will be displayed.",
				};
				position = 0; // Position is taken into effect
				direction = 0; // Direction is taken into effect
				optional = 0; // Synced entity is optional
				duplicate = 0; // Multiple entities of this type can be synced
				synced[] = {"SideBLUFOR_F", "SideOPFOR_F", "SideResistance_F"}; 
			};
			class LocationRespawnPoint_F {
				description[] = { // Multi-line descriptions are supported
					"If LocationRespawnPoint_F is synced, the players will be spawned on its place instead.",
					"If multiple LocationRespawnPoint_F are synced, a random one will be chosen.",
				};
				position = 1; // Position is taken into effect
				direction = 0; // Direction is taken into effect
				optional = 1; // Synced entity is optional
				duplicate = 1; // Multiple entities of this type can be synced
				synced[] = {"LocationRespawnPoint_F"}; 
			};
		};
		class Attributes : AttributesBase {
			class VehicleMustBeAlive : Checkbox {
				property = "VehicleMustBeAlive";
				displayName = "Vehicle destruction deletes spawn";
				tooltip = "If synced vehicle is destroyed, the spawn point that was attached to it will be deleted (otherwise spawn point will remain at the vehicle's last position).";
				typeName = "BOOL";
				defaultValue = "true";
			};
			class OverrideStopCondition : Checkbox {
				property = "OverrideStopCondition";
				displayName = "Override Stop condition";
				tooltip = "If 'Vehicle destruction deletes spawn' is enabled and if vehicles were synchronized before module starts, exit the module when no alive vehicles are left. If you don't enable this option, the module will wait until Stop Condition turns true before exiting.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class DeleteOldBody : Checkbox {
				property = "DeleteOldBody";
				displayName = "Delete old body";
				tooltip = "Delete body of the respawned person.";
				typeName = "BOOL";
				defaultValue = "true";
			};
			class SpawnAsPassenger : Checkbox {
				property = "SpawnAsPassenger";
				displayName = "Spawn as passenger";
				tooltip = "If vehicles are synchronized, attempt to spawn player as passenger (vehicle must be alive), otherwise player will spawn in general vicinity of the vehicle. Disables respawn animations from the field below.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class RespawnAnimations : Edit {
				property = "RespawnAnimations";
				displayName = "Animations to play when respawned";
				tooltip = "When players respawn on this spawn point on foot, make them play one of these randomly chosen animations. Leave as [] to disable. The animation will not be played for players in vehicles.";
				defaultValue = "['Acts_Getting_Up_Player', 'Acts_Flashes_Recovery_1', 'Acts_Flashes_Recovery_2']";
			};
			class LandSearchRadius : Edit {
				property = "LandSearchRadius";
				displayName = "Land search radius";
				tooltip = "If 'Spawn as passenger' is disabled and player spawns in water, look for the nearest land and teleport the player there. Respawn animation is only played when spawned on, or teleported to, land. This parameter is designed to spawn players on banks of the river if their respawn point happened to be in the river. Do not use this in open sea where the land is too far. A good way to determine this value would be to divide the maximum expected river wideness by 1.75";
				typeName = "NUMBER";
				defaultValue = "0";
			};
			class RespawnFromDarkness : Edit {
				property = "RespawnFromDarkness";
				displayName = "Respawn from darkness";
				tooltip = "Waking up effect when players respawn on this spawn point. Set to 0 to disable. Adds a customizable duration of cutText 'BLACK IN' command upon respawn, which looks like a 'waking up' effect.";
				typeName = "NUMBER";
				defaultValue = "0";
			};
			class GodModeLength : Edit {
				property = "GodModeLength";
				displayName = "God mode time";
				tooltip = "Makes respawned players immune to damage for this amount of seconds. Good to combine this with visual effects that add color tint.";
				typeName = "NUMBER";
				defaultValue = "0";
			};
			class VFXLength : Edit {
				property = "VFXLength";
				displayName = "Visual effect length";
				tooltip = "";
				typeName = "NUMBER";
				defaultValue = "0";
			};
			class VFXPreset : Combo {
				property = "VFXPreset";
				displayName = "Visual effect preset";
				tooltip = "Here you can select predefined color tints if you don't want to mess with the field below.";
				class values
				{
					class Custom {
						name = "Use value from the field below";
						value = "[]";
						default = 1;
					};
					class RedTint {
						name = "Red tint";
						value = "[8.0, 0.8, 0.8, 0.7]";
					};
					class GreenTint {
						name = "Green tint";
						value = "[0.8, 8.0, 0.8, 0.7]";
					};
					class BlueTint {
						name = "Blue tint";
						value = "[0.8, 0.8, 8.0, 0.7]";
					};
				};
			};
			class VFXCustom : Edit {
				property = "VFXCustom";
				displayName = "Visual effect color";
				tooltip = "Custom color in format [R,G,B,ALPHA]. ALPHA is basically effect strength.";
				defaultValue = "[]";
			};
			class ActivationNotification : Checkbox {
				property = "ActivationNotification";
				displayName = "Show activation notification";
				tooltip = "";
				typeName = "BOOL";
				defaultValue = "true";
			};
			class DeactivationNotification : Checkbox {
				property = "DeactivationNotification";
				displayName = "Show deactivation notification";
				tooltip = "";
				typeName = "BOOL";
				defaultValue = "true";
			};
			class Sleep : Edit {
				property = "Sleep";
				displayName = "Sleep";
				tooltip = "Interval between condition checks in seconds. This value directly defines how often Respawn Point positions are updated to match current positions of synced vehicles. If you have no need to check condition\move respawn points very often, or have a very heavy condition function, you can show mercy to your server and increase this value.";
				typeName = "NUMBER";
				defaultValue = 3;
			};
			class StartCondition: Edit {
				property = "StartCondition";
				displayName = "Start condition";
				tooltip = "Condition that has to be true in order for this module to start working. Condition is checked only on Server.";
				defaultValue = "true";
			};
			class StopCondition: Edit {
				property = "StopCondition";
				displayName = "Stop condition";
				tooltip = "Condition that has to be true in order for this module to stop working, after which all created Spawn Points will be removed and the module will delete itself. Condition is checked only on Server.";
				defaultValue = "false";
			};
			class LoopConditions : Checkbox { //["Default"]
				property = "LoopConditions";
				displayName = "Loop conditions";
				tooltip = "If enabled, instead of deleting itself, the module will restart after Stop Condition turned true. It allows a cycle: Start Condition -> Stop Condition -> Start Condition -> etc. Use this if you want to be able to stop and resume the work of the module.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class ModuleDescription : ModuleDescription {};
		};
	};
	
	
	class FS_ModuleAtmosphereChanger : FS_Vietnam_Module {
		_generalMacro = "FS_ModuleAtmosphereChanger";
		scope = 2;
		scopeCurator = 2;
		is3DEN = 1;
		isDisposable = 1; // 1 if modules is to be disabled once it's activated (i.e., repeated trigger activation won't work)
		isGlobal = 2; // 0 for server only execution, 1 for global execution, 2 for persistent global execution
		displayName = "Atmosphere Changer";
		function = "FS_fnc_ModuleAtmosphereChanger";
		isTriggerActivated = 1; // 1 for module waiting until all synced triggers are activated
		class ModuleDescription : ModuleDescription {
			description = "Module that can change how atmosphere looks when certain conditions are met or when player enters certain areas.";
			sync[] = {};
			class EmptyDetector : EmptyDetector {
				optional = 1;
			};
		};
		class Attributes : AttributesBase {
			class Rain: CheckboxNumber {
				property = "ModuleAtmosphereChanger_Rain";
				displayName = "Rain";
				tooltip = "Enables rain.";
				typeName = "NUMBER";
				defaultValue = "1";
			};
			class CCPreset: Combo {
				property = "ModuleAtmosphereChanger_Preset";
				displayName = "Color Correction preset"; 
				tooltip = "";
				typeName = "NUMBER"; 
				defaultValue = "0";
				class Values
				{
					class Option_00 {
						name = "No color correction";
						value = 0;
						default = 1;
					};
					class Option_01 {
						name = "Custom";
						value = 1;
					};
					class Option_02 {
						name = "Darken";
						value = 2;
					};
					class Option_03 {
						name = "Yellow";
						value = 3;
					};
				};
			};
			class CCCustomTint: Edit {
				property = "ModuleAtmosphereChanger_CCCustomTint";
				displayName = "Custom Color Correction";
				tooltip = "Format is [Red, Green, Blue, Brightness]. The bigger the color number, the more prevalent this color component will be. In other words, for the picture to have green tint, make the Green component slightly bigger than the other two.";
				defaultValue = "[0.0,0.0,0.0,0.0]";
			};
			class Fog: CheckboxNumber {
				property = "ModuleAtmosphereChanger_Fog";
				displayName = "Enable Fog";
				tooltip = "";
				defaultValue = "1";
			};
			class FogParams: Edit {
				property = "ModuleAtmosphereChanger_FogParams";
				displayName = "Fog Parameters";
				tooltip = "Format is [_fogValue, _fogDecay]. Height of the fog is adjusted automatically with the Z coordinate of the viewer.";
				defaultValue = "[0.2, 0.001]";
			};
			class EnableDust: CheckboxNumber {
				property = "ModuleAtmosphereChanger_EnableDust";
				displayName = "Enable Dust Clouds";
				tooltip = "";
				defaultValue = "1";
			};
			class Radius : Edit {
				property = "ModuleAtmosphereChanger_Radius";
				displayName = "Radius";
				tooltip = "If this is > 0, the atmospheric changes will occur only while the player is within this radius. If radius = 0, the changes are happening globally on the whole map.";
				typeName = "NUMBER";
				defaultValue = 0;
			};
			class TransitionTime : Edit {
				property = "ModuleAtmosphereChanger_TransitionTime";
				displayName = "Transition Time";
				tooltip = "A value of 0 means instant weather\color\fog change.";
				typeName = "NUMBER";
				defaultValue = 3;
			};
			class StartCondition: Edit {
				property = "ModuleAtmosphereChanger_StartCondition";
				displayName = "Start condition";
				tooltip = "Condition that has to be true in order for this module to start working. Condition is checked every second, locally.";
				defaultValue = "true";
			};
			class StopCondition: Edit {
				property = "ModuleAtmosphereChanger_StopCondition";
				displayName = "Stop condition";
				tooltip = "Condition that has to be true in order for this module to stop working, after which the module will delete itself. Condition is checked every second, locally.";
				defaultValue = "false";
			};
			class LoopConditions : CheckboxNumber { //["Default"]
				property = "ModuleAtmosphereChanger_LoopConditions";
				displayName = "Loop conditions";
				tooltip = "If enabled, instead of deleting itself, the module will restart after Stop Condition turned true. It allows a cycle: Start Condition -> Stop Condition -> Start Condition -> etc. Use this if you want to be able to stop and resume the work of the module.";
				typeName = "NUMBER";
				defaultValue = 1;
			};
			class ModuleDescription : ModuleDescription {};
		};
	};
	
	
	class FS_GodmodeSynchronizer_Module : FS_Vietnam_Module {
		_generalMacro = "FS_GodmodeSynchronizer_Module";
		scope = 2;
		isGlobal = 2; // Persistent global execution
		displayName = "Godmode Synchronizer Module";
		function = "FS_fnc_ModuleGodmodeSynchronizer";
		class ModuleDescription : ModuleDescription {
			description = "Use this when you want to give an object a godmode (allowDamage=false) for X amount of seconds and you have multiple sources of godmode that can possibly interfere with each other. If you don't know what that is, then you don't need it. This module runs on each machine and manages godmode for local units. Refer to the comments in module's function for more info.";
			sync[] = {};
		};
		class Attributes : AttributesBase {
			class ModuleDescription : ModuleDescription {};
		};
	};
};


class CfgFunctions 
{
	class FS {
		
		class Math {
			class AgglomerativeClustering {file = "\FS_Vietnam\Functions\Math\AgglomerativeClustering.sqf";};
			class BiggestClusterDiameter {file = "\FS_Vietnam\Functions\Math\BiggestClusterDiameter.sqf";};
			class CalculateCenter2D {file = "\FS_Vietnam\Functions\Math\CalculateCenter2D.sqf";};
			class Clusterize {file = "\FS_Vietnam\Functions\Math\Clusterize.sqf";};
			class kMeansClustering {file = "\FS_Vietnam\Functions\Math\kMeansClustering.sqf";};
		};
		
		class Misc {
			class DirectionWrapper {file = "\FS_Vietnam\Functions\Misc\DirectionWrapper.sqf";};
			class DistanceBetweenArrays {file = "\FS_Vietnam\Functions\Misc\DistanceBetweenArrays.sqf";};
			class GetSideVariable {file = "\FS_Vietnam\Functions\Misc\GetSideVariable.sqf";};
			class ObjectsGrabber {file = "\FS_Vietnam\Functions\Misc\ObjectsGrabber.sqf";};
			class ObjectsMapper {file = "\FS_Vietnam\Functions\Misc\ObjectsMapper.sqf";};
			class QueueCreate {file = "\FS_Vietnam\Functions\Misc\QueueCreate.sqf";};
			class QueueDispose {file = "\FS_Vietnam\Functions\Misc\QueueDispose.sqf";};
			class QueueGetData {file = "\FS_Vietnam\Functions\Misc\QueueGetData.sqf";};
			class QueueGetSize {file = "\FS_Vietnam\Functions\Misc\QueueGetSize.sqf";};
			class QueuePush {file = "\FS_Vietnam\Functions\Misc\QueuePush.sqf";};
			class SetVarLifespan {file = "\FS_Vietnam\Functions\Misc\SetVarLifespan.sqf";};
			class ShakeCam {file = "\FS_Vietnam\Functions\Misc\ShakeCam.sqf";};
			class ShowMessage {file = "\FS_Vietnam\Functions\Misc\ShowMessage.sqf";};
			class SnapshotWrapper {file = "\FS_Vietnam\Functions\Misc\SnapshotWrapper.sqf";};
			class Snapshots {file = "\FS_Vietnam\Functions\Misc\Snapshots.sqf";};
			class UpdateSideVariable {file = "\FS_Vietnam\Functions\Misc\UpdateSideVariable.sqf";};
			class VisualizeBestPlaces {file = "\FS_Vietnam\Functions\Misc\VisualizeBestPlaces.sqf";};
		};
		
		class Helicopters {
			class Asses {file = "\FS_Vietnam\Functions\Helicopters\Asses.sqf";};
			class AssignFireTask {file = "\FS_Vietnam\Functions\Helicopters\AssignFireTask.sqf";};
			class AssignPriorities {file = "\FS_Vietnam\Functions\Helicopters\AssignPriorities.sqf";};
			class AssignWaypoints {file = "\FS_Vietnam\Functions\Helicopters\AssignWaypoints.sqf";};
			class CanPerformDuties {file = "\FS_Vietnam\Functions\Helicopters\CanPerformDuties.sqf";};
			class ChooseTarget {file = "\FS_Vietnam\Functions\Helicopters\ChooseTarget.sqf";};
			class FinalizeTarget {file = "\FS_Vietnam\Functions\Helicopters\FinalizeTarget.sqf";};
			class GetFriendlyUnits {file = "\FS_Vietnam\Functions\Helicopters\GetFriendlyUnits.sqf";};
			class GetHostileUnits {file = "\FS_Vietnam\Functions\Helicopters\GetHostileUnits.sqf";};
			class IsEnoughDaylight {file = "\FS_Vietnam\Functions\Helicopters\IsEnoughDaylight.sqf";};
			class IsMaintenanceNeeded {file = "\FS_Vietnam\Functions\Helicopters\IsMaintenanceNeeded.sqf";};
			class IsScrambleNeeded {file = "\FS_Vietnam\Functions\Helicopters\IsScrambleNeeded.sqf";};
			class IsStationTaken {file = "\FS_Vietnam\Functions\Helicopters\IsStationTaken.sqf";};
			class LeaveTheArea {file = "\FS_Vietnam\Functions\Helicopters\LeaveTheArea.sqf";};
			class LoachInit {file = "\FS_Vietnam\Functions\Helicopters\LoachInit.sqf";};
			class ReloadAndRefuel {file = "\FS_Vietnam\Functions\Helicopters\ReloadAndRefuel.sqf";};
			class Scramble {file = "\FS_Vietnam\Functions\Helicopters\Scramble.sqf";};
			class SurvivedPilots {file = "\FS_Vietnam\Functions\Helicopters\SurvivedPilots.sqf";};
			class ValidateTarget {file = "\FS_Vietnam\Functions\Helicopters\ValidateTarget.sqf";};
		};
		
		class Support {
			class DropMines {file = "\FS_Vietnam\Effects\Artillery\DropMines.sqf";};
			class DropNapalm {file = "\FS_Vietnam\Effects\Napalm\DropNapalm.sqf";};
			class FallingDirt {file = "\FS_Vietnam\Effects\Artillery\FallingDirt.sqf";};
			class NapalmAfterEffect {file = "\FS_Vietnam\Effects\Napalm\NapalmAfterEffect.sqf";};
			class NapalmBurnedAlive {file = "\FS_Vietnam\Effects\Napalm\NapalmBurnedAlive.sqf";};
			class NapalmCreateExplosion {file = "\FS_Vietnam\Effects\Napalm\NapalmCreateExplosion.sqf";};
			class NapalmPhosphorusStrands {file = "\FS_Vietnam\Effects\Napalm\NapalmPhosphorusStrands.sqf";};
			class NapalmPuffAndSparks {file = "\FS_Vietnam\Effects\Napalm\NapalmPuffAndSparks.sqf";};
		};
		
		class Traps {
			class PutEventHandler {file = "\FS_Vietnam\Functions\Traps\PutEventHandler.sqf";};
		};
		
		class Markers {
			class CreateDebugMarker {file = "\FS_Vietnam\Functions\Markers\CreateDebugMarker.sqf";};
			class FadeDebugMarkers {file = "\FS_Vietnam\Functions\Markers\FadeDebugMarkers.sqf";};
			class GrpAttachDebugMarkers {file = "\FS_Vietnam\Functions\Markers\GrpAttachDebugMarkers.sqf";};
		};
		
		class Radio {
			class AddCommsMenu {file = "\FS_Vietnam\Functions\Radio\AddCommsMenu.sqf";};
			class CanReceive {file = "\FS_Vietnam\Functions\Radio\CanReceive.sqf";};
			class CanTransmit {file = "\FS_Vietnam\Functions\Radio\CanTransmit.sqf";};
			class HasCommSystem {file = "\FS_Vietnam\Functions\Radio\HasCommSystem.sqf";};
			class IsRankingOfficer {file = "\FS_Vietnam\Functions\Radio\IsRankingOfficer.sqf";};
			class TransmitDistress {file = "\FS_Vietnam\Functions\Radio\TransmitDistress.sqf";};
			class TransmitOverRadio {file = "\FS_Vietnam\Functions\Radio\TransmitOverRadio.sqf";};
			class TransmitSitrep {file = "\FS_Vietnam\Functions\Radio\TransmitSitrep.sqf";};
		};
		
		class Behaviour {
			class AttackPlanner {file = "\FS_Vietnam\Functions\Behaviour\AttackPlanner.sqf";};
			class FilterObjects {file = "\FS_Vietnam\Functions\Behaviour\FilterObjects.sqf";};
			class GetHiddenPos {file = "\FS_Vietnam\Functions\Behaviour\GetHiddenPos.sqf";};
			class GetHiddenPos2 {file = "\FS_Vietnam\Functions\Behaviour\GetHiddenPos2.sqf";};
			class GookSenses {file = "\FS_Vietnam\Functions\Behaviour\GookSenses.sqf";};
			class GrpFiredNear {file = "\FS_Vietnam\Functions\Behaviour\GrpFiredNear.sqf";};
			class GrpFiredNearExec {file = "\FS_Vietnam\Functions\Behaviour\GrpFiredNearExec.sqf";};
			class GrpHideInTrees {file = "\FS_Vietnam\Functions\Behaviour\GrpHideInTrees.sqf";};
			class GrpNearestEnemy {file = "\FS_Vietnam\Functions\Behaviour\GrpNearestEnemy.sqf";};
			class GrpPlaceTraps {file = "\FS_Vietnam\Functions\Behaviour\GrpPlaceTraps.sqf";};
			class IsEnoughSuspense {file = "\FS_Vietnam\Functions\Behaviour\IsEnoughSuspense.sqf";};
			class IsGroupSpotted {file = "\FS_Vietnam\Functions\Behaviour\IsGroupSpotted.sqf";};
			class IsPlaceSafe {file = "\FS_Vietnam\Functions\Behaviour\IsPlaceSafe.sqf";};
			class IsPosHidden {file = "\FS_Vietnam\Functions\Behaviour\IsPosHidden.sqf";};
			class OccupyTree {file = "\FS_Vietnam\Functions\Behaviour\OccupyTree.sqf";};
			class PlaceTrap {file = "\FS_Vietnam\Functions\Behaviour\PlaceTrap.sqf";};
			class SpawnGooks {file = "\FS_Vietnam\Functions\Behaviour\SpawnGooks.sqf";};
			class Suspense {file = "\FS_Vietnam\Functions\Behaviour\Suspense.sqf";};
			class TrySpawnObjectBestPlaces {file = "\FS_Vietnam\Functions\Behaviour\TrySpawnObjectBestPlaces.sqf";};
			class UnitsReady {file = "\FS_Vietnam\Functions\Behaviour\UnitsReady.sqf";};
		};
		
		class Modules {
			class ArsenalRoom {file = "\FS_Vietnam\Functions\Modules\ArsenalRoom.sqf";};
			class ArsenalRoomCreate {file = "\FS_Vietnam\Functions\Modules\ArsenalRoomCreate.sqf";};
			class AuthenticLoadout {file = "\FS_Vietnam\Functions\Modules\AuthenticLoadout.sqf";};
			class GetModuleOwner {file = "\FS_Vietnam\Functions\Modules\GetModuleOwner.sqf";};
			class JukeboxPlayMusic {file = "\FS_Vietnam\Functions\Modules\JukeboxPlayMusic.sqf";};
			class ModuleAtmosphereChanger {file = "\FS_Vietnam\Functions\Modules\ModuleAtmosphereChanger.sqf"; };
			class ModuleAirCommand {file = "\FS_Vietnam\Functions\Modules\ModuleAirCommand.sqf";};
			class ModuleArsenal {file = "\FS_Vietnam\Functions\Modules\ModuleArsenal.sqf";};
			class ModuleArtyStrike {file = "\FS_Vietnam\Functions\Modules\ModuleArtyStrike.sqf";};
			class ModuleCreateAirBase {file = "\FS_Vietnam\Functions\Modules\ModuleCreateAirBase.sqf";};
			class ModuleForceSappersToPlaceTraps {file = "\FS_Vietnam\Functions\Modules\ModuleForceSappersToPlaceTraps.sqf";};
			class ModuleGarbageCollector {file = "\FS_Vietnam\Functions\Modules\ModuleGarbageCollector.sqf";};
			class ModuleGookArea {file = "\FS_Vietnam\Functions\Modules\ModuleGookArea.sqf";};
			class ModuleGookManager {file = "\FS_Vietnam\Functions\Modules\ModuleGookManager.sqf";};
			class ModuleJukebox {file = "\FS_Vietnam\Functions\Modules\ModuleJukebox.sqf";};
			class ModuleMaintenanceSettings {file = "\FS_Vietnam\Functions\Modules\ModuleMaintenanceSettings.sqf";};
			class ModuleNapalmCAS {file = "\FS_Vietnam\Functions\Modules\ModuleNapalmCAS.sqf";};
			class ModuleNapalmSettings {file = "\FS_Vietnam\Functions\Modules\ModuleNapalmSettings.sqf";};
			class ModuleRadioSettings {file = "\FS_Vietnam\Functions\Modules\ModuleRadioSettings.sqf";};
			class AddGodmodeTimespan {file = "\FS_Vietnam\Functions\Modules\AddGodmodeTimespan.sqf";};
			class ModuleGodmodeSynchronizer {file = "\FS_Vietnam\Functions\Modules\ModuleGodmodeSynchronizer.sqf";};
			class ModuleRespawnPoint {file = "\FS_Vietnam\Functions\Modules\ModuleRespawnPoint.sqf";};
			class VisualizeModuleRadius3DEN {file = "\FS_Vietnam\Functions\Modules\VisualizeModuleRadius3DEN.sqf";};
		};
	};
};

class CfgAmmo {
	class DirectionalBombBase;
	// from weapons_f_vietnam_c
	class vn_mine_ammobox_range_ammo : DirectionalBombBase { //["DirectionalBombCore","TimeBombCore","Default"]
		mineInconspicuousness = 500;
	};
};

class Mode_SemiAuto;
class Mode_FullAuto;
class CfgWeapons 
{
	// Allow AI to fire RPGs at helicopters
	class Launcher;
    class Launcher_Base_F: Launcher {
        class WeaponSlotsInfo;
    };
    class Launch_RPG7_F : Launcher_Base_F {
        class Single : Mode_SemiAuto {
            aiDispersionCoefX = 1.8;
            aiDispersionCoefY = 2.3;
            aiRateOfFireDispersion = 10;
            aiRateOfFireDistance = 300;
            maxRange = 400;
            maxRangeProbab = 0.4;
            midRange = 250;
            midRangeProbab = 0.9;
            minRange = 5;
            minRangeProbab = 0.56;
            recoil = "recoil_single_law";
            sounds[] = {"StandardSound"};
        };
    };
    class launch_RPG32_F : Launcher_Base_F {
        class Single : Mode_SemiAuto {
            aiDispersionCoefX = 1.7;
            aiDispersionCoefY = 2.2;
            aiRateOfFire = 7;
            aiRateOfFireDispersion = 3;
            aiRateOfFireDistance = 400;
            maxRange = 600;
            maxRangeProbab = 0.85;
            midRange = 40;
            midRangeProbab = 0.85;
            minRange = 10;
            minRangeProbab = 0.3;
            recoil = "recoil_single_law";
            sounds[] = {"StandardSound"};
        };
    };
};
