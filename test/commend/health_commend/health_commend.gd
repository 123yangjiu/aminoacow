class_name HealthCommend
extends Node

@export var max_health:int
@export var _owner:Node
@export var shader_owner:Node

var current_health:int :set = set_health

signal died(who)
signal health_change(current_health)

func _ready() -> void:
	current_health = max_health

func take_damage(damage:int)->void:
	current_health -=damage 


func set_health(value)->void:
	current_health = max(value,0)
	health_change.emit(current_health)
	var health_mode := int(10*float(current_health)/float(max_health))*0.1
	if shader_owner.material:
		shader_owner.material.set_shader_parameter("health_range",health_mode)
	if current_health == 0:
		died.emit(_owner)
