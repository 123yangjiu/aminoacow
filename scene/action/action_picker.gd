class_name WeaponActionPicker
extends Node

var all_action:Array[Node]
var weapon:Weapon
var player_hand:Node2D

func initial(new_weapon:Weapon)->void:
	if ! is_inside_tree():
		await ready
	weapon = new_weapon
	var new_player=get_tree().get_first_node_in_group("Player")
	player_hand = new_player.hand
	for child:Node in get_children():
		all_action.append(child)
		child.weapon = weapon
		child.player_hand = player_hand

func get_action()->WeaponAction:
	return get_child(0)

	
