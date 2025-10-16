#tool
class_name NewWeapon
extends Area2D

#status
@export var current_status:NewWeaponStatus
@export var all_status:Array[NewWeaponStatus]
signal weapon_exchange_up(which:NewWeaponStatus)
signal weapon_exchange_down(which:NewWeaponStatus)

var	weapon_up_else:NewWeaponStatus
var	weapon_down_else:NewWeaponStatus

@onready var hand: Node2D = $".."

#node
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var left_hand: Sprite2D = $"../LeftHand"
@onready var right_hand: Sprite2D = $"../RightHand"
var normal_action:PlayerAction
var exchange_action:PlayerAction
var idle_action:PlayerAction
#差异化
var qiang:=false
var jian:=false
var gong:=false



func _init_status(which:NewWeaponStatus) -> void:
	#重置属性
	qiang = false
	gong = false
	jian = false
	normal_action = null
	exchange_action = null
	#其他武器放置
	for i in all_status:
		if i!=which:
			if !weapon_up_else:
				weapon_up_else= i
				weapon_exchange_up.emit(weapon_up_else)
			else:
				weapon_down_else=i
				weapon_exchange_down.emit(weapon_down_else)
	#节点基本属性
	current_status = which
	sprite_2d.texture = which.texture
	sprite_2d.position = which.sprite_offset
	self.position = which.init_offset
	collision_shape_2d.shape = which.attackshape
	collision_shape_2d.disabled = true
	collision_shape_2d.position = which.attackshape_offset
	#hand属性
	left_hand.flip_h = which.if_left_hand_flip
	left_hand.position = which.left_hand_offset
	right_hand.flip_h = which.if_right_hand_flip
	right_hand.position = which.right_hand_offset
	#action布置
	if which.normal_action:
		normal_action = which.normal_action.instantiate()
	if which.exchange_action:
		exchange_action = which.exchange_action.instantiate()
	if which.idle_action:
		idle_action = which.idle_action.instantiate()
	#确认武器类别
	if current_status.name == current_status.TYPE.JIAN:
		jian = true
	if current_status.name == current_status.TYPE.QIANG:
		qiang = true
	if current_status.name == current_status.TYPE.GONG:
		gong = true

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
	var type = normal_action.normal_attack
	if who.is_idle:
		on_cancel_idle(who)
	who.tween_commend.erase_tween("land_slow")
	who.tween_commend.erase_tween("land_quick")
	#攻击时不能干什么
	who.no_direction.append(type)
	who.no_roll.append(type)
	who.no_attack.append(type)
	who.no_bend.append(type)
	who.no_shake.append(type)
	who.no_down_tween.append(type)
	who.no_idle.append(type)
	who.scale = Vector2(1.0,1.0)
	audio_stream_player_2d.stream = current_status.normal_aiction_audio
	audio_stream_player_2d.play()
	normal_action.perform()

func play_exchange(who:NewPlayer,which:float)->void:
	#找武器,切武器
	var current_index = all_status.find(all_status[current_status.name])
	if current_index==-1:
		return
	var new_index = current_index+which
	if new_index >all_status.size()-1:
		new_index=0
	elif new_index <0:
		new_index=all_status.size()-1
	var new_weapon:NewWeaponStatus =  all_status.get(new_index)
	if which==1:
		weapon_exchange_up.emit(current_status)
	elif which ==-1:
		weapon_exchange_down.emit(current_status)
	if ! new_weapon.exchange_action:
		return
	_init_status(new_weapon)
	#正常流程
	if exchange_action.hand ==null:
		exchange_action.hand = hand
		exchange_action.player= who
		exchange_action.weapon = self
	if ! exchange_action.is_performable():
		return
	if who.is_idle:
		on_cancel_idle(who)
	var type = exchange_action.exchange_attack
	who.tween_commend.erase_tween("land_slow")
	who.tween_commend.erase_tween("land_quick")
	who.no_direction.append(type)
	who.no_roll.append(type)
	who.no_attack.append(type)
	who.no_bend.append(type)
	who.no_shake.append(type)
	who.no_down_tween.append(type)
	who.no_idle.append(type)
	who.scale = Vector2(1.0,1.0)
	#武器执行攻击
	audio_stream_player_2d.stream = current_status.exchange_aiction_audio
	audio_stream_player_2d.play()
	exchange_action.perform()

func on_idled(who:NewPlayer)->void:
	if ! idle_action:
		return
	if idle_action.hand ==null:
		idle_action.hand = hand
		idle_action.player = who
		idle_action.weapon = self
		idle_action.type = "weapon_idle"
	if ! idle_action.is_performable():
		return
	var type =idle_action.idle
	who.no_idle.append(type)
	who.current_time =0
	who.is_idle = true
	if qiang:
		who.no_idle.erase(type)
	idle_action.perform()

func on_cancel_idle(who:NewPlayer)->void:
	var type =idle_action.idle
	who.no_idle.erase(type)
	who.is_idle = false
	who.tween_commend.erase_tween(type)
	who.current_time=0
	#var tween = create_tween().bind_node(who)
	#who.tween_commend.add_tween(tween,"cancel_idle")
	#tween.tween_property(self,"position",current_status.init_offset,0.02)
	#tween.tween_property(hand,"position",Vector2(2+who.direction/2,0),0.02)
	#tween.tween_property(self,"rotation_degrees",0,0.02)
	#tween.tween_property(self,"scale", Vector2(1.0,1.0),0.02)
	self.position= current_status.init_offset
	hand.position = Vector2(2+who.direction/2,0)
	self.rotation_degrees=0
	self.scale=Vector2(1.0,1.0)

func qiang_jumpidle(who:NewPlayer)->void:
	if !qiang:
		return
	var tween = create_tween().bind_node(who)
	who.tween_commend.add_tween(tween,"qiang_jumpidle")
	var n=0
	for i in range(4):
		if self.rotation_degrees >360*i:
			n+=360
		else:
			break
	var time = (n-rotation_degrees)/1800
	var type =idle_action.idle
	if who.tween_commend.get_tween(type):
		who.tween_commend.erase_tween(type)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"position",current_status.init_offset,time)
	tween.parallel().tween_property(hand,"position:y",0,time)
	#tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.parallel().tween_property(self,"rotation_degrees",n,time)
