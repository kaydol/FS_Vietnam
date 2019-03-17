
class CfgPatches
{
	class FS_Vietnam
	{
		units[] = {};
		weapons[] = {"uns_m60_base", "uns_tripwire_punj1"};
		requiredAddons[] = {"uns_weap_c", "A3_Weapons_F_Mark"};
		requiredVersion = 0.100000;
		author = "Fess25Rus";
		url = "http://fess-style.ucoz.ru";
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
		author = "Fess25Rus";
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
	class punji1_cloud {
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
};

/*
	Modules
*/
class CfgVehicles 
{
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
		author = "Fess25Rus";
		scope = 1;
		is3DEN = 0;
		isGlobal = 0;
		displayName = "FS Vietnam Module";
		category = "FS_Vietnam";
	};
	
	class FS_AirBase_Module : FS_Vietnam_Module {
		_generalMacro = "FS_AirBase_Module";
		scope = 2;
		displayName = "Air Base";
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
			class Resupply : Checkbox {
				property = "providesMaintenance";
				displayName = "Refuel, rearm, repair, heal";
				tooltip = "Landing helicopters will be refueled, rearmed & repaired; the crew will be healed";
				typeName = "BOOL";
				defaultValue = "true"; 
			};
			class ReplaceCrew : Checkbox {
				property = "providesCrew";
				displayName = "Replace dead crew";
				tooltip = "Sync Respawn Points to spawn new crew there and then make them run and board the helicopter. If no RPs were synced, the new crew will be teleported into the helicopter directly.";
				typeName = "BOOL";
				defaultValue = "true"; 
			};
			class RefuelRearmTime : Edit {
				property = "refuelRearmTime";
				displayName = "Maintenance time";
				tooltip = "How much time is needed to refuel, rearm, repair and heal up.";
				typeName = "NUMBER";
				defaultValue = 60;
			};
		};
	};
	
