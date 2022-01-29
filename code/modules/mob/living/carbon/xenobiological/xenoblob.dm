/* Xenobio rework stuff
 * Currently has:
 *		structure/xenoblob
 *		creep
 *		nodes
 *		node/cores

 * In this file we need:
 * 		mutation
 */


/obj/structure/xenoblob
	icon = 'icons/mob/xenoblob.dmi'
<<<<<<< Updated upstream
	var/max_integrity
	var/obj_integrity

/obj/structure/xenoblob/Initialize()
	. = ..()
	obj_integrity = max_integrity

/obj/structure/xenoblob/take_damage(damage)
	..()
	obj_integrity = min(obj_integrity - damage, 0) 
	playsound(src.loc, 'sound/effects/attackblob.ogg', 50, 1)
=======
	var/max_health

/obj/structure/xenoblob/play_attack_sound(damage_amount, damage_type, damage_flag)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(src.loc, 'sound/effects/attackblob.ogg', 50, 1)
		if(BURN)
			playsound(src.loc, 'sound/items/welder.ogg', 100, 1)
>>>>>>> Stashed changes


/*
 * CREEP (acts like vines)
 */

/obj/structure/xenoblob/creep
	gender = PLURAL
	name = "slime creep"
	desc = "A layer of slime covers the floor here. Ewww..."
	anchored = TRUE
	density = FALSE
<<<<<<< Updated upstream
	layer = BELOW_DOOR_LAYER
	icon_state = "creep"
	max_integrity = 30
	can_buckle = TRUE
	buckle_lying = 1
=======
	layer = TURF_LAYER
	icon_state = "creep"
	max_health = 30
	can_buckle = 1
>>>>>>> Stashed changes
	//canSmoothWith = list(/obj/structure/xenoblob/creep, /turf/closed/wall)
	//smooth = SMOOTH_MORE

	var/last_expand = 0 // Last world.time this creep expanded
	var/growth_cooldown = 100
	var/node_timer = 0
	var/absorb_time = 200 // How long a (non-bio protected) mob has to be buckled (and dead) before becoming a node

<<<<<<< Updated upstream
=======
	var/static/list/blacklisted_turfs // What turfs this can't grow on

>>>>>>> Stashed changes
	var/grabbing = FALSE // If the slime is currently working on buckling a mob
	var/absorbing = FALSE // If the creep is currently making a node

	var/obj/structure/xenoblob/node/owner_node // What node controls this creep. If none (node is cut out), maybe start dying?
	var/obj/structure/xenoblob/node/core/owner_core // If owned by a core, this is owner_node, if not, this is owner_node.owner_core. basically what blob this belongs to

<<<<<<< Updated upstream
	var/buckle_timer // How long it takes a (non bio-protected) mob to get buckled to creep in deciseconds
	var/eat_damage // How much damage this slime deals to a buckled mob
=======
	var/buckle_timer = 30 // How long it takes a (non bio-protected) mob to get buckled to creep in deciseconds
	var/eat_damage = 10 // How much damage this slime deals to a buckled mob
>>>>>>> Stashed changes

/obj/structure/xenoblob/creep/Initialize(mapload, var/obj/structure/xenoblob/node/owner = null)
	. = ..()
	if(owner)
		owner_node = owner
		buckle_timer = owner.scolor.buckle_timer
		eat_damage = owner.scolor.eat_damage
		owner_node.creeps += src
		if(owner_node.is_core)
			owner_core = owner_node
		else
			owner_core = owner_node.owner_core
		owner_node.creeps += src
<<<<<<< Updated upstream
	last_expand = world.time + growth_cooldown

/obj/structure/xenoblob/creep/take_damage(damage)
	. = ..()
	if(obj_integrity <= 0)
		Destroy()

/obj/structure/xenoblob/creep/proc/expand(var/node)
	var/turf/U = get_turf(src)
	if(istype(U, /turf/unsimulated/) || istype(U, /turf/space) || (istype(U, /turf/simulated/mineral) && U.density))
		qdel(src)
		return FALSE

	for(var/direction in GLOB.cardinal) // Go through all cardinal turfs
		var/turf/T = get_step(src, direction)

		if(!U.Adjacent(T))
			continue

