
class CfgPatches
{
	class FS_Vietnam
	{
		units[] = {"Invisible_Minigun_Turret"};
		weapons[] = {"uns_m60_base", "uns_tripwire_punj1"};
		requiredAddons[] = {"A3_Data_F", "uns_weap_c", "A3_Weapons_F_Mark", "uns_missilebox_c", "uns_traps_s"};
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

/*
		Redefining the spawn of fired traps to add fired versions 
	to FS_AllGookTraps pool used by Garbage Collector module.
	
		Unfortunately there does not seem to be a better way to spawn
	fired versions of traps. I tried to add various EH to the mines
	and decided that the way the author of Unsung version used is the 
	most effective solution, though I've added a precise tracking.
*/
class CfgCloudlets {
	class Default;
	class punji1_cloud : Default {
		size[] = {0};
		timerPeriod = 0.05;
		interval = 1000;
		lifeTime = 0.09;
		onTimerScript = "\FS_Vietnam\Functions\Punji\fn_punji_small.sqf";
	};
	class punji2_cloud : punji1_cloud {
		onTimerScript = "\FS_Vietnam\Functions\Punji\fn_punji_large.sqf";
	};
	class punji3_cloud : punji1_cloud {
		onTimerScript = "\FS_Vietnam\Functions\Punji\fn_punji_whip1.sqf";
	};
	class punji4_cloud : punji1_cloud {
		onTimerScript = "\FS_Vietnam\Functions\Punji\fn_punji_whip2.sqf";
	};
	class MediumSmoke;
	class NapalmVictim : MediumSmoke {
		interval = 0.5;
		lifeTime = 2;
		rubbing = 0.025;
		size[] = {1.2,2.5};
	};
	class ScriptedNapalmExplosion : Default {
		size[] = {0};
		interval = 1000;
		lifeTime = 0;
		beforeDestroyScript = "\FS_Vietnam\Effects\Napalm\CustomNapalm.sqf";
	};
	
