extends PlayerAction

var prepare_range:float=0.01
var prepare_time:float=0.01

var bajian_time:=0.1
var bajian_range:=120

var velocity_range:float =300
var attack_time:float

var back_time:float

func is_performable()->bool:
	if player.no_exchange:
		return false
	else:
		return true

func perform()->void:
	#记录数据和tween
	type = exchange_attack
	#var tween = create_tween().bind_node(player)
	#player.tween_commend.add_tween(tween,type)
	#player.no_input.append(type)
	##蓄力
	#tween.tween_property(player.right_hand,"position",Vector2(4.5,4.0),prepare_time)
	#tween.tween_property(player.hand_anchor.right_hand_anchor,"rotation_degrees",bajian_range,bajian_time)
	#tween.parallel().tween_property(weapon,"rotation_degrees",bajian_range,bajian_time)
	#
	##player.right_hand
	#player.velocity.x =300
	#player.velocity.y=100
	#player.slow_down_speed = 200
	#player.in_gravity_slow_down = 9.5
	#
	
	

	#出招
	weapon.audio_stream_player_2d.play()
	weapon.monitoring = true

	#收枪


	#结束
	#await tween.finished
	interval_restatus()
	await player.get_tree().create_timer(0.2).timeout
	after_interval_restatus()