=======
	if(!blacklisted_turfs)
		blacklisted_turfs = typecacheof(list(
			/turf/open/space,
			/turf/open/chasm,
			/turf/open/lava))
	last_expand = world.time + growth_cooldown

/obj/structure/xenoblob/creep/proc/expand(var/node)
	var/turf/U = get_turf(src)
	if(is_type_in_typecache(U, blacklisted_turfs))
		qdel(src)
		return FALSE

	for(var/turf/T in U.GetAtmosAdjacentTurfs())
>>>>>>> Stashed changes
		var/obj/structure/xenoblob/creep/C = locate(/obj/structure/xenoblob/creep) in T
		if(C)
			if(!C.owner_node)
				C.owner_node = owner_node
				owner_node.creeps += C
			continue

<<<<<<< Updated upstream
		if(T.density)
			continue
        
		if(istype(T, /turf/unsimulated/) || istype(T, /turf/space) || (istype(T, /turf/simulated/mineral) && T.density))
=======
		if(is_type_in_typecache(T, blacklisted_turfs))
>>>>>>> Stashed changes
			continue

		new /obj/structure/xenoblob/creep(T, node)
	return TRUE

/obj/structure/xenoblob/creep/proc/on_step(var/mob/living/M) // Add stuff/override this for different slime step effects
<<<<<<< Updated upstream
	if(buckled_mob || M.stat == DEAD) // Shouldn't do any effect or try to grab again if it has something, or if the mob is dead
		return FALSE

	var/delay = buckle_timer// * 1 + M.getarmor(type = "bio")/20 // Bio protection increases the time, bio suit will make it take 5x as long
=======
	if(has_buckled_mobs() || M.stat == DEAD) // Shouldn't do any effect or try to grab again if it has something, or if the mob is dead
		return

	owner_node.scolor.effect(M, src) // color-specific effects go here

	var/delay = buckle_timer * 1 + M.getarmor(type = "bio")/20 // Bio protection increases the time, bio suit will make it take 5x as long
>>>>>>> Stashed changes
	grabbing = TRUE
	M.visible_message("<span class='warning'>[src] starts latching on to [M]!</span>", \
				"<span class='userdanger'>You feel [src] wrapping around you!</span>")
	if(do_after(M, delay))
		if(src.buckle_mob(M, TRUE))
			M.visible_message("<span class='warning'>[src] latches on to [M]!</span>", \
				"<span class='userdanger'>The [src] envelops you!</span>")
		else
			M.visible_message("<span class='warning'>[src] fails to latch on to [M]!</span>", \
				"<span class='warning'>The [src] tries to envelop you, but fails.</span>")
	grabbing = FALSE
<<<<<<< Updated upstream
	return TRUE

/obj/structure/xenoblob/creep/proc/process_mob()
	if(buckled_mob) // Eating buckled mobs
		if(buckled_mob.stat != DEAD) // If it isn't dead, eat
			eat(buckled_mob)
		else if(!absorbing && buckled_mob.stat == DEAD) // If buckled mob dead and creep not absorbing, start
			node_timer = world.time + absorb_time
			absorbing = TRUE
			visible_message("<span class='warning'>[src] starts absorbing [buckled_mob]!</span>")
		else if (node_timer <= world.time) // If finished absorbing (and still has mob attached), attempt to make node
			if(buckled_mob)
				var/mob/living/M = buckled_mob
				unbuckle_mob()
=======

/obj/structure/xenoblob/creep/proc/process_mob()
	for(var/mob/living/M in buckled_mobs) // Eating buckled mobs
		if(M.stat != DEAD) // If it isn't dead, eat
			eat(M)
		else if(!absorbing && M.stat == DEAD) // If buckled mob dead and creep not absorbing, start
			node_timer = world.time + absorb_time
			absorbing = TRUE
			visible_message("<span class='warning'>[src] starts absorbing [M]!</span>")
		else if (node_timer <= world.time) // If finished absorbing (and still has mob attached), attempt to make node
			if(buckled_mobs.Find(M))