	/*
	class NapalmExplosion_Puff : Default {
		circleRadius = 0;
		circleVelocity[] = {0,0,0};
		
		particleShape = "\A3\data_f\cl_basic";
		particleType = "Billboard";
		particleFSFrameCount = 1;
		particleFSIndex = 0;
		particleFSLoop = 0;
		particleFSNtieth = 1;
		timerPeriod = 1;
		lifeTime = 1.25;
		position[] = {0,0,0};
		moveVelocity[] = {0,0,0.75};
		rotationVelocity = 0;
		weight = 10;
		volume = 7.9;
		rubbing = 0;
		size[] = {10, 100};
		color[] = {[1,1,1,0],[1,1,1,0.2],[1,1,1,1],[1,1,1,0.5],[1,1,1,0]};
		animationSpeed[] = {0.08};
		randomDirectionPeriod = 1;
		randomDirectionIntensity = 0;
		onTimerScript = "";
		beforeDestroyScript = "\FS_Vietnam\Effects\Napalm\CustomNapalm.sqf";
		interval = 1000;
	};
	
	class NapalmExplosion_Sparks : Default {
		circleRadius = 10;
		circleVelocity[] = {0,0,10};
		
		particleShape = "\A3\data_f\cl_exp";
		particleType = "Billboard";
		particleFSFrameCount = 1;
		particleFSIndex = 0;
		particleFSLoop = 0;
		particleFSNtieth = 1;
		timerPeriod = 1;
		lifeTime = 7;
		position[] = {0,0,0};
		moveVelocity[] = {5,5,30};
		rotationVelocity = 0.3;
		weight = 200;
		volume = 5;
		rubbing = 3;
		size[] = {1.5, 1, 0.5};
		color[] = {[1,1,1,1],[1,1,1,1],[1,1,1,1]};
		animationSpeed[] = {0.08};
		randomDirectionPeriod = 1;
		randomDirectionIntensity = 0;
		onTimerScript = "";
		beforeDestroyScript = "";
		interval = 0.02;
	};
	
	class NapalmExplosion_Clouds : Default  {
		circleRadius = 30;
		circleVelocity[] = {0.2, 0.5, 0.9};
		
		particleShape = "\A3\data_f\cl_basic";
		particleType = "Billboard";
		particleFSFrameCount = 1;
		particleFSIndex = 0;
		particleFSLoop = 0;
		particleFSNtieth = 1;
		timerPeriod = 1;
		lifeTime = 5;
		position[] = {0,0,0};
		moveVelocity[] = {0,0,15};
		rotationVelocity = 10;
		weight = 17;
		volume = 13;
		rubbing = 0.7;
		size[] = {15, 25, 31, 50};
		color[] = {[1,1,1,0],[1,1,1,0.2],[1,1,1,1],[0.5,0.5,0.5,0.5],[0,0,0,0]};
		animationSpeed[] = {0.08};
		randomDirectionPeriod = 0.1;
		randomDirectionIntensity = 3;
		onTimerScript = "";
		beforeDestroyScript = "";
		interval = 0.05;
	};
	*/
};

class NapalmExplosion_Impact {
	class Scripted {
		simulation = "particles";
		type = "ScriptedNapalmExplosion";
		lifeTime = 1;
	};
};

class CfgSoundShaders {
	class punji_soundshader_far {
		range = 0;
		rangeCurve[] = {};
		samples[] = {};
		volume = 0;
	};
	class punji_soundshader_mid {
		range = 0;
		rangeCurve[] = {};
		samples[] = {};
		volume = 0;
	};
	class punji_soundshader_near {
		range = 0;
		rangeCurve[] = {};
		samples[] = {};
		volume = 0;
	};
};

class CfgAmmo 
{
	class APERSMine_Range_Ammo;
	class uns_punji_ammo_base : APERSMine_Range_Ammo { //["MineBase","MineCore","TimeBombCore","Default"]
		delete soundHit1;
		delete soundHit2;
		delete soundHit3;
		delete soundHit4;
		delete multiSoundHit;
		soundHit[] = {"\uns_traps_s\sound\punji1",3.16228,1,30};
		hit = 6;
		indirectHit = 6;
		indirectHitRange = 1;
		mineInconspicuousness = 1000;
	};
	class uns_punji_small_ammo : uns_punji_ammo_base { //["APERSMine_Range_Ammo","MineBase","MineCore","TimeBombCore","Default"]
		hit = 4;
		indirectHit = 4;
		indirectHitRange = 1;
		mineInconspicuousness = 1000;
	};
	class uns_punji_large_ammo : uns_punji_small_ammo { 
		hit = 7;
		indirectHit = 5;
		indirectHitRange = 2;
		mineInconspicuousness = 1000;
	};
	class uns_punji_whip_ammo : uns_punji_small_ammo { 
		hit = 7;
		indirectHit = 1;
		indirectHitRange = 1;
		mineInconspicuousness = 1000;
	};
	class uns_punji_whip2_ammo : uns_punji_whip_ammo { 
		hit = 4;
		indirectHit = 1;
		indirectHitRange = 1;
		mineInconspicuousness = 1000;
	};
	
	class uns_bombcore;
	class Uns_Napalm_500 : uns_bombcore { //["BombCore","Default"]
		model = "\uns_missilebox\FRL_MK77\FRL_MK77_fly.p3d";
		proxyShape = "\uns_missilebox\FRL_MK77\FRL_MK77.p3d";
		hit = 0; // 1000
		indirectHit = 0; // 250
		indirectHitRange = 0; // 12
		
		soundHit0[] = {"\FS_Vietnam\Effects\Napalm\Sound\napalm.ogg",3,1,2500};
		soundHit1[] = {"\FS_Vietnam\Effects\Napalm\Sound\napalm_1.ogg",3,1,2500};
		soundHit2[] = {"\FS_Vietnam\Effects\Napalm\Sound\napalm_2.ogg",3,1,2500};
		soundHit3[] = {"\FS_Vietnam\Effects\Napalm\Sound\napalm_3.ogg",3,1,2500};
		soundHit4[] = {"\FS_Vietnam\Effects\Napalm\Sound\napalm_4.ogg",3,1,2500};
		soundHit5[] = {"\FS_Vietnam\Effects\Napalm\Sound\napalm_5.ogg",3,1,2500};
		soundHit6[] = {"\FS_Vietnam\Effects\Napalm\Sound\napalm_6.ogg",3,1,2500};
		soundHit7[] = {"\FS_Vietnam\Effects\Napalm\Sound\napalm_7.ogg",3,1,2500};
		soundHit8[] = {"\FS_Vietnam\Effects\Napalm\Sound\napalm_8.ogg",3,1,2500};
		soundHit9[] = {"\FS_Vietnam\Effects\Napalm\Sound\napalm_9.ogg",3,1,2500};
		multiSoundHit[] = {"soundHit0",0.1,"soundHit1",0.1,"soundHit2",0.1,"soundHit3",0.1,"soundHit4",0.1,"soundHit5",0.1,"soundHit6",0.1,"soundHit7",0.1,"soundHit8",0.1,"soundHit9",0.1};
		
