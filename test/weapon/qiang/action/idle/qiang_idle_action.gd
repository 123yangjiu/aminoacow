extends PlayerAction

var prepare_time:float =0.3
var prepare_range:float = 3
var action_time:float = 0.8
var action_range:float =720
var up_range:float =25

func is_performable()->bool:
	if player.no_idle:
		return false
	else:
		return true

func perform()->void:
	type = idle
	#记录数据和tween
	weapon.rotation_degrees=0
	var ori_position = hand.position
	var tween = create_tween().bind_node(player).set_trans(Tween.TRANS_CUBIC)
	player.tween_commend.add_tween(tween,type)
	#预备
	tween.tween_property(hand,"position:y",hand.position.y+prepare_range,prepare_time)
	#上抛
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(hand,"position:y",ori_position.y,prepare_time/2)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property(weapon,"position:y",weapon.position.y-up_range,action_time)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.parallel().tween_property(weapon,"rotation_degrees",action_range,action_time)
	#回来
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(weapon,"position",weapon.current_status.init_offset,action_time)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.parallel().tween_property(weapon,"rotation_degrees",action_range*2,action_time)
