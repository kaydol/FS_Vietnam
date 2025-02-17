
A pet project of mine, this Arma 3 addon aims to recreate the iconic hunter-killer helicopter duos operated by the U.S. Airforce in Vietnam War. This addon contains many useful functions and modules that I have been creating over the years to help me develop fun missions.

Before the SOG Prairie Fire CDLC was released, this addon was aimed to work with the UNSUNG Vietnam War mod. After that, I reoriented it to work with the SOG CDLC instead, because it has less jank and the overall quality of the content is way higher.

Keeping the README up to date becomes more and more tedious, so instead I am going to describe the general direction and core features that define the addon.

### How to use
1. Place a helipad. 
2. Place Air Base Module on top of the helipad, sync "Side West" logic to the module to make this base available to BLUFOR helicopters. Optionally, you can also sync a "Respawn Point" logic. If this base is set to provide reinforcements, the newly spawned crew member will be spawned at this "Respawn Point" logic coordinates. Otherwise the newly spawned crew members is teleported inside the aircraft.
3. Place Air Command Module. 
4. Place any of the available OH6 helicopters, then sync it to the Air Command Module.

### Radio Framework
The new custom written radio framework allows a simple long range radio comms simulation. The main purpose of the framework was to separate units who have access to radio (are inside a vehicle with an on-board radio, standing near such a vehicle, have a radio backpack, or stand near someone who has such a backpack; ground placed radio stations are also supported and provide radio comms access in a small radius) from those who don't.  

5. After the mission is started, units with radio backpacks will make their group known to the OH6, which will allow OH6 to separate all known friendlies on the ground into clusters of different priorities (clusters with more units in them have bigger priorities. Clusters that already have been assigned their own OH6 will have their priorities lowered). The OH6 will then select a cluster with the highest priority and take station above them, patrolling the surroundings. 
6. OH6 will share knowledge about all spotted enemies using the radio framework. In Arma, if one unit of the group knows about enemy, all other group units will share that knowledge. AI controlled group leaders with RTOs in them will begin issuing engage orders to their subordinates, while players in such groups will have enemies revealed on map (map markers may be disabled depending on chosen in-game difficulty).

### Artillery Strike and Napalm Strike
A custom artillery strike script was written with shell fly-in sounds, camera shake and dirt falling from the sky hundreds of meters away from the impact. The napalm is fully scripted, too. I was not satisfied with the vanilla napalm, nor from the Unsung addon, nor from the SOG CDLC. To me, the dealbreaker was how long the mixture was burning (in real life, some napalm mixtures had burning time of as long as one minute) and how much bigger the area should be. In the end, I got a script that spawns napalm of a customizable radius and which burns for a customizable amount of time, while not impacting performance too much and not looking too bad. Anyone who gets caught in a blast will scream. After the napalm has burned out, the bodies will remain smoking for some time. Both artillery strikes and napalm impacts delete vegetation in a small radius.

### Fire Tasks
OH6 can assign Fire Tasks on enemy clusters. Right now, a Fire Task can either be an Artillery Strike or a Napalm Strike. A task is assigned depending on the size of the enemy cluster and the distance to the closest KNOWN friendly UNIT. A unit can become known either via the radio framework, or if the pilot has visually identified it (it's possible, but Arma pilots can be quite blind, so don't count on that too much). Once assigned, a Fire Task goes on a customizable cooldown.

7. The clusterization process described in p.6 is repeated once in a set amount of time. During that process OH6 "assesses" the situation, separating all friendly and all enemy units into clusters and assigning priotities to them. Enemy clusters with highest priorities (numbers of units in them) will be attempted to have a Fire Task assigned to them, while friendly clusters can have a OH6 assigned to take station above them.

### OH6 damage & maintenance
Even though I attempted to simulate the historical example as close as possible, Arma pilots can never fly their aircrafts with the same level of professionalism as shown by the hunter-killer crews during the Vietnam War. Which means, quite often OH6 will receive terminal damage or have their crew members injured or killed by the ground fire. On terrains with high mountains and low valleys, AI pilots can fail to gain height quickly enough, crashing right into the mountain. It is therefore recommended to use relatively flat terrains such as The Bra or Khe Sanh from the SOG CDLC. 

The Air Base Module with Repair+Refuel+Resupply enabled will partially repair the vehicle (configurable), fully refuel it and restock all of its ammunition. Bases with enabled Reinforcements will replace dead crew members. Both types of bases will fully heal the entire crew. The aircraft will attempt to land at the proper base should it receive critical damage or if any of the crew gets sufficiently injured or dies. If current pilot dies while co-pilot is present, an attempt will be made to transfer the piloting from the dead body of the pilot to the co-pilot. 

The aircrafts will land at the nearest Air Base if there isn't enough daylight for them to operate (NVGs weren't that practical in 1966).

### Gook Manager Module
Gook Manager is my implementation of an onslaught module that keeps spawning enemies on player's path. Module analyzes shifts of the player group cluster over time, and after a certain amount of assessments a trend (a general direction of movement) is formed. After that, the module can set up ambushes in front of the trend. The module assumes that players will be moving together as a single group and was designed with that assumption in mind.

This implementation began long before SOG CDLC was a thing. After SOG got released, they added a roughly similar module of their own. 

8. Place a Gook Manager Module.

### Garbage Collector Module
The Garbage Collector is a simple server side loop that performs distance and visibility checks and can remove dead bodies, traps and VC who strayed too far away from the players.

9. Place Garbage Collector Module.
10. Now you can start fiddling with your mission!

### To do
- [ ] Cobra's AI (historically the OH-6 scout reported targets to the Cobra's gunner who sat there with a map, jotting down coordinates which he then sent to the HQ or artillery support provider)
- [ ] Ability to call-in artillery barrages for ground troops.
- [ ] Broken Arrow. A unit could declare a Broken Arrow over the radio (friendly unit is danger of being overrun). 

