class_name XAction
extends ICommand

var _weapon:Weapon

func _init(weappon:Weapon) -> void:
	_weapon=weappon

func execute()->void:
	_weapon.x_action()
	print("XAction执行完毕")

func undo()->void:
	pass
