extends WeaponAction
@export var arrowScene : PackedScene

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
const WEAPON_TEMPLATES = preload("res://scene/weapon/weapon_templates.tscn")
var is_drawing := false

func perform(direction:bool)->void:
	if !weapon:
		return
	var start = player_hand.position
	var tween = create_tween().parallel()
	var dir = 1 if direction else -1
	var hand_string = player_hand.hand_left #if direction else player_hand.hand_right
	var hand_string_start = hand_string.position
	player.SPEED *= 0.5
	player.JUMP_VELOCITY *= 0.8
	player.is_action = true
	weapon.icon.visible = false
	animated_sprite_2d.visible = true
	is_drawing = true
	
	self.remove_child(animated_sprite_2d)
	weapon.add_child(animated_sprite_2d)
	var arrow = WEAPON_TEMPLATES.instantiate()
	weapon.add_child(arrow)
	
	
	tween.tween_property(hand_string,"position",hand_string_start+Vector2(2,0),0.05).set_ease(Tween.EASE_OUT)
	tween.tween_property(hand_string,"flip_h",true,0.03)
	animated_sprite_2d.position -= Vector2(1.5,0)
	arrow.position = Vector2(2.0,0)
	animated_sprite_2d.play()
	tween.tween_property(hand_string,"position",hand_string_start-Vector2(0.5,0),0.5)
	tween.tween_property(arrow,"position",Vector2(2.0,0)- Vector2(2.5,0),0.5)

func _process(delta: float) -> void:
	if Input.is_action_just_released("attack") and is_drawing:
		pass
		
	
	