		explosionEffects = "NapalmExplosion_Impact";
		CraterEffects = "";
		trackOversteer = 1;
		fuseDistance = 35;
		whistleDist = 24;
		aiAmmoUsageFlags = "64 + 128 + 512";
		dangerRadiusHit = 1550;
		suppressionRadiusHit = 150;
		maneuvrability = 15;
		effectsMissile = "EmptyEffect";
		effectsMissileInit = "";
		initTime = 0.5;
		thrustTime = 45;
		thrust = 0;
		trackLead = 1;
	};
	class Uns_Napalm_750 : Uns_Napalm_500 { //["uns_bombcore","BombCore","Default"]
		model = "\uns_missilebox\FRL_BLU1B\FRL_BLU1B_fly.p3d";
		proxyShape = "\uns_missilebox\FRL_BLU1B\FRL_BLU1B.p3d";
		hit = 1500;
		indirectHit = 350;
		indirectHitRange = 17;
	};
	class Uns_Napalm_blu1 : Uns_Napalm_500 { //["uns_bombcore","BombCore","Default"]
		model = "\uns_missilebox\uns_A1\uns_blu1_fly.p3d";
		proxyShape = "\uns_missilebox\uns_A1\uns_blu1.p3d";
		hit = 2000;
		indirectHit = 450;
		indirectHitRange = 20;
	};
	class Uns_Napalm_ZB360 : Uns_Napalm_500 { //["uns_bombcore","BombCore","Default"]
		model = "\uns_missilebox\PRACS\PRACS_TK_SAB100Tb.p3d";
		proxyShape = "\uns_missilebox\PRACS\PRACS_TK_SAB100Tb.p3d";
	};
};


class CfgVehicles 
{
	/*
		Modules
	*/
	class Logic;
	class Module_F : Logic {
		class AttributesBase {
			class Default;
			class Edit; // Default edit box (i.e., text input field)
			class Combo; // Default combo box (i.e., drop-down menu)
			class Checkbox; // Default checkbox (returned value is Bool)
			class CheckboxNumber; // Default checkbox (returned value is Number)
			class ModuleDescription; // Module description
			class Units; // Selection of units on which the module is applied
		};
		// Description base classes
		class ModuleDescription {
			class Anything;
			class AnyBrain;
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
		};
	};
	
	class FS_AirCommand_Module : FS_Vietnam_Module {
		_generalMacro = "FS_AirCommand_Module";
		icon = "\a3\Modules_f\data\iconHQ_ca.paa";
		portrait = "\a3\Modules_f\data\portraitHQ_ca.paa";
		scope = 2;
		displayName = "Air Command";
		function = "FS_fnc_ModuleAirCommand";
		class ModuleDescription : ModuleDescription {
			description = "This module is required for Vietnam helicopter crews.";
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
				tooltip = "Minimum time between pilot's assessments of the battlefield. Based on his assessment, the pilot decides if the use of airstrike and artillery is warranted. Decreasing this may negatively impact perfomance.";
				typeName = "NUMBER";
				defaultValue = 20;
			};
			class ArtilleryThreshold : Edit {
				property = "artilleryThreshold";
				displayName = "Concentration for artillery strike";
				tooltip = "Minimum concetration of enemies for the pilot to consider an artillery strike.";
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
			class AmbientRadio : Checkbox {
				property = "AmbientRadio";
				displayName = "Enable Unsung ambient radio";
				tooltip = "Uses The Unsung Vietnam War addon's functions to add an ambient radio playback to synced helicopters.";
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
			class AILimit : Edit {
				property = "AILimit";
				displayName = "AI limit";
				tooltip = "How many alive Gooks can be present on the map simultaneously. Reduce to ease lags, increase if you have a very powerful CPU.";
				typeName = "NUMBER";
				defaultValue = 20;
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
				defaultValue = 1;
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
			class SpawnDistance : Edit {
				property = "SpawnDistance";
				displayName = "Spawn Distance";
				tooltip = "How far from players the gooks will be spawned.";
				typeName = "NUMBER";
				defaultValue = 200;
			};
			class Debug : Checkbox {
				property = "Debug";
				displayName = "Debug";
				tooltip = "Enable debug information.";
				typeName = "BOOL";
				defaultValue = "false";
			};
		};
	};
	
