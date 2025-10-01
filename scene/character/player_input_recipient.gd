class_name PlayerInputRecipient
extends Node

@onready var player = get_parent()



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		var attack_command = XAction.new(player.current_weapon)
		attack_command.execute()

	print("PlayerInputRecipient::_input")
