
This Arma 3 addon aims at recreating authentic helicopter scouting tactic used by U.S. Airforce in Vietnam. 

Implemented main features so far
* OH-6 Scout AI. The scout can call-in napalm and artillery strikes, automatically takes station above known friendlies on the ground, and shares his knowledge with the ground troops. Should the ammo or fuel run out, the scout heads over to the nearest airbase to restock. Should the crewmate get injured, the scout breaks the station and flies to the nearest base that provides crew reinforecements. 
* Gooks AI. Gooks learned how to set up traps in the jungle, hide in the trees, and practice "Grab them by the belt" tactic. Just like their real life counterparts did.
* Artillery & Napalm sound and visual overhaul. Custom Napalm visuals based on a script from alias.
* Garbage collector. Designed to work in pair with Gook Manager, Garbage Collector can keep an eye on the number of placed mines, delete strayed gooks, and remove dead bodies.

Secondary features
* If ACE is running, M16 rifles are going to jam. A lot. The aim to provide authentic Vietnam experience, of course.
* M60 and M16 sounds were replaced by some sounds from vanilla game. The reason is the Unsung sounds were too unpleasant to the ear.

Improvements to The Unsung Vietnam War mod
* Punji traps spawn spikes exactly where the fired trap was, and their initial orientation is preserved (in Unsung the spikes were spawned in "general vicinity" and their orientation was not the same).
* Whip Punji traps now have fire animation (the Unsung simply spawned already fired versions).

To do
* Cobra's AI (historically the OH-6 scout reported targets to the Cobra's gunner who sat there with a map, jotting down coordinates which he then sent to the HQ or artillery support provider)
* Gook Manager (tracks movements of players and spawns ambushes and snipers on the trees along their way).
* Ability to call-in artillery barrages for ground troops.

Bugs and things from the Unsung Vietnam War mod that need to be fixed
- First fired punji trap does not leave spikes. This is because for some reason the first exploded mine does not spawn any clouds, and code that supposed to spawn a replacement model is ran inside particle's onTimerScript function, which wouldn't be called. First fired punji trap leaves an array of data in FS_AllGookTraps, e.g. [<NULL-Object>, _position, _orientation] which stays there without being removed.
- Large punji trap sometimes kills the gook who placed it.
- The death sound from punji trap can be heard from a very long distance.
- Punji trap deaths appear to spawn multiple screams at once.