	class FS_Arsenal_Module : FS_Vietnam_Module {
		_generalMacro = "FS_Arsenal_Module";
		scope = 2;
		isGlobal = 2; // Persistent global execution
		displayName = "Arsenal Room";
		function = "FS_fnc_ModuleArsenal";
		isDisposable = 0; // 1 if modules is to be disabled once it's activated (i.e., repeated trigger activation won't work)
		class ModuleDescription : ModuleDescription {
			description = "This module opens a Virtual Arsenal at the mission start.";
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
				defaultValue = 30;
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
			class GookRemovalDistance : Edit {
				property = "gookRemovalDistance";
				displayName = "Gook removal distance";
				tooltip = "Gooks that are too far from any of the players will be mercilessly deleted. Use -1 to disable gook removal.";
				typeName = "NUMBER";
				defaultValue = 300;
			};
			class RemovePreplaced : Checkbox {
				property = "removePreplaced";
				displayName = "Remove preplaced groups";
				tooltip = "If unchecked, units in preplaced EAST side groups won't be deleted due to distance checks. Does not affect preplaced mines, because they always stay until destroyed or picked up.";
				typeName = "BOOL";
				defaultValue = "false"; 
			};
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
			class NapalmBombRadius : Edit {
				property = "NapalmBombRadius";
				displayName = "Napalm Bomb Radius";
				tooltip = "";
				typeName = "NUMBER";
				defaultValue = 40;
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
		};
	};
	
	class FS_NapalmCAS_Module : FS_Vietnam_Module {
		_generalMacro = "FS_NapalmCAS_Module";
		scope = 2;
		scopeCurator = 0;
		isGlobal = 1;
		isTriggerActivated = 1;
		icon = "\a3\Modules_F_Curator\Data\iconCAS_ca.paa";
		portrait = "\a3\Modules_F_Curator\Data\portraitCAS_ca.paa";
		curatorCost = 5;
		displayName = "Napalm CAS";
		function = "FS_fnc_ModuleNapalmCAS";
		class ModuleDescription : ModuleDescription {
			description = "";
			sync[] = {};
		};
		class Attributes : AttributesBase {
			class Vehicle : Combo {
				property = "Vehicle";
				displayName = "Plane";
				tooltip = "";
				typeName = "STRING";
				class values
				{
					class uns_A7N_CAS {
						name = "A-7C Corsair II (CAS)";
						value = "uns_A7N_CAS";
						default = 1;
					};
					class uns_F4J_CAS {
						name = "F-4J Phantom II (CAS)";
						value = "uns_F4J_CAS";
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
		};
	};
	
	class FS_ArtyStrike_Module : FS_Vietnam_Module {
		_generalMacro = "FS_ArtyStrike_Module";
		scope = 2;
		scopeCurator = 0;
		isGlobal = 1;
		isTriggerActivated = 1;
		icon = "\a3\Modules_F_Curator\Data\iconOrdnance_ca.paa";
		portrait = "\a3\Modules_F_Curator\Data\portraitOrdnance_ca.paa";
		curatorCost = 5;
		displayName = "Artillery Strike";
		function = "FS_fnc_ModuleArtyStrike";
		class ModuleDescription : ModuleDescription {
			description = "";
			sync[] = {};
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
			
		};
		
	};
	
	class FS_Jukebox_Module : FS_Vietnam_Module {
		_generalMacro = "FS_Jukebox_Module";
		scope = 2;
		displayName = "Jukebox";
		function = "FS_fnc_ModuleJukebox";
		isDisposable = 1; // 1 if modules is to be disabled once it's activated (i.e., repeated trigger activation won't work)
		isGlobal = 2; // 0 for server only execution, 1 for global execution, 2 for persistent global execution
		class ModuleDescription : ModuleDescription {
			description = "Module that runs on server and plays music for all connected clients";
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
			
		};
	};
};


class CfgFunctions 
{
	class FS {
		
		class Math {
			class kMeansClustering {file = "\FS_Vietnam\Functions\Math\kMeansClustering.sqf";};
			class AgglomerativeClustering {file = "\FS_Vietnam\Functions\Math\AgglomerativeClustering.sqf";};
			class CalculateCenter2D {file = "\FS_Vietnam\Functions\Math\CalculateCenter2D.sqf";};
			class BiggestClusterDiameter {file = "\FS_Vietnam\Functions\Math\BiggestClusterDiameter.sqf";};
			class Clusterize {file = "\FS_Vietnam\Functions\Math\Clusterize.sqf";};
		};
		
