/mob/living/simple_animal/hostile/abnormality/cleaner
	name = "All-Around Cleaner"
	desc = "A tiny robot with helpful intentions."
	icon = 'ModularLobotomy/_Lobotomyicons/tegumobs.dmi'
	icon_state = "cleaner"
	icon_living = "cleaner"
	portrait = "cleaner"
	maxHealth = 800
	health = 800
	move_to_delay = 1.2
	ranged = TRUE
	attack_verb_continuous = "cleans"
	attack_verb_simple = "cleans"

/mob/living/simple_animal/hostile/abnormality/cleaner/Move()
	..()
	//Throw your suds little dude
	if(prob(5))
		var/list/turfs_in_range = list()
		for(var/turf/T in view(4, src))
			turfs_in_range += T

		var/turf/T = pick(turfs_in_range)
		var/list/soap_turfs = getline(src, T) - get_turf(src)
		soap_fire_line(src, soap_turfs)

	move_to_delay = 1.2
	//Toss meatbags aside
	for(var/mob/living/carbon/human/H in range(1, src))
		if(H.stat >= SOFT_CRIT)
					to_chat(cleaned_human, span_danger("[src] flawlessly cleans you of your features!"))
					ADD_TRAIT(cleaned_human, TRAIT_DISFIGURED, TRAIT_GENERIC) //cleans your face of uneeded features

/mob/living/simple_animal/hostile/abnormality/cleaner/Moved()
	..()
	move_to_delay = 3

/mob/living/simple_animal/hostile/abnormality/cleaner/update_icon_state()
	if(status_flags & GODMODE)
		icon = initial(icon)
		pixel_y = -8
		base_pixel_y = -8

//Funny slipping zone
/mob/living/simple_animal/hostile/abnormality/cleaner/proc/soap_fire_line(atom/source, list/turfs)
	for(var/turf/T in turfs)
		if(istype(T, /turf/closed))
			break
		new /obj/effect/turf_suds(T)
		sleep(1.5)

// Soap suds
/obj/effect/turf_suds
	gender = PLURAL
	name = "suds"
	desc = "slippery suds"
	icon = 'icons/effects/effects.dmi'
	icon_state = "foam"
	anchored = TRUE
	layer = TURF_LAYER
	plane = FLOOR_PLANE
	base_icon_state = "foam"
	//Lifespan of the effect.
	var/life_time = 10 SECONDS

/obj/effect/turf_suds/Initialize()
	. = ..()
	QDEL_IN(src, life_time)

/obj/effect/turf_suds/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/slippery, 40)

/* Work effects */
/mob/living/simple_animal/hostile/abnormality/cleaner/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
