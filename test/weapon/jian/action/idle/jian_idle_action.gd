extends PlayerAction

var prepare_time:float =0.5
var prepare_range:float = 20
var prepare_bounce_time := 0.3
var prepare_bounce_range := 12

var bounce_time :=1.1
var bounce_range:=-20

var hand_time:float = 0.2
var hand_up_range :=1.5
var hand_range:float =-30

func is_performable()->bool:
	if player.no_idle:
		return false
	else:
		return true

func perform()->void:
	#记录数据和tween
	type = idle
	var tween = create_tween().bind_node(player).set_trans(Tween.TRANS_CUBIC)
	player.tween_commend.add_tween(tween,type)
	#前倾再回弹
	tween.tween_property(weapon,"rotation_degrees",prepare_range,prepare_time)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(weapon,"rotation_degrees",prepare_bounce_range,prepare_bounce_time)
	#往回倒，手向上提
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(weapon,"rotation_degrees",bounce_range,bounce_time)
	tween.parallel().tween_property(weapon,"position:y",weapon.position.y-hand_up_range,bounce_time)
	#倒在肩上
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(weapon,"rotation_degrees",hand_range,hand_time)
	tween.parallel().tween_property(weapon,"position",weapon.status.init_offset,hand_time)
	tween.parallel().tween_property(weapon.sprite_2d,"scale",Vector2(-1.0,1.0),hand_time)
