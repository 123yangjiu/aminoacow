class_name ChararacterStats
extends Resource

@warning_ignore("unused_signal")
signal stats_changed
signal image_changed

@export var max_health:int
@export var art:Texture2D
@export var speed:float
@export var jump_speed:float

var health:int :set = set_health
var health_mode:float = 1.0


func set_health(value:int)->void:
	health = clampi(value,0,max_health)
	stats_changed.emit()
	var ori_health_mode = health_mode
	health_mode = 0  #满血时是1，半血是0.5
	for i in range(10):
		if health>max_health*(i)*0.1 and health <=max_health*0.1*(i+1):
			health_mode = (i+1)*0.1
	if abs(health_mode-ori_health_mode) > 0:
		image_changed.emit()

func take_damage(damage:int)->void:
	health -= damage