	class FS_AirCommand_Module : FS_Vietnam_Module {
		_generalMacro = "FS_AirCommand_Module";
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
				tooltip = "Minimum time between calling-in artillery by the pilots.";
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
				tooltip = "Minimum time between calling-in napalm by the pilots.";
				typeName = "NUMBER";
				defaultValue = 300;
			};
			class NapalmDuration : Edit {
				property = "napalmDuration";
				displayName = "Napalm burn time";
				tooltip = "Historically, napalm burn time varied from 15 seconds up to 10 minutes, depending on the chemical composition.";
				typeName = "NUMBER";
				defaultValue = 120;
			};
		};
	};
	
	class FS_GookManager_Module : FS_Vietnam_Module {
		_generalMacro = "FS_GookManager_Module";
		scope = 2;
		displayName = "Gook Manager";
		function = "FS_fnc_ModuleGookManager";
		class ModuleDescription : ModuleDescription {
			description = "This module spawns Vietnamese around players.";
			sync[] = {};
		};
		class Attributes : AttributesBase {
			class AILimit : Edit {
				property = "aiLimit";
				displayName = "AI limit";
				tooltip = "How many alive Gooks can be present on the map simultaneously. Reduce to ease lags, increase if you have a very powerful CPU.";
				typeName = "NUMBER";
				defaultValue = 40;
			};
			class GroupSize : Edit {
				property = "groupSize";
				displayName = "Group size";
				tooltip = "How many Gooks will be spawned per group. Reduce to spawn a high amount of small groups, increase to spawn a small amount of large groups. Better keep this in 5-12 range.";
				typeName = "NUMBER";
				defaultValue = 5;
			};
			class SpawnProbability : Edit {
				property = "spawnProbability";
				displayName = "Spawn probability";
				tooltip = "Defines the probability of spawning a group of Gooks. Number in range 0-1.";
				typeName = "NUMBER";
				defaultValue = 0.9;
			};
			class Sleep : Edit {
				property = "sleep";
				displayName = "Time between attempts";
				tooltip = "The Manager drops a dice to decide whether to spawn a group of Gooks or not, then spawns it if the answer is yes. After that, the Manager waits some, then the whole thing is repeated. This number defines how much time passes between dice drops.";
				typeName = "NUMBER";
				defaultValue = 30;
			};
		};
	};
	
	class FS_Arsenal_Module : FS_Vietnam_Module {
		_generalMacro = "FS_Arsenal_Module";
		scope = 2;
		isGlobal = 2; // Persistent global execution
		displayName = "Arsenal";
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
			class PlayMusic : Checkbox {
				property = "playMusic";
				displayName = "With music";
				tooltip = "Play music while in arsenal";
				typeName = "BOOL";
				defaultValue = "true"; 
			};
			class AceCompatibility : Checkbox {
				property = "aceCompatibility";
				displayName = "Ace compatibility";
				tooltip = "ACE addon deafness system overrides smooth music volume changes, resulting in arsenal music ending abruptly. When enabled, this will disable ACE's deafness while the player is in the arsenal, then enable it back after the music was silenced.";
				typeName = "BOOL";
				defaultValue = "true"; 
			};
		};
	};
	
	class FS_GarbageCollector_Module : FS_Vietnam_Module {
		_generalMacro = "FS_GarbageCollector_Module";
		scope = 2;
		displayName = "Garbage Collector";
		function = "FS_fnc_ModuleGarbageCollector";
		class ModuleDescription : ModuleDescription {
			description = "This module deletes unnecessary objects.";
			sync[] = {};
		};
		class Attributes : AttributesBase {
			class RemoveDead : Checkbox {
				property = "removeDead";
				displayName = "Remove dead";
				tooltip = "Enable to remove dead bodies from the world eventually. Disable to leave them be.";
				typeName = "BOOL";
				defaultValue = "true";
			};
			class RemoveTraps : Checkbox {
				property = "removeTraps";
				displayName = "Remove far traps";
				tooltip = "Remove traps that are too far from any of the players.";
				typeName = "BOOL";
				defaultValue = "true"; 
			};
			class TrapsThreshold : Edit {
				property = "trapsThreshold";
				displayName = "Traps threshold";
				tooltip = "Remove random trap once their amount goes beyond threshold and the new one is placed. Use -1 to disable threshold.";
				typeName = "NUMBER";
				defaultValue = 40;
			};
			class RemoveGooks : Checkbox {
				property = "removeGooks";
				displayName = "Remove strayed Gooks";
				tooltip = "Gooks that are too far from any of the players will be mercilessly deleted.";
				typeName = "BOOL";
				defaultValue = "true"; //true - 1, false - 0
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
		};
		
		class Support {
			class DropMines {file = "\FS_Vietnam\Functions\Support\DropMines.sqf";};
			class DropNapalm {file = "\FS_Vietnam\Functions\Support\DropNapalm.sqf";};
			class ModuleCas {file = "\FS_Vietnam\Functions\Support\ModuleCas.sqf";};
			class ShakeCam {file = "\FS_Vietnam\Functions\Support\ShakeCam.sqf";};
			class SpawnCrater {file = "\FS_Vietnam\Functions\Support\ShakeCam.sqf";};
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
		};
		
		class Modules {
			class ModuleCreateAirBase {file = "\FS_Vietnam\Functions\Modules\ModuleCreateAirBase.sqf";};
			class ModuleAirCommand {file = "\FS_Vietnam\Functions\Modules\ModuleAirCommand.sqf";};
			class ModuleGookManager {file = "\FS_Vietnam\Functions\Modules\ModuleGookManager.sqf";};
			class GetModuleOwner {file = "\FS_Vietnam\Functions\Modules\GetModuleOwner.sqf";};
			class SpawnGooks {file = "\FS_Vietnam\Functions\Modules\SpawnGooks.sqf";};
			class Suspense {file = "\FS_Vietnam\Functions\Modules\Suspense.sqf";};
			class IsEnoughSuspense {file = "\FS_Vietnam\Functions\Modules\IsEnoughSuspense.sqf";};
			class GetHiddenPos {file = "\FS_Vietnam\Functions\Modules\GetHiddenPos.sqf";};
			class AuthenticLoadout {file = "\FS_Vietnam\Functions\Modules\AuthenticLoadout.sqf";};
			class ModuleArsenal {file = "\FS_Vietnam\Functions\Modules\ModuleArsenal.sqf";};
			class ArsenalRoom {file = "\FS_Vietnam\Functions\Modules\ArsenalRoom.sqf";};
			class ArsenalRoomCreate {file = "\FS_Vietnam\Functions\Modules\ArsenalRoomCreate.sqf";};
			class ModuleGarbageCollector {file = "\FS_Vietnam\Functions\Modules\ModuleGarbageCollector.sqf";};
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
