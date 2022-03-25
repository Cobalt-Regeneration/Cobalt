/obj/item/organ/external/head/insectoid/nabber
	name = "head"
	vital = 0
	action_button_name = "Switch Stance" // Basically just a wrapper for switch stance verb, since GAS use it more than normals.
	limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_GENDERED_ICON | ORGAN_FLAG_CAN_BREAK

/obj/item/organ/external/head/insectoid/nabber/get_eye_overlay()
	var/list/overlay_list = list()
	for(var/slot in list(BP_L_EYE, BP_R_EYE))
		var/obj/item/organ/internal/eye/E = owner.internal_organs_by_name[slot]
		if(E)
			overlay_list += E.get_special_overlay()

/obj/item/organ/external/head/insectoid/nabber/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "nabber-stance-[owner && owner.pulling_punches ? 1 : 0]"
		if(action.button) action.button.UpdateIcon()

/obj/item/organ/external/head/insectoid/nabber/attack_self(var/mob/user)
	. = ..()
	if(.)
		owner.pull_punches()
		refresh_action_button()
