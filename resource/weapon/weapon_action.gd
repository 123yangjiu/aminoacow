class_name WeaponAction
extends Node

var sound:AudioStream

var weapon:Weapon
var player:Player
var player_hand:Hand
@export var weapon_token:WeaponToken

@warning_ignore("unused_parameter")
func perform(direction)->void:
	pass

func have_release():
	return false
@warning_ignore("unused_parameter")
func release(direction_bool)->void:
	pass
