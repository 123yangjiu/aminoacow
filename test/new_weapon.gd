#tool
class_name NewWeapon
extends Area2D

#status
@export var status:NewWeaponStatus
@export var hand:Node

#node
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
var normal_action:PlayerAction
var exchange_action:PlayerAction

func _init_status() -> void:
	sprite_2d.texture = status.texture
	self.position = status.init_offset
	collision_shape_2d.shape = status.attackshape
	collision_shape_2d.disabled = true
	collision_shape_2d.position = status.attackshape_offset
	normal_action = null
	exchange_action = null
	if status.normal_action:
		normal_action = status.normal_action.instantiate()
	if status.exchange_action:
		exchange_action = status.exchange_action.instantiate()

func play_normal(who:NewPlayer)->void:
	if normal_action.hand ==null:
		normal_action.hand = hand
		normal_action.player = who
		normal_action.weapon = self
	if ! normal_action.is_performable():
		return
	who.no_direction.append("attack")
	who.no_roll.append("attack")
	who.no_attack.append("attack")
	who.no_bend.append("attack")
	who.no_shake.append("attack")
	normal_action.perform()

func play_exchange(who:NewPlayer)->void:
	print("ACTION")
	if exchange_action.hand ==null:
		exchange_action.hand = hand
		exchange_action.player= who
		exchange_action.weapon = self
	if ! exchange_action.is_performable():
		return
	who.no_direction.append("attack")
	who.no_roll.append("attack")
	who.no_attack.append("attack")
	who.no_bend.append("attack")
	who.no_shake.append("attack")
	exchange_action.perform()
	
