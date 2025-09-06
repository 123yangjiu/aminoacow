extends WeaponAction

func perform(direction : bool) -> void:
	if !weapon:
		return
	var dir = 1 if direction else -1
	weapon.attack_shape.disabled = false
	player.is_action = true
	
	var tween = create_tween()
	tween.tween_property(player_hand, "rotation_degrees", 90 * dir, 0.25).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(player_hand, "rotation_degrees", 0, 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	await tween.finished
	
	player.is_action = false
	weapon.attack_shape.disabled = true
	
	
	pass
