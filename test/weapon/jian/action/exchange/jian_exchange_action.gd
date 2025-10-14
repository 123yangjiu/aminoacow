extends PlayerAction

var prepare_range:float
var prepare_time:float

var attack_range:float
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
	var tween = create_tween().bind_node(player)
	player.tween_commend.add_tween(tween,type)
	#蓄力
	

	#出招
	weapon.audio_stream_player_2d.play()
	weapon.monitoring = true

	#收枪


	#结束
	await tween.finished
	interval_restatus()
	await player.get_tree().create_timer(0.2).timeout
	after_interval_restatus()
