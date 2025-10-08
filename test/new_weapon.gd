#tool
class_name NewWeapon
extends Area2D

#status
@export var current_status:NewWeaponStatus
@export var all_status:Array[NewWeaponStatus]
@export var hand:Node

#node
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var left_hand: Sprite2D = $"../LeftHand"
@onready var right_hand: Sprite2D = $"../RightHand"
var normal_action:PlayerAction
var exchange_action:PlayerAction
var idle_action:PlayerAction

func _init_status(which:NewWeaponStatus) -> void:
	current_status = which
	sprite_2d.texture = which.texture
	sprite_2d.position = which.sprite_offset
	self.position = which.init_offset
	collision_shape_2d.shape = which.attackshape
	collision_shape_2d.disabled = true
	collision_shape_2d.position = which.attackshape_offset + which.sprite_offset
	normal_action = null
	exchange_action = null
	audio_stream_player_2d.stream = current_status.normal_aiction_audio
	#hand_status
	left_hand.flip_h = which.if_left_hand_flip
	left_hand.position = which.left_hand_offset
	right_hand.flip_h = which.if_right_hand_flip
	right_hand.position = which.right_hand_offset
	if which.normal_action:
		normal_action = which.normal_action.instantiate()
	if which.exchange_action:
		exchange_action = which.exchange_action.instantiate()
	if which.idle_action:
		idle_action = which.idle_action.instantiate()

func play_normal(who:NewPlayer)->void:
	if ! normal_action:
		return
	if normal_action.hand ==null:
		normal_action.hand = hand
		normal_action.player = who
		normal_action.weapon = self
	if ! normal_action.is_performable():
		return
	#idle时间
	who.current_time =0
	on_cancel_idle(who)
	who.tween_commend.erase_tween("land_slow")
	who.tween_commend.erase_tween("land_quick")
	who.no_direction.append("attack")
	who.no_roll.append("attack")
	who.no_attack.append("attack")
	who.no_bend.append("attack")
	who.no_shake.append("attack")
	who.no_down_tween.append("attack")
	who.scale = Vector2(1.0,1.0)
	audio_stream_player_2d.play()
	normal_action.perform()

func play_exchange(who:NewPlayer)->void:
	print("ACTION")
	if exchange_action.hand ==null:
		exchange_action.hand = hand
		exchange_action.player= who
		exchange_action.weapon = self
	if ! exchange_action.is_performable():
		return
	who.current_time =0
	on_cancel_idle(who)
	who.tween_commend.erase_tween("land_slow")
	who.tween_commend.erase_tween("land_quick")
	who.no_direction.append("attack")
	who.no_roll.append("attack")
	who.no_attack.append("attack")
	who.no_bend.append("attack")
	who.no_shake.append("attack")
	who.scale = Vector2(1.0,1.0)
	audio_stream_player_2d.play()
	exchange_action.perform()

func on_idled(who:NewPlayer)->void:
	if ! idle_action:
		return
	if idle_action.hand ==null:
		idle_action.hand = hand
		idle_action.player = who
		idle_action.weapon = self
	if ! idle_action.is_performable():
		return
	who.no_idle.append("idle")
	idle_action.perform()

func on_cancel_idle(who:NewPlayer)->void:
	who.no_idle.erase("weapon_idle")
	self.position = current_status.init_offset
	self.rotation_degrees =0
	self.scale = Vector2(1.0,1.0)
