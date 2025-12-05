class_name WeaponAnchor
extends Node2D



func _reparent(which_node:NewWeapon)->void:
	which_node.reparent(self)
	pass
