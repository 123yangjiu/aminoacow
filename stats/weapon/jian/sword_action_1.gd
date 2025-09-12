extends WeaponAction

#参数外放方便处理
var rotation := 145
var end_time := 0.2
var back_time := 0.1

func perform(direction : bool) -> void:
	if !weapon:
		return
	var dir = 1 if direction else -1
	weapon.attack_shape.disabled = false
	player.is_action = true
	
	var tween = create_tween()
	tween.tween_property(player_hand, "rotation_degrees", rotation * dir, end_time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(player_hand, "rotation_degrees", 0,back_time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BOUNCE)
	await tween.finished
	
	player.is_action = false
	weapon.attack_shape.disabled = true
	
	
	pass