>>>>>>> Stashed changes
				make_node(M)
				absorbing = FALSE
			else
				visible_message("<span class='warning'>[src] fails to absorb anything!</span>")

/obj/structure/xenoblob/creep/proc/eat(var/mob/living/M)
<<<<<<< Updated upstream
	//var/bio_modifier = 1 //+ M.getarmor(type = "bio")/20
	//var/damage = eat_damage / bio_modifier
	var/datum/reagents/splash_reagents = owner_node.sac.reagents
	
	// splash digestive enzymes to deal damage, cooler than just applying burn/tox
	splash_reagents.splash(M, 10, min_spill = 0, max_spill = 0)
	if(M.isMonkey())
		splash_reagents.trans_to_mob(M, 10, CHEM_BLOOD) // Speed up digesting monkeys for working
	if(prob(5))
		splash_reagents.trans_to_mob(M, 5, CHEM_BLOOD) // Inject some reagents sometimes
		to_chat(M, "<span class='warning'>You feel the slime pierce your skin!</span>")
	
=======
	var/bio_modifier = 1 + M.getarmor(type = "bio")/20
	var/damage = eat_damage / bio_modifier
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(ismonkey(M))
			C.adjustCloneLoss(damage) // Speed things up a bit for working
		C.adjustCloneLoss(damage)
		C.adjustToxLoss(damage/2)
	else if(isanimal(M))
		var/mob/living/simple_animal/SA = M
		SA.adjustCloneLoss(damage)
		SA.adjustToxLoss(damage/2)
>>>>>>> Stashed changes
	owner_core.add_hunger(30)

/obj/structure/xenoblob/creep/proc/make_node(var/mob/living/M)
	src.visible_message("<span class='warning'>[M] was engulfed by [src]!</span>")
	var/obj/structure/xenoblob/node/N
	if(src.owner_node.is_core)
		N = new /obj/structure/xenoblob/node(loc, src.owner_node) // If creep is owned by a core, set new node's core to it
	else
		N = new /obj/structure/xenoblob/node(loc, src.owner_node.owner_core) // If creep is owned by a node, set node's core to its core
	var/atom/movable/AM = M
	AM.forceMove(N) // Add this mob to contents of the new node, to be spit out on destroy

<<<<<<< Updated upstream
/obj/structure/xenoblob/creep/user_unbuckle_mob(mob/user) // Make it take some time to unbuckle, overrides normal unbuckling
	if(buckled_mob)
		var/mob/living/M = buckled_mob
		if(M != user)
			user.visible_message("<span class='notice'>[user] begins to pull [M] free of the [src]...</span>", \
				"<span class='notice'>You begin to pull [M] free of the [src]...</span>")
			if(!do_after(user, 30, M))
=======
/obj/structure/xenoblob/creep/user_unbuckle_mob(mob/living/M, mob/user) // Make it take some time to unbuckle, overrides normal unbuckling
	if(has_buckled_mobs())
		if(M != user)
			user.visible_message("<span class='notice'>[user] begins to pull [M] free of the [src]...</span>", \
				"<span class='notice'>You begin to pull [M] free of the [src]...</span>")
			if(!do_mob(user, M, 30))
>>>>>>> Stashed changes
				return
			user.visible_message("<span class='notice'>[user] rips [M] free of the [src]!</span>", \
				"<span class='notice'>You rip [M] free of the [src]!</span>")
		else
			M.visible_message("<span class='warning'>[M] struggles to get the slime off!</span>", \
				"<span class='warning'>You struggle to get the slime off... (Stay still for 10 seconds.)</span>")
			if(!do_after(M, 100, target = src))
				if(M && M.buckled)
					to_chat(M, "<span class='warning'>You fail to free yourself!</span>")
				return
			if(!M.buckled)
				return
			M.visible_message("<span class='warning'>[M] rips the slime off!</span>", \
				"<span class='notice'>You rip the slime off!</span>")
