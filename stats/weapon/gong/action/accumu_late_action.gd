extends WeaponAction

@export var arrowScene : PackedScene
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
const WEAPON_TEMPLATES = preload("res://scene/weapon/weapon_templates.tscn")

var is_drawing := false
var dir
var token:Weapon
var tween:Tween
var hand_string_start:Vector2
#设置参数
var shake_range :=0.25
var ori_speed :=600


func perform(direction:bool)->void:
	if !weapon:
		return
	tween = create_tween().parallel()
	var hand_string = player_hand.hand_left #if direction else player_hand.hand_right
	hand_string_start = hand_string.position
	dir = direction
	#改变Player的参数
	player.SPEED *= 0.5
	player.JUMP_VELOCITY *= 0.8
	player.is_action = true
	weapon.icon.visible = false
	animated_sprite_2d.visible = true
	is_drawing = true
	#添加动画和弓箭节点
	self.remove_child(animated_sprite_2d)
	weapon.add_child(animated_sprite_2d)
	var new_token = WEAPON_TEMPLATES.instantiate()
	new_token.set_stats(weapon_token)
	token = new_token
	weapon.add_child(new_token)
	#hand补间动画
	tween.tween_property(hand_string,"position",hand_string_start+Vector2(1.5,0),0.01).set_ease(Tween.EASE_OUT)
	tween.tween_property(hand_string,"flip_h",true,0.03)
	animated_sprite_2d.position = weapon.stats.init_offset- Vector2(3.5,0)
	animated_sprite_2d.play()
	tween.tween_property(token,"position",weapon_token.init_offset-Vector2(2.5,0),0.2)
	tween.tween_property(hand_string,"position",hand_string_start-Vector2(1.5,0),0.2)
	#抖动效果
	var start := weapon.position
	var n :=0
	while is_drawing and n <1000:
		tween.tween_property(weapon,"position",weapon.position+Vector2(randfn(0,shake_range),randfn(0,shake_range)),0.1)
		n+=1
		if n%5 ==0:
			tween.tween_property(weapon,"position",start,0.1)


func have_release()->bool:
	return true

func release(_direction)->void:
	if tween:
		tween.kill()
	if token:
		token.free()
	player.SPEED = player.char_stats.speed
	player.JUMP_VELOCITY = player.char_stats.jump_speed
	var arrow = arrowScene.instantiate()
	add_child(arrow)
	arrow.shot(player_hand.global_position, dir, weapon.stats.attack, 1)
	animated_sprite_2d.speed_scale = 2.0
	animated_sprite_2d.play_backwards("draw")
	tween = create_tween()
	tween.tween_property(player_hand.hand_left,"position",hand_string_start,0.01).set_ease(Tween.EASE_OUT)
	await animated_sprite_2d.animation_finished
	weapon.remove_child(animated_sprite_2d)
	self.add_child(animated_sprite_2d)
	
	is_drawing = false
	weapon.icon.visible = true
	animated_sprite_2d.visible = false
	player.is_action = false
	player.not_attack = true
	await get_tree().create_timer(0.5).timeout
	player.not_attack = false
	
