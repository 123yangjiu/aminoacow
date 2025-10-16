class_name WeaponPack
extends Node2D

enum TWEEN_TYPE{
	pack_to_idle
}

#idle
@export var qiang:NewWeaponStatus
@export var jian:NewWeaponStatus
@export var gong:NewWeaponStatus
var qinag_pack
var jian_pack
var gong_pack


@onready var up_weapon: Sprite2D = $UpWeapon
@onready var down_weapon: Sprite2D = $DownWeapon
@onready var else_weapon: Sprite2D = $ElseWeapon

var up_weapon_status:NewWeaponStatus
var down_weapon_status:NewWeaponStatus

func add_up_weapon(which:NewWeaponStatus)->void:
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

func add_down_weapon(which:NewWeaponStatus)->void:
	down_weapon.texture=which.texture
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

func erase_weapon()->void:
	pass

func to_idle(who:NewPlayer)->void:
	else_weapon.visible = true
	if ! up_weapon and ! down_weapon:
			down_weapon.texture = qiang.texture
			down_weapon.position = qiang.pack_idle_position
			down_weapon.rotation_degrees = qiang.pack_idle_rotation
			down_weapon.scale = qiang.pack_idle_scale

			up_weapon.texture = jian.texture
			up_weapon.position = jian.pack_idle_position
			up_weapon.rotation_degrees = jian.pack_idle_rotation
			up_weapon.scale = jian.pack_idle_scale

			else_weapon.texture = gong.texture
			else_weapon.position = gong.pack_idle_position
			else_weapon.rotation_degrees = gong.pack_idle_rotation
			else_weapon.scale = gong.pack_idle_scale
	else:
		var tween = create_tween().bind_node(who)
		who.tween_commend.add_tween(tween,"pack_to_idle")
