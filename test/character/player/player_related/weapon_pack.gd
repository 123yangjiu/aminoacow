class_name WeaponPack
extends Node2D

var up_weapon:NewWeaponStatus
var down_weapon:NewWeaponStatus


func add_up_weapon(which:NewWeaponStatus)->void:
	up_weapon=which
	
	pass

func add_down_weapon(which:NewWeaponStatus)->void:
	down_weapon=which
	pass
