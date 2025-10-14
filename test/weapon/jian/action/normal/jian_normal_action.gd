extends PlayerAction


var prepare_time :=0.05
var prepare_range:=-40

var attack_range:=160
var attack_time:=0.1

var back_time:=0.1

func is_performable()->bool:
	if player.no_attack:
		return false
	else:
		return true

func perform()->void:
	#记录数据和tween
	type = normal_attack
	var tween = create_tween().bind_node(player)
	player.tween_commend.add_tween(tween,type)
	#蓄力
	tween.tween_property(hand,"rotation_degrees",prepare_range*player.direction,prepare_time)

	#出招
	weapon.monitoring = true
	tween.set_ease(Tween.EASE_OUT).tween_property(hand,"rotation_degrees",attack_range*player.direction,attack_time)
	#收枪
	tween.tween_property(hand,"rotation_degrees",0,back_time)

	#结束
	await tween.finished
	interval_restatus()
	await player.get_tree().create_timer(0.2).timeout
	after_interval_restatus()
