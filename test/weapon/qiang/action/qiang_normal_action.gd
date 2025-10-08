extends PlayerAction

var prepare_time :=0.1
var prepare_range :=5
var attack_range := 15
var attack_time :=0.07
var back_time :=0.03

func is_performable()->bool:
	if player.no_attack:
		return false
	else:
		return true

func perform()->void:
	#记录数据和tween
	var hand_position = hand.position
	var tween = create_tween().bind_node(player)
	player.tween_commend.add_tween(tween,"weapon")
	#蓄力
	tween.tween_property(hand,"position",hand_position-Vector2(prepare_range,0)*player.direction,prepare_time)
	#出招
	weapon.monitoring = true
	weapon.audio_stream_player_2d.play()
	tween.tween_property(hand,"position",hand_position+Vector2(attack_range,0)*player.direction,attack_time)
	#收枪
	tween.tween_property(hand,"position",hand_position,back_time)
	#结束
	await tween.finished
	weapon.audio_stream_player_2d.stop()
	weapon.monitoring = false
	player.no_direction.erase("attack")
	player.no_roll.erase("attack")
	player.no_attack.erase("attack")
	await player.get_tree().create_timer(0.15).timeout
	player.no_bend.erase("attack")
	player.no_shake.erase("attack")
