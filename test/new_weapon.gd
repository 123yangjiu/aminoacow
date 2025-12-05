class_name NewWeapon
extends Area2D

#status
@export var status:NewWeaponStatus

#node
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var normal_action:PlayerAction
var exchange_action_up:PlayerAction
var exchange_action_down:PlayerAction
var idle_action:PlayerAction

#weapon_pack情况
var up_weapon:NewWeaponStatus
var down_weapon:NewWeaponStatus
var else_weapon:NewWeaponStatus


var qiang_pack:NewWeaponStatus.TYPE_PLACE
var jian_pack:NewWeaponStatus.TYPE_PLACE
var gong_pack:NewWeaponStatus.TYPE_PLACE

func _ready():
	#连接信号
	if !SignalEvents.idled.is_connected(on_idled):
		SignalEvents.idled.connect(on_idled)
	if !SignalEvents.cancel_idle.is_connected(on_cancel_idle):
		SignalEvents.cancel_idle.connect(on_cancel_idle)
	#初始化action
	if status.normal_action:
		normal_action = status.normal_action.instantiate()
	if status.exchange_action_up:
		exchange_action_up = status.exchange_action_up.instantiate()
	if status.exchange_action_down:
		exchange_action_down = status.exchange_action_down.instantiate()
	if status.idle_action:
		idle_action = status.idle_action.instantiate()

func _init_status(where:NewWeaponStatus.TYPE_PLACE,parent:Node)->void:
	self.visible=true
	self.self_modulate =Color(1.0, 1.0, 1.0, 0.784)
	self.reparent(parent)
	collision_shape_2d.disabled = true
	match where:
		NewWeaponStatus.TYPE_PLACE._idle:
			status.place=NewWeaponStatus.TYPE_PLACE._idle
			position =status.pack_idle_position
			rotation_degrees = status.pack_idle_rotation
			scale = status.pack_idle_scale
		NewWeaponStatus.TYPE_PLACE._hand:
			self.self_modulate =Color(1.0, 1.0, 1.0, 1.0)
			status.place=NewWeaponStatus.TYPE_PLACE._hand
			self.position=status.init_offset
		NewWeaponStatus.TYPE_PLACE._up:
			status.place=NewWeaponStatus.TYPE_PLACE._up
			self.position=status.pack_up_position
			self.rotation_degrees= status.pack_up_rotation
			self.scale = status.pack_up_scale
		NewWeaponStatus.TYPE_PLACE._down:
			status.place=NewWeaponStatus.TYPE_PLACE._down
			self.position=status.pack_down_position
			self.rotation_degrees= status.pack_down_rotation
			self.scale = status.pack_down_scale

func play_normal(who:NewPlayer)->void:
	if ! normal_action:
		return
	if normal_action.hand ==null:
		normal_action.hand = who.hand_anchor
		normal_action.player = who
		normal_action.weapon = self
	if ! normal_action.is_performable():
		return
	#idle时间
	var type = normal_action.normal_attack
	if who.is_idle:
		on_cancel_idle(who)
	who.tween_commend.erase_tween(who.t_free_fall)
	who.tween_commend.erase_tween(who.t_jump_fall)
	who.tween_commend.erase_tween(who.t_land_quick)
	who.tween_commend.erase_tween(who.t_land_slow)
	#攻击时不能干什么
	who.no_direction.append(type)
	who.no_roll.append(type)
	who.no_attack.append(type)
	who.no_bend.append(type)
	who.no_shake.append(type)
	who.no_down_tween.append(type)
	who.no_idle.append(type)
	who.no_exchange.append(type)
	who.scale = Vector2(1.0,1.0)
	audio_stream_player_2d.stream = status.normal_aiction_audio
	audio_stream_player_2d.play()
	normal_action.perform()

func play_exchange(who:NewPlayer,where:NewWeaponStatus.TYPE_PLACE)->void: 
	#找武器，切武器
	match where:
		NewWeaponStatus.TYPE_PLACE._up:
			if ! exchange_action_up:
				return
			if exchange_action_up.hand ==null:
				exchange_action_up.hand = who.hand_anchor
				exchange_action_up.player= who
				exchange_action_up.weapon = self
			if ! exchange_action_up.is_performable():
				return
		NewWeaponStatus.TYPE_PLACE._down:
			if ! exchange_action_down:
				return
			if exchange_action_down.hand ==null:
				exchange_action_down.hand = who.hand_anchor
				exchange_action_down.player= who
				exchange_action_down.weapon = self
			if ! exchange_action_down.is_performable():
				return
	#正常流程
	if who.is_idle:
		on_cancel_idle(who)
	var type = exchange_action_up.exchange_attack
	who.tween_commend.erase_tween(who.t_free_fall)
	who.tween_commend.erase_tween(who.t_jump_fall)
	who.tween_commend.erase_tween(who.t_land_quick)
	who.tween_commend.erase_tween(who.t_land_slow)
	who.no_direction.append(type)
	who.no_roll.append(type)
	who.no_attack.append(type)
	who.no_bend.append(type)
	who.no_shake.append(type)
	who.no_down_tween.append(type)
	who.no_idle.append(type)
	who.no_exchange.append(type)
	who.scale = Vector2(1.0,1.0)
	#武器执行攻击
	audio_stream_player_2d.stream = status.exchange_aiction_audio
	audio_stream_player_2d.play()
	match where:
		NewWeaponStatus.TYPE_PLACE._up:
			exchange_action_up.perform()
		NewWeaponStatus.TYPE_PLACE._down:
			exchange_action_down.perform()

func on_idled(who:NewPlayer)->void:
	if status.place!= NewWeaponStatus.TYPE_PLACE._hand:
		return
	if ! idle_action:
		return
	if idle_action.hand ==null:
		idle_action.hand = who.hand_anchor
		idle_action.player = who
		idle_action.weapon = self
		idle_action.type = "weapon_idle"
	if ! idle_action.is_performable():
		return
	var type =idle_action.idle
	who.no_idle.append(type)
	who.current_time =0
	who.is_idle = true
	#if qiang:
		#who.no_idle.erase(type)
	idle_action.perform()

func on_cancel_idle(who:NewPlayer)->void:
	var type =idle_action.idle
	who.no_idle.erase(type)
	who.is_idle = false
	who.tween_commend.erase_tween(type)
	who.current_time=0
	self.position= status.init_offset
	who.hand_anchor.position = Vector2(2+who.direction/2,0)
	self.rotation_degrees=0
	self.scale=Vector2(1.0,1.0)
#差异化
func qiang_jumpidle(who:NewPlayer)->void:
	if status.name != status.TYPE_NAME.QIANG:
		return
	var tween = create_tween().bind_node(who)
	who.tween_commend.add_tween(tween,"qiang_jumpidle")
	var n=0
	for i in range(4):
		if self.rotation_degrees <-360*i:
			n-=360
		else:
			break
	var time = -(n-rotation_degrees)/900
	var type =idle_action.idle
	if who.tween_commend.get_tween(type):
		who.tween_commend.erase_tween(type)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"position",status.init_offset,time)
	tween.parallel().tween_property(who.hand_anchor,"position:y",0,time)
	#tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.parallel().tween_property(self,"rotation_degrees",n,time)
	await tween.finished
	on_cancel_idle(who)
