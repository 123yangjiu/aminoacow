class_name Hand
extends Node

const weapon_template = preload("res://scene/weapon/weapon_templates.tscn")

@onready var hand_left: Sprite2D = $HandLeft
@onready var hand_right: Sprite2D = $HandRight


func add_weapon(weapon_stats:WeaponStats)->void:
	var weapon_ready = weapon_template.instantiate()
	weapon_ready.stats = weapon_stats
	self.add_child(weapon_ready)
	Events.hand_add_weapon.emit(weapon_ready)
	get_tree().get_first_node_in_group("Player").current_weapon = weapon_ready
