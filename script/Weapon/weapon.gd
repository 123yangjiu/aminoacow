class_name Weapon
extends Area2D

@onready var icon: Sprite2D = $Icon
@onready var attack_shape: CollisionShape2D = $AttackShape
@export var stats:WeaponStats :set = set_stats


var action_picker:WeaponActionPicker

func to_set_stats(the_stats:WeaponStats)->void:
	stats = the_stats

func set_stats(value:WeaponStats)->void:
	if ! is_inside_tree():
		await ready
	stats = value
	icon.texture = stats.icon
	attack_shape.shape = stats.attackshape
	attack_shape.position = stats.attackshape_offset
	self.position = stats.init_offset
	action_picker = stats.action.instantiate()
	action_picker.initial(self)
	add_child(action_picker)

func attack(direction)->void:
	var ready_action = action_picker.get_action()
	ready_action.perform(direction)

func _on_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is Ninja:
		body.char_stats.take_damage(stats.attack)
	pass # Replace with function body.
