class_name ActionPicker
extends Node

#action_type
@onready var normal_action: Node = $NormalAction
@onready var exchange_action: Node = $ExchangeAction



func get_normal_action(weapon:NewWeaponStatus)->PlayerAction:
	var ready_action:PlayerAction
	for action:PlayerAction in normal_action.get_children():
		if action._owner_weapon == weapon:
			ready_action = action
	return ready_action
