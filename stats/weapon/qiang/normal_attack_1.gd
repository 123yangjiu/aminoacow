extends WeaponAction


var interval_1 := Vector2(-1,0)
var interval_1_time := 0.02
var end := Vector2(8,0)
var end_time := 0.1
var return_time := 0.05

func perform()->void:
	if ! weapon:
		return
	weapon.attack_shape.disabled = false
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	var start := player_hand.position
	player.is_action = true
	tween.tween_property(player_hand,"position",start+interval_1,interval_1_time)
	tween.tween_property(player_hand,"position",start+end,end_time)
	tween.tween_property(player_hand,"position",start,return_time)
	await tween.finished
	weapon.attack_shape.disabled = true
	player.is_action = false