		class Misc {
			class DirectionWrapper {file = "\FS_Vietnam\Functions\Misc\DirectionWrapper.sqf";};
			class DistanceBetweenArrays {file = "\FS_Vietnam\Functions\Misc\DistanceBetweenArrays.sqf";};
			class GetSideVariable {file = "\FS_Vietnam\Functions\Misc\GetSideVariable.sqf";};
			class SetVarLifespan {file = "\FS_Vietnam\Functions\Misc\SetVarLifespan.sqf";};
			class ShowMessage {file = "\FS_Vietnam\Functions\Misc\ShowMessage.sqf";};
			class Snapshots {file = "\FS_Vietnam\Functions\Misc\Snapshots.sqf";};
			class SnapshotWrapper {file = "\FS_Vietnam\Functions\Misc\SnapshotWrapper.sqf";};
			class UpdateSideVariable {file = "\FS_Vietnam\Functions\Misc\UpdateSideVariable.sqf";};
			class GroupMarkers {file = "\FS_Vietnam\Functions\Misc\GroupMarkers.sqf";};
			class ObjectsGrabber {file = "\FS_Vietnam\Functions\Misc\ObjectsGrabber.sqf";};
			class ObjectsMapper {file = "\FS_Vietnam\Functions\Misc\ObjectsMapper.sqf";};
			class QueueCreate {file = "\FS_Vietnam\Functions\Misc\QueueCreate.sqf";};
			class QueueDispose {file = "\FS_Vietnam\Functions\Misc\QueueDispose.sqf";};
			class QueueGetData {file = "\FS_Vietnam\Functions\Misc\QueueGetData.sqf";};
			class QueueGetSize {file = "\FS_Vietnam\Functions\Misc\QueueGetSize.sqf";};
			class QueuePush {file = "\FS_Vietnam\Functions\Misc\QueuePush.sqf";};
			class ShakeCam {file = "\FS_Vietnam\Functions\Misc\ShakeCam.sqf";};
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
			class IsMaintenanceNeeded {file = "\FS_Vietnam\Functions\Helicopters\IsMaintenanceNeeded.sqf";};
			class IsScrambleNeeded {file = "\FS_Vietnam\Functions\Helicopters\IsScrambleNeeded.sqf";};
			class IsStationTaken {file = "\FS_Vietnam\Functions\Helicopters\IsStationTaken.sqf";};
			class LeaveTheArea {file = "\FS_Vietnam\Functions\Helicopters\LeaveTheArea.sqf";};
			class LoachInit {file = "\FS_Vietnam\Functions\Helicopters\LoachInit.sqf";};
			class ReloadAndRefuel {file = "\FS_Vietnam\Functions\Helicopters\ReloadAndRefuel.sqf";};
			class Scramble {file = "\FS_Vietnam\Functions\Helicopters\Scramble.sqf";};
			class ValidateTarget {file = "\FS_Vietnam\Functions\Helicopters\ValidateTarget.sqf";};
			class IsEnoughDaylight {file = "\FS_Vietnam\Functions\Helicopters\IsEnoughDaylight.sqf";};
			class SurvivedPilots {file = "\FS_Vietnam\Functions\Helicopters\SurvivedPilots.sqf";};
		};
		
		class Support {
			class DropMines {file = "\FS_Vietnam\Effects\Artillery\DropMines.sqf";};
			class FallingDirt {file = "\FS_Vietnam\Effects\Artillery\FallingDirt.sqf";};
			class DropNapalm {file = "\FS_Vietnam\Effects\Napalm\DropNapalm.sqf";};
			class NapalmBurnedAlive {file = "\FS_Vietnam\Effects\Napalm\NapalmBurnedAlive.sqf";};
			class NapalmPuffAndSparks {file = "\FS_Vietnam\Effects\Napalm\NapalmPuffAndSparks.sqf";};
			class NapalmPhosphorusStrands {file = "\FS_Vietnam\Effects\Napalm\NapalmPhosphorusStrands.sqf";};
			class NapalmAfterEffect {file = "\FS_Vietnam\Effects\Napalm\NapalmAfterEffect.sqf";};
			class NapalmCreateExplosion {file = "\FS_Vietnam\Effects\Napalm\NapalmCreateExplosion.sqf";};
		};
		
