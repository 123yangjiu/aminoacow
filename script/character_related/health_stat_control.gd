extends Control

func _ready() -> void:
	Events.player_hp_changed.connect(_set_hp)

func _set_hp(hp : float, max_health : int):
	print("Set to ", hp, " with ", max_health)
	#$Sprite2D.set_instance_shader_parameter("hp", hp)
	$Sprite2D.material.set_shader_parameter("hp", hp)
	$Label.text = "HP: %d/%d" % [int(hp * max_health), max_health]
