class_name PlayerAction
extends Node

var hand:Node2D
var player:NewPlayer
var weapon:NewWeapon

func is_performable()->bool:
	return false

func perform()->void:
	pass