		class Punji {
			class PunjiEffects {file = "\FS_Vietnam\Functions\Punji\PunjiEffects.sqf";};
			class PunjiPostInit {file = "\FS_Vietnam\Functions\Punji\PunjiPostInit.sqf"; postInit = 1;};
			class PunjiTrapFired {file = "\FS_Vietnam\Functions\Punji\PunjiTrapFired.sqf";};
			class PunjiPutEventHandler {file = "\FS_Vietnam\Functions\Punji\PunjiPutEventHandler.sqf";};
		};
		
		class Radio {
			class AddCommsMenu {file = "\FS_Vietnam\Functions\Radio\AddCommsMenu.sqf";};
			class HasCommSystem {file = "\FS_Vietnam\Functions\Radio\HasCommSystem.sqf";};
			class HasRadio {file = "\FS_Vietnam\Functions\Radio\HasRadio.sqf";};
			class HasRadioAround {file = "\FS_Vietnam\Functions\Radio\HasRadioAround.sqf";};
			class HasRTO {file = "\FS_Vietnam\Functions\Radio\HasRTO.sqf";};
			class HasRTOAround {file = "\FS_Vietnam\Functions\Radio\HasRTOAround.sqf";};
			class TransmitDistress {file = "\FS_Vietnam\Functions\Radio\TransmitDistress.sqf";};
			class TransmitOverRadio {file = "\FS_Vietnam\Functions\Radio\TransmitOverRadio.sqf";};
			class TransmitSitrep {file = "\FS_Vietnam\Functions\Radio\TransmitSitrep.sqf";};
			class IsRankingOfficer {file = "\FS_Vietnam\Functions\Radio\IsRankingOfficer.sqf";};
			class UnsungRadioPlayback {file = "\FS_Vietnam\Functions\Radio\UnsungRadioPlayback.sqf";};
		};
		
		class Behaviour {
			class GrpFiredNear {file = "\FS_Vietnam\Functions\Behaviour\GrpFiredNear.sqf";};
			class GrpFiredNearExec {file = "\FS_Vietnam\Functions\Behaviour\GrpFiredNearExec.sqf";};
			class GrpHideInTrees {file = "\FS_Vietnam\Functions\Behaviour\GrpHideInTrees.sqf";};
			class GrpNearestEnemy {file = "\FS_Vietnam\Functions\Behaviour\GrpNearestEnemy.sqf";};
			class GrpPlaceTraps {file = "\FS_Vietnam\Functions\Behaviour\GrpPlaceTraps.sqf";};
			class IsGroupSpotted {file = "\FS_Vietnam\Functions\Behaviour\IsGroupSpotted.sqf";};
			class PlaceTrap {file = "\FS_Vietnam\Functions\Behaviour\PlaceTrap.sqf";};
			class OccupyTree {file = "\FS_Vietnam\Functions\Behaviour\OccupyTree.sqf";};
			class UnitsReady {file = "\FS_Vietnam\Functions\Behaviour\UnitsReady.sqf";};
			class GookSenses {file = "\FS_Vietnam\Functions\Behaviour\GookSenses.sqf";};
			class IsPlaceSafe {file = "\FS_Vietnam\Functions\Behaviour\IsPlaceSafe.sqf";};
			class FilterObjects {file = "\FS_Vietnam\Functions\Behaviour\FilterObjects.sqf";};
			class SpawnGooks {file = "\FS_Vietnam\Functions\Behaviour\SpawnGooks.sqf";};
			class Suspense {file = "\FS_Vietnam\Functions\Behaviour\Suspense.sqf";};
			class IsEnoughSuspense {file = "\FS_Vietnam\Functions\Behaviour\IsEnoughSuspense.sqf";};
			class GetHiddenPos {file = "\FS_Vietnam\Functions\Behaviour\GetHiddenPos.sqf";};
			class GetHiddenPos2 {file = "\FS_Vietnam\Functions\Behaviour\GetHiddenPos2.sqf";};
			class AttackPlanner {file = "\FS_Vietnam\Functions\Behaviour\AttackPlanner.sqf";};
		};
		
