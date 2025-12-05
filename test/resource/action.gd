class_name PlayerAction
extends Node

#no_指示物 & action的tween名字
const normal_attack = "normal_attack"
const exchange_attack = "exchange_attack"
const idle ="idle"

var hand:HandAnchor
var player:NewPlayer
var weapon:NewWeapon
var type:String


func is_performable()->bool:
	return false

func perform()->void:
	pass

func interval_restatus()->void:
	weapon.monitoring = false
	player.no_direction.erase(type)
	player.no_roll.erase(type)

	player.no_down_tween.erase(type)
	player.no_idle.erase(type)

func after_interval_restatus()->void:
	player.no_bend.erase(type)
	player.no_shake.erase(type)
	player.no_attack.erase(type)
	player.no_exchange.erase(type)
	#weapon.audio_stream_player_2d.stop()
