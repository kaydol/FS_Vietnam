
This Arma 3 addon aims at recreating authentic helicopter scouting tactic used by U.S. Airforce in Vietnam. 

### New modules
* Air Base module: a cornerstone of helicopter logistics. Here pilots can refuel, rearm, fix and get new crew members.
* Air Command module: applies behavioristic scripts to synced aircrafts.
* Arsenal module: teleports player into a special room upon startup and restores their gear after respawn.
* Garbage Collector module: designed to work in pair with Gook Manager, Garbage Collector can keep an eye on the number of placed mines, delete strayed gooks, and remove dead bodies.
* Gook Manager module: spawns angry Vietnamese guerillas around players and runs behavioristic scripts on them.
* Napalm CAS module: a variation of the standard BIS CAS module designed to work with napalm bombs and planes from The Unsung Vietnam War addon.
* Napalm Settings module: allows control of napalm lifetime, damage and explosion radius.
* Jukebox: easier scripted music with easier start & stop conditions and global\local music playing.

### New AI
* OH-6 Scout AI. The scout can asses the battlefield and call-in Napalm and artillery strikes, automatically takes station above known friendlies on the ground, and shares his knowledge with the ground troops if they have a radio. Should the ammo or fuel run out, the scout heads over to the nearest airbase to restock. Should the crewmate get injured, the scout breaks the station and flies to the nearest base that provides crew reinforcements. 
* Gooks AI. Gooks learned how to set up traps in the jungle, hide in the trees, and practice "Grab them by the belt" tactic. Just like their real life counterparts did.

#### Other features
* If ACE is running, M16 rifles are going to jam a lot more. The aim is to provide authentic experience, of course.
* M60 and M16 sounds were replaced by some sounds from vanilla game. The reason is the Unsung sounds were too unpleasant to ears.
* Whenever a support mission is being started by the pilot, the players with radios and radio backpacks will be notified, and are expected to pass the news along to the rest of the group.

#### Improvements to The Unsung Vietnam War mod
* Punji traps spawn spikes exactly where the fired trap was, and their initial orientation is preserved (in Unsung the spikes were spawned in "general vicinity" and their orientation was always 0 degrees).
* Whip Punji traps now have fire animation (the Unsung simply spawned already fired versions).
* Removed the ear-raping punji trap death sound that could be heard from several kilometers.
* Activating a punji trap now spawns visual effects of leaves and plays a dedicated sound.
* The default laggy Napalm bomb is replaced with a highly optimized Napalm with new sounds and visuals.

### To do
* Cobra's AI (historically the OH-6 scout reported targets to the Cobra's gunner who sat there with a map, jotting down coordinates which he then sent to the HQ or artillery support provider)
* Gook Manager upgrade (tracks movements of players and spawns ambushes and snipers on the trees along their way).
* Ability to call-in artillery barrages for ground troops.

### Bugs
- First fired punji trap does not always leave spikes. This is because for some reason the first exploded mine does not always spawn any clouds, and code that supposed to spawn a replacement model is ran inside particle's onTimerScript function, which wouldn't be called. First fired punji trap leaves an array of data in FS_AllGookTraps, e.g. [NULL-Object, _position, _orientation] which stays there without being removed.
- Large punji trap sometimes kills the gook who placed it.
- Arsenal Room module changes player's gear to random gear if placed in a new mission and loaded directly after mission start. This also happens if running "['Open', true] call BIS_fnc_Arsenal" in init.sqf, so it's not my fault, but I will see if I can create a workaround.