		class Modules {
			class ModuleCreateAirBase {file = "\FS_Vietnam\Functions\Modules\ModuleCreateAirBase.sqf";};
			class ModuleAirCommand {file = "\FS_Vietnam\Functions\Modules\ModuleAirCommand.sqf";};
			class ModuleGookManager {file = "\FS_Vietnam\Functions\Modules\ModuleGookManager.sqf";};
			class GetModuleOwner {file = "\FS_Vietnam\Functions\Modules\GetModuleOwner.sqf";};
			class AuthenticLoadout {file = "\FS_Vietnam\Functions\Modules\AuthenticLoadout.sqf";};
			class ModuleArsenal {file = "\FS_Vietnam\Functions\Modules\ModuleArsenal.sqf";};
			class ArsenalRoom {file = "\FS_Vietnam\Functions\Modules\ArsenalRoom.sqf";};
			class ArsenalRoomCreate {file = "\FS_Vietnam\Functions\Modules\ArsenalRoomCreate.sqf";};
			class ModuleGarbageCollector {file = "\FS_Vietnam\Functions\Modules\ModuleGarbageCollector.sqf";};
			class ModuleNapalmSettings {file = "\FS_Vietnam\Functions\Modules\ModuleNapalmSettings.sqf";};
			class ModuleNapalmCAS {file = "\FS_Vietnam\Functions\Modules\ModuleNapalmCAS.sqf";};
			class ModuleJukebox {file = "\FS_Vietnam\Functions\Modules\ModuleJukebox.sqf";};
			class JukeboxPlayMusic {file = "\FS_Vietnam\Functions\Modules\JukeboxPlayMusic.sqf";};
			class ModuleMaintenanceSettings {file = "\FS_Vietnam\Functions\Modules\ModuleMaintenanceSettings.sqf";};
			class ModuleArtyStrike {file = "\FS_Vietnam\Functions\Modules\ModuleArtyStrike.sqf";};
		};
	};
	
};


/*
	M60 & M16 sound replacement
*/

class Mode_SemiAuto;
class Mode_FullAuto;

class CfgWeapons 
{
	class Uns_HMG;
	class uns_m60_base : Uns_HMG {
		class FullAuto : Mode_FullAuto {
			class BaseSoundModeType;
			class StandardSound : BaseSoundModeType {
				soundSetShot[] = {"DMR06_Shot_SoundSet","DMR06_tail_SoundSet","DMR06_InteriorTail_SoundSet"};
			};
		};
		
	};
	
	class Uns_Rifle;
	class uns_m16 : Uns_Rifle {
		
		/* ACE snippet to promote jamming for M16 */
		ace_overheating_mrbs = 350; //Mean Rounds Between Stoppages (scaled based on the barrel temp)
        ace_overheating_slowdownFactor = 0.5; //Slowdown Factor (scaled based on the barrel temp)
        ace_overheating_allowSwapBarrel = 0; // 1 to enable barrel swap. 0 to disable. Meant for machine guns where you can easily swap the barrel without dismantling the whole weapon.
		
