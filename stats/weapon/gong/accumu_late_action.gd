extends WeaponAction
@export var arrowScene : PackedScene


func perform(direction:bool)->void:
	if !weapon:
		return
	var start = player_hand.position
	var tween = create_tween()
	var dir = 1 if direction else -1
	