<<<<<<< Updated upstream
		unbuckle_mob()

/obj/structure/xenoblob/creep/Destroy()
	..()
=======
		unbuckle_all_mobs(TRUE)

/obj/structure/xenoblob/creep/Destroy()
>>>>>>> Stashed changes
	if(owner_node)
		owner_node.creeps -= src
		qdel(src)

/*
 * NODE
 */

/obj/structure/xenoblob/node
	gender = NEUTER
	name = "slime node"
	desc = "A mound of slime that contains what looks like... a living thing?"
	icon_state = "node"
	anchored = TRUE
	density = TRUE
<<<<<<< Updated upstream
	layer = STRUCTURE_LAYER
=======
	layer = MOB_LAYER
	plane = GAME_PLANE
>>>>>>> Stashed changes
	max_integrity = 200 // Should probably be used as health value

	var/extract_amount = 1 // How many extracts you'll get when harvesting, default 1 on nodes

	var/datum/slimecolor/scolor // Holds agression info, effect() (for on_step()), range, color
	var/mutation_chance // Unsure how to use yet

	var/frozen = FALSE // If the node is frozen (by an endothermic trimmer) or not, should halt operations but stay alive
	var/thawing_time = 900 // How long until this node thaws. Might be changed in different slime types
<<<<<<< Updated upstream
	var/desecrated = FALSE // If the node has been completely desecrated by cold/a weapon. Makes it unharvesable and unsalvageable
=======
	var/desecrated = FALSE // If the node has been completely desecrated by cold. Makes it unharvesable, and won't thaw unless heated to very high temps
>>>>>>> Stashed changes

	var/obj/structure/xenoblob/node/core/owner_core // What core controls this node. If none (core is killed), probably start becoming a core
	var/is_core = FALSE // If this is a node or a core. simplifes having to do if(X.owner_node == /obj/structure/xenoblob/node/core)

<<<<<<< Updated upstream
	var/range = 0 // How far the node will spread creep out to. Keep in mind that expand() makes creep on all adjacent tiles, so real range is this +1
	var/list/creeps // List of tiles controlled by this node
	var/obj/item/slimesac/sac // Reference to this node/core's slimesac
=======
	var/range = 2 // How far the node will spread creep out to. Keep in mind that expand() makes creep on all adjacent tiles, so real range is this +1
	var/list/creeps // List of tiles controlled by this node
>>>>>>> Stashed changes

/obj/structure/xenoblob/node/Initialize(mapload, var/owner, var/datum/slimecolor/slmcolor) //scolor for slimecolor, in case we want to make a new node/core with X color (slime extracts growing into nodes?)
	. = ..()
	creeps = list()
	if(owner)
		owner_core = owner
		scolor = owner_core.scolor
		owner_core.controlled_nodes += src
	if(slmcolor)
		scolor = slmcolor
	if(!scolor)
		scolor = new /datum/slimecolor/grey
	if(!(locate(/obj/structure/xenoblob/creep) in loc))
		new /obj/structure/xenoblob/creep(loc, src)
<<<<<<< Updated upstream
	name = "[scolor.name] slime [is_core ? "core" : "node"]"
	sac = new /obj/item/slimesac(src, src)
	START_PROCESSING(SSobj, src)

/obj/structure/xenoblob/node/take_damage(damage)
	. = ..()
	if(obj_integrity <= 0)
		desecrated = TRUE

=======
	START_PROCESSING(SSobj, src)

>>>>>>> Stashed changes
/obj/structure/xenoblob/node/Destroy()
	STOP_PROCESSING(SSobj, src)
	for(var/atom/movable/AM in contents)
		AM.forceMove(src.loc)
	for(var/obj/structure/xenoblob/creep/C in creeps)
		C.owner_node = null
		C.owner_core = null // We don't want it having a core and not having a node.
	return ..()