		class Single : Mode_SemiAuto {
			class BaseSoundModeType {
				closure1[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\DMR_05_Closure_01",0.398107,1,30};
				closure2[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\DMR_05_Closure_02",0.398107,1,30};
				soundClosure[] = {"closure1",0.5,"closure2",0.5};
			};
			class StandardSound : BaseSoundModeType {
				soundSetShot[] = {"DMR05_Shot_SoundSet","DMR05_tail_SoundSet","DMR05_InteriorTail_SoundSet"};
				begin1[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\DMR_05_short_01",2.51189,1,1200};
				begin2[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\DMR_05_short_02",2.51189,1,1200};
				begin3[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\DMR_05_short_03",2.51189,1,1200};
				soundBegin[] = {"begin1",0.33,"begin2",0.33,"begin3",0.34};
				class SoundTails {
					class TailInterior {
						sound[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\DMR_05_tail_interior",1.41254,1,1200};
						frequency = 1;
						volume = "interior";
					};
					class TailTrees {
						sound[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\DMR_05_tail_trees",1,1,1200};
						frequency = 1;
						volume = "(1-interior/1.4)*trees";
					};
					class TailForest {
						sound[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\DMR_05_tail_forest",1,1,1200};
						frequency = 1;
						volume = "(1-interior/1.4)*forest";
					};
					class TailMeadows {
						sound[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\DMR_05_tail_meadows",1,1,1200};
						frequency = 1;
						volume = "(1-interior/1.4)*(meadows/2 max sea/2)";
					};
					class TailHouses {
						sound[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\DMR_05_tail_houses",1,1,1200};
						frequency = 1;
						volume = "(1-interior/1.4)*houses";
					};
				};
			};
			class SilencedSound : BaseSoundModeType {
				SoundSetShot[] = {"DMR05_silencerShot_SoundSet","DMR05_silencerTail_SoundSet","DMR05_silencerInteriorTail_SoundSet"};
				begin1[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\silencer_DMR_05_short_01",1,1,300};
				begin2[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\silencer_DMR_05_short_02",1,1,300};
				begin3[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\silencer_DMR_05_short_03",1,1,300};
				soundBegin[] = {"begin1",0.33,"begin2",0.33,"begin3",0.34};
				class SoundTails {
					class TailInterior {
						sound[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\silencer_DMR_05_tail_interior",1,1,300};
						frequency = 1;
						volume = "interior";
					};
					class TailTrees {
						sound[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\silencer_DMR_05_tail_trees",1,1,300};
						frequency = 1;
						volume = "(1-interior/1.4)*trees";
					};
					class TailForest {
						sound[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\silencer_DMR_05_tail_forest",1,1,300};
						frequency = 1;
						volume = "(1-interior/1.4)*forest";
					};
					class TailMeadows {
						sound[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\silencer_DMR_05_tail_meadows",1,1,300};
						frequency = 1;
						volume = "(1-interior/1.4)*(meadows/2 max sea/2)";
					};
					class TailHouses {
						sound[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\silencer_DMR_05_tail_houses",1,1,300};
						frequency = 1;
						volume = "(1-interior/1.4)*houses";
					};
				};
			};
		};
		class FullAuto : Mode_FullAuto {
			class BaseSoundModeType {
				closure1[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\DMR_05_Closure_01",0.398107,1,30};
				closure2[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\DMR_05_Closure_02",0.398107,1,30};
				soundClosure[] = {"closure1",0.5,"closure2",0.5};
			};
			class StandardSound : BaseSoundModeType {
				soundSetShot[] = {"DMR05_Shot_SoundSet","DMR05_tail_SoundSet","DMR05_InteriorTail_SoundSet"};
				begin1[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\DMR_05_short_01",2.51189,1,1200};
				begin2[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\DMR_05_short_02",2.51189,1,1200};
				begin3[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\DMR_05_short_03",2.51189,1,1200};
				soundBegin[] = {"begin1",0.33,"begin2",0.33,"begin3",0.34};
				class SoundTails {
					class TailInterior {
						sound[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\DMR_05_tail_interior",1.41254,1,1200};
						frequency = 1;
						volume = "interior";
					};
					class TailTrees {
						sound[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\DMR_05_tail_trees",1,1,1200};
						frequency = 1;
						volume = "(1-interior/1.4)*trees";
					};
					class TailForest {
						sound[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\DMR_05_tail_forest",1,1,1200};
						frequency = 1;
						volume = "(1-interior/1.4)*forest";
					};
					class TailMeadows {
						sound[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\DMR_05_tail_meadows",1,1,1200};
						frequency = 1;
						volume = "(1-interior/1.4)*(meadows/2 max sea/2)";
					};
					class TailHouses {
						sound[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\DMR_05_tail_houses",1,1,1200};
						frequency = 1;
						volume = "(1-interior/1.4)*houses";
					};
				};
			};
			class SilencedSound : BaseSoundModeType {
				SoundSetShot[] = {"DMR05_silencerShot_SoundSet","DMR05_silencerTail_SoundSet","DMR05_silencerInteriorTail_SoundSet"};
				begin1[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\silencer_DMR_05_short_01",1,1,300};
				begin2[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\silencer_DMR_05_short_02",1,1,300};
				begin3[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\silencer_DMR_05_short_03",1,1,300};
				soundBegin[] = {"begin1",0.33,"begin2",0.33,"begin3",0.34};
				class SoundTails {
					class TailInterior {
						sound[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\silencer_DMR_05_tail_interior",1,1,300};
						frequency = 1;
						volume = "interior";
					};
					class TailTrees {
						sound[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\silencer_DMR_05_tail_trees",1,1,300};
						frequency = 1;
						volume = "(1-interior/1.4)*trees";
					};
					class TailForest {
						sound[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\silencer_DMR_05_tail_forest",1,1,300};
						frequency = 1;
						volume = "(1-interior/1.4)*forest";
					};
					class TailMeadows {
						sound[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\silencer_DMR_05_tail_meadows",1,1,300};
						frequency = 1;
						volume = "(1-interior/1.4)*(meadows/2 max sea/2)";
					};
					class TailHouses {
						sound[] = {"A3\Sounds_F_Mark\arsenal\weapons\LongRangeRifles\DMR_05_Cyrus\silencer_DMR_05_tail_houses",1,1,300};
						frequency = 1;
						volume = "(1-interior/1.4)*houses";
					};
				};
			};
		};
	};
};
