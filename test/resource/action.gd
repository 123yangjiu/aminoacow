class_name PlayerAction
extends Node

var hand:Node2D
var player:NewPlayer
var weapon:NewWeapon

func is_performable()->bool:
	return false

func perform()->void:
	pass

func interval_restatus()->void:
	weapon.monitoring = false
	player.no_direction.erase("attack")
	player.no_roll.erase("attack")
	player.no_attack.erase("attack")
	player.no_down_tween.erase("attack")

func after_interval_restatus()->void:
	player.no_bend.erase("attack")
	player.no_shake.erase("attack")
	#weapon.audio_stream_player_2d.stop()