<<<<<<< Updated upstream
/obj/structure/xenoblob/node/Process()
=======
/obj/structure/xenoblob/node/process()
>>>>>>> Stashed changes
	if(frozen || desecrated)
		anchored = FALSE
		return // Don't do process stuff if frozen/super frozen
	else
		anchored = TRUE

	if(!(locate(/obj/structure/xenoblob/creep) in loc)) // Always have a creep below the node/core
		new /obj/structure/xenoblob/creep(loc, src)

	for(var/obj/structure/xenoblob/creep/C in range(range, src)) // Expands the creep in a range, and sets cooldown
		if(C.last_expand <= world.time)
			if(C.expand(src))
				C.last_expand = world.time + C.growth_cooldown

<<<<<<< Updated upstream
	sac.regen_reagents()

	for(var/obj/structure/xenoblob/creep/C in creeps)
		if(C.buckled_mob) // If it has a mob, process it
=======
	for(var/obj/structure/xenoblob/creep/C in creeps)
		if(C.has_buckled_mobs()) // If it has a mob, process it
>>>>>>> Stashed changes
			C.process_mob()
		else if(C.absorbing) // If it doesn't have a mob and still thinks it's absorbing, stop absorbing
			C.visible_message("<span class='warning'>[C] stops absorbing it's victim!</span>")
			C.absorbing = FALSE

		if(!C.grabbing)
<<<<<<< Updated upstream
			for(var/mob/living/M in C.loc) // Does slime color effects
				if(C.on_step(M) && prob(5)) // If not holding a mob, have a chance to do effect
					scolor.effect(M, C) // color-specific effects go here
=======
			for(var/mob/living/M in C.loc) // I think on_step() should be overriden to do step effects for slime colors, and we probably need a cooldown
				C.on_step(M)
>>>>>>> Stashed changes

/obj/structure/xenoblob/node/proc/uproot()
	frozen = TRUE
	for(var/obj/structure/xenoblob/creep/C in creeps)
		C.owner_node = null
	owner_core = null	//for now.
	creeps = null

/*
<<<<<<< Updated upstream
 *  Slime Sac (thing that digests captures)
 */

/obj/item/slimesac
	gender = NEUTER
	name = "slime sac"
	desc = "A digestive organelle harvested from a slime. Can contain large volumes of rare reagents."

	var/obj/structure/xenoblob/node/owner // What node contains this slimesac

/obj/item/slimesac/Initialize(mapload, var/owner_node)
	. = ..()
	if(owner_node)
		owner = owner_node
		name = "[owner.scolor.name] slime sac"
	create_reagents(1000)
	for(var/R in owner.scolor.digestive_reagents)
		reagents.add_reagent(R, 1000/length(owner.scolor.digestive_reagents)) // Equal amount of all reagents in list

/obj/item/slimesac/proc/regen_reagents() // Called when in a node
	reagents.add_reagent(pick(owner.scolor.digestive_reagents), 5)

/*
=======
>>>>>>> Stashed changes
 * CORE (node+)
 */

/obj/structure/xenoblob/node/core
	name = "slime core"
	desc = "A translucent, pulsating mass of slime containing glowing cores."
	max_integrity = 400
<<<<<<< Updated upstream
	extract_amount = 1
	range = 1
=======
	extract_amount = 1 // Placeholder amount until tile counts are kept
	range = 3
>>>>>>> Stashed changes
	is_core = TRUE

	var/total_tiles // Total of all tiles controlled by this blob, including tiles controlled by its nodes.
	var/list/controlled_nodes // List of all nodes controlled by this core

<<<<<<< Updated upstream
	// max hunger and aggression are in blobcolor.dm
	var/current_hunger // Directly relates to aggression rate
	var/aggression = 0 // Should do stuff like speed up eating, speed up buckling, maybe make step effects worse?, and make slimes come out of the core at a certain point
	var/aggression_rate = 0 // How fast agression goes up, could be locked by BZ gas and the CBZ reagent, and slowed down by frost oil and tramadol
=======
	// max hunger and agression are in __DEFINES/xenoblob.dm
	var/current_hunger // Directly relates to aggression rate
	var/aggression // Should do stuff like speed up eating, speed up buckling, maybe make step effects worse?, and make slimes come out of the core at a certain point
	var/aggression_rate // How fast agression goes up, could be locked by BZ gas and the CBZ reagent, and slowed down by frost oil and morphine
