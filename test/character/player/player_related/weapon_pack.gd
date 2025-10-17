class_name WeaponPack
extends Node2D

#idle

var qinag_pack
var jian_pack
var gong_pack

@onready var up_weapon: Sprite2D = $UpWeapon
@onready var down_weapon: Sprite2D = $DownWeapon
@onready var else_weapon: Sprite2D = $ElseWeapon

#var up_weapon_status:NewWeaponStatus
#var down_weapon_status:NewWeaponStatus

func _ready() -> void:
	if ! SignalEvents.weapon_exchange_up.is_connected(exchange_up_weapon):
		SignalEvents.weapon_exchange_up.connect(exchange_up_weapon)
	if ! SignalEvents.weapon_exchange_down.is_connected(exchange_down_weapon):
		SignalEvents.weapon_exchange_down.connect(exchange_down_weapon)
	

func exchange_up_weapon(which:NewWeaponStatus)->void:
	up_weapon.texture=which.texture
	up_weapon.position = which.pack_idle_position
	up_weapon.rotation_degrees = which.pack_idle_rotation
	up_weapon.scale = which.pack_idle_scale
	if which.name == which.TYPE.QIANG:
		qinag_pack = up_weapon
	elif which.name == which.TYPE.JIAN:
		jian_pack = up_weapon
	elif which.name == which.TYPE.GONG:
		gong_pack = up_weapon

func exchange_down_weapon(which:NewWeaponStatus)->void:
	down_weapon.texture=which.texture
	down_weapon.position = which.pack_idle_position
	down_weapon.rotation_degrees = which.pack_idle_rotation
	down_weapon.scale = which.pack_idle_scale
	if which.name == which.TYPE.QIANG:
		qinag_pack = down_weapon
	elif which.name == which.TYPE.JIAN:
		jian_pack = down_weapon
	elif which.name == which.TYPE.GONG:
		gong_pack = down_weapon

func to_idle(who:NewPlayer,all_status:Array[NewWeaponStatus])->void:
	else_weapon.visible = true
	if ! up_weapon and ! down_weapon:
		for weapon in all_status:
			if weapon.name == weapon.TYPE.QIANG:
				down_weapon.texture = weapon.texture
				down_weapon.position = weapon.pack_idle_position
				down_weapon.rotation_degrees = weapon.pack_idle_rotation
				down_weapon.scale = weapon.pack_idle_scale
			elif  weapon.name == weapon.TYPE.JIAN:
				up_weapon.texture = weapon.texture
				up_weapon.position = weapon.pack_idle_position
				up_weapon.rotation_degrees = weapon.pack_idle_rotation
				up_weapon.scale = weapon.pack_idle_scale
			elif weapon.name == weapon.TYPE.GONG:
				else_weapon.texture = weapon.texture
				else_weapon.position = weapon.pack_idle_position
				else_weapon.rotation_degrees = weapon.pack_idle_rotation
				else_weapon.scale = weapon.pack_idle_scale
	#else:
		#var tween = create_tween().bind_node(who)
		#who.tween_commend.add_tween(tween,"pack_to_idle")
