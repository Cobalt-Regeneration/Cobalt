/datum/species/human/cult
	name = "Cult"
	spawn_flags = SPECIES_IS_RESTRICTED
	brute_mod = 2
	burn_mod = 2
	species_flags = SPECIES_FLAG_NO_SCAN
	force_cultural_info = list(
		TAG_CULTURE =   CULTURE_CULTIST,
		TAG_HOMEWORLD = HOME_SYSTEM_STATELESS,
		TAG_FACTION =   FACTION_OTHER
	)

/datum/species/human/cult/handle_death(var/mob/living/carbon/human/H)
	spawn(1)
		if(H)
			H.dust()

/datum/species/human/cult/handle_post_spawn(var/mob/living/carbon/human/H)
	H.s_tone = 35
	H.r_l_eye = 230
	H.b_l_eye = 7
	H.g_l_eye = 7
	H.r_r_eye = 230
	H.b_r_eye = 7
	H.g_r_eye = 7
	H.update_eyes()