>>>>>>> Stashed changes

/obj/structure/xenoblob/node/core/Initialize(mapload, owner, scolor)
	. = ..()
	controlled_nodes = list()
<<<<<<< Updated upstream
	create_reagents(100)
	current_hunger = src.scolor.max_hunger / 2

/obj/structure/xenoblob/node/core/Process()
=======
	create_reagents(100, INJECTABLE)
	current_hunger = src.scolor.max_hunger / 2
	aggression = 0

/obj/structure/xenoblob/node/core/process()
>>>>>>> Stashed changes
	. = ..()
	calculate_extracts()
	metabolize()

/obj/structure/xenoblob/node/core/proc/calculate_extracts() // Adds the count of total tiles, used to hardcap number of tiles like in the doc
	var/total_t
	if(controlled_nodes)
		for(var/obj/structure/xenoblob/node/N in controlled_nodes)
			total_t += N.creeps.len

	total_t += creeps.len
	total_tiles = total_t
	extract_amount = max(round(total_t/10), 1) // extract amount is dependant on tiles controlled, minimum 1

/obj/structure/xenoblob/node/core/proc/add_hunger(var/added_hunger)
	current_hunger = min(scolor.max_hunger, current_hunger + added_hunger)

/obj/structure/xenoblob/node/core/proc/add_aggression(var/added_aggression)
	aggression = min(scolor.max_aggression, aggression + added_aggression)

/obj/structure/xenoblob/node/core/proc/metabolize() // Everything to deal with hunger, reagent processing, and aggression
	if(current_hunger >= 0)
		current_hunger = max(0, current_hunger - 1)
		obj_integrity = min(max_integrity, obj_integrity + src.scolor.regen) // regen

	var/max_hunger = scolor.max_hunger
	var/list/aggro = scolor.aggression_rate
<<<<<<< Updated upstream
	switch(current_hunger) 
		if(0 to max_hunger * 0.05) // Starving, 5  aggression a tick
=======
	switch(current_hunger)
		if(0 to max_hunger * 0.05) // Starving, 4 aggression a tick
>>>>>>> Stashed changes
			aggression_rate = aggro[1]
		if(max_hunger * 0.05 to max_hunger * 0.25) // VERY hungry, 2 aggression a tick
			aggression_rate = aggro[2]
		if(max_hunger * 0.25 to max_hunger * 0.40) // Somewhat hungry, 1 aggression a tick
			aggression_rate = aggro[3]
		if(max_hunger * 0.40 to max_hunger * 0.60) // Sated, no aggression change
			aggression_rate = aggro[4]
		if(max_hunger * 0.60 to max_hunger * 0.75) // Full, lose 1 aggression a tick
			aggression_rate = aggro[5]
		if(max_hunger * 0.75 to max_hunger) // Stuffed, lose 2 aggression a tick
			aggression_rate = aggro[6]

	var/temp_aggression_rate = aggression_rate
	for(var/datum/reagent/R in reagents.reagent_list)
		switch(R.type)
			if(/datum/reagent/blood)
				add_hunger(40) // blood metabolizes super fast (5u a tick) so it needs to add a ton of hunger
<<<<<<< Updated upstream
			if(/datum/reagent/tramadol)
				temp_aggression_rate = max(aggro[6], aggression_rate + 1)
			if(/datum/reagent/frostoil)
				temp_aggression_rate = max(aggro[6], aggression_rate + 2)
		reagents.remove_reagent(R.type, R.metabolism)

	add_aggression(temp_aggression_rate)
=======
			if(/datum/reagent/medicine/morphine)
				temp_aggression_rate = max(aggro[6], aggression_rate - 1)
			if(/datum/reagent/consumable/frostoil)
				temp_aggression_rate = max(aggro[6], aggression_rate - 2)
		reagents.remove_reagent(R.type, R.metabolization_rate)

	add_aggression(max(0, aggression + temp_aggression_rate))
>>>>>>> Stashed changes
