extends Node2D

@export var char_stats:CharacterStats

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var new_stats:CharacterStats = char_stats.create_instance()
	pass
