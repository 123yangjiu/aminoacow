extends WeaponAction

@export var arrowScene : PackedScene

func perform(direction : bool) -> void:
	if !weapon:
		return
		
	weapon.attack_shape.disabled = false
	player.is_action = true
	
	var start = player_hand.position
	var tween = create_tween()
	var dir = 1 if direction else -1
	var offset = Vector2(2, 0)

	tween.tween_property(player_hand, "position", start + offset * dir, 0.1).set_trans(Tween.TRANS_LINEAR)
	tween.parallel().tween_property(player_hand, "rotation_degrees", -10 * dir, 0.2).set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_IN)
	tween.tween_property(player_hand, "position", start, 0.1).set_trans(Tween.TRANS_LINEAR)
	
	await tween.finished

	var arrow = arrowScene.instantiate()
	add_child(arrow)
	arrow.shot(player_hand.global_position, direction, weapon.stats.attack, 1)

	tween = create_tween()
	tween.tween_property(player_hand, "rotation_degrees", 0, 0.3).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	await tween.finished
	
	weapon.attack_shape.disabled = true
	player.is_action = false
