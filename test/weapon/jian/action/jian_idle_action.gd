extends PlayerAction

var prepare_time:float =0.5
var prepare_range:float = 45
var interval_time:float =0.2
var hand_time:float = 0.3
var hand_range:float =-30

func is_performable()->bool:
	if player.no_idle:
		return false
	else:
		return true

func perform()->void:
	#记录数据和tween
	var ori_position:=weapon.position
	var tween = create_tween().bind_node(player).set_trans(Tween.TRANS_CUBIC)
	player.tween_commend.add_tween(tween,"weapon_idle")
	tween.tween_property(weapon,"rotation_degrees",prepare_range,prepare_time)
	tween.tween_property(weapon,"rotation_degrees",prepare_range/1.5,prepare_time/2)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(weapon,"rotation_degrees",-5,prepare_time*1.5)
	tween.parallel().tween_property(weapon,"position:y",weapon.position.y-2,prepare_time/2)
	#tween.parallel().tween_property(weapon,"rotation_degrees",-5,prepare_time/2)
	#tween.tween_interval(interval_time)
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.tween_property(weapon,"rotation_degrees",hand_range,hand_time)
	tween.parallel().tween_property(weapon,"position",ori_position,hand_time)
	tween.parallel().tween_property(weapon.sprite_2d,"scale",Vector2(-1.0,1.0),hand_time)
