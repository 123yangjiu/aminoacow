extends WeaponAction
@export var arrowScene : PackedScene

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func perform(direction:bool)->void:
	if !weapon:
		return
	var start = player_hand.position
	var tween = create_tween().parallel()
	var dir = 1 if direction else -1
	var hand_string = player_hand.hand_left #if direction else player_hand.hand_right
	var hand_string_start = hand_string.position
	player.SPEED *= 0.5
	player.is_action = true
	tween.tween_property(hand_string,"position",hand_string_start+Vector2(2,0),0.05).set_ease(Tween.EASE_OUT)
	tween.tween_property(hand_string,"flip_h",true,0.03)
	self.remove_child(animated_sprite_2d)
	weapon.add_child(animated_sprite_2d)
	animated_sprite_2d.position -= Vector2(1.5,0) 
	weapon.icon.visible = false
	animated_sprite_2d.visible = true
	animated_sprite_2d.play()
	tween.tween_property(hand_string,"position",hand_string_start-Vector2(0.5,0),0.5)
	
	
	
