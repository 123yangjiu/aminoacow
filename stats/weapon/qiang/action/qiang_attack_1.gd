extends WeaponAction

var end := Vector2(12,0)
var end_time := 0.1
var return_time := 0.05

func perform(direction)->void:
	if ! weapon:
		return
	var dir = 1 if direction else -1
	weapon.attack_shape.disabled = false
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	var start = player_hand.position
	player.is_action = true
	tween.tween_property(player_hand,"position",start+end*dir,end_time)
	tween.tween_property(player_hand,"position",start,return_time)
	await tween.finished
	weapon.attack_shape.disabled = true
	player.is_action = false
