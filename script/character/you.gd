class_name Player
extends CharacterBody2D

@export var char_stats:CharacterStats

#node-related
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hand: Hand = %Hand

#char_stats_variable-related
@onready var art:Texture2D = char_stats.art
@onready var init_image:Image = art.get_image()
@onready var SPEED = char_stats.speed
@onready var JUMP_VELOCITY:float = char_stats.jump_speed
@export var weapon_pack:Array[WeaponStats]
@export var init_weapon:WeaponStats
@onready var current_weapon: Weapon
#node-related
	#action
var direction_bool:bool=true :set = set_direction
var acceleration:int = 600
var friction:int = 1000
	#is_doing
var is_action:bool=false
var is_flip:bool = false
var is_roll:bool = false

func _ready() -> void:
	#初始化Stats
	sprite_2d.texture = art
	char_stats.health = char_stats.max_health
	char_stats.image_changed.connect(image_change)
	if init_weapon:
		hand.add_weapon(init_weapon)
		weapon_pack.erase(init_weapon)
	#test
	await get_tree().create_timer(1).timeout

func _physics_process(delta: float) -> void:
	#move-related
	add_gravity(delta)
	var direction := Input.get_axis("ui_left", "ui_right")
	jump()
	smooth_move(direction)
	roll(direction_bool)
	
	move_and_slide()
	#other_input-related
	attack(direction_bool)
	exchange_weapon()

#set_stats-related
func set_direction(value)->void:
	if value != direction_bool and ! is_action:
		is_flip = true
		flip_hand(value)
	direction_bool = value


#physice-related
func add_gravity(delta)->void:
	if not is_on_floor():
		velocity += get_gravity() * delta
func jump()->void:
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
	else:
		if Input.is_action_just_released("jump") and velocity.y <JUMP_VELOCITY/2:
			velocity.y *= 0.5
func smooth_move(direction)->void:
	if is_roll:
		return
	if direction:
		velocity.x = move_toward(velocity.x,direction * SPEED,acceleration)
		if is_action:
			return
		if direction>0:
			direction_bool = true
		else:
			direction_bool = false
	else:
		velocity.x = move_toward(velocity.x, 0, friction)
func flip_hand(direction)->void:
	var tween = create_tween()
	if ! direction:
		tween.tween_property(hand,"position",Vector2(1.5,0),0.1)
		tween.parallel().tween_property(hand,"scale",Vector2(-1,1),0.1)
		#tween.tween_property(hand,"rotation_degrees",-180,0.1)
	else:
		tween.tween_property(hand,"position",Vector2(2.5,0),0.1)
		tween.parallel().tween_property(hand,"scale",Vector2(1,1),0.1)
	await tween.finished
	is_flip = false
	#tween.parallel().tween_property(current_weapon,"rotation_degrees",180,0.1)
	#tween.tween_property(hand,"rotation_degrees",0,0.1)
func attack(bool_direction)->void:
	if Input.is_action_just_pressed("attack") and ! is_action and ! is_flip and ! is_roll:
		current_weapon.attack(bool_direction)
func roll(bool_direction)->void:
	if Input.is_action_just_pressed("roll") and ! is_action and !is_roll:
		is_roll = true
		var dir := 1 if bool_direction else -1
		var tween := create_tween().set_trans(Tween.TRANS_EXPO).set_parallel()
		tween.tween_property(self,"velocity",Vector2(dir*SPEED*char_stats.roll_factor,velocity.y),0.1)
		tween.set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(self,"rotation_degrees",360*dir,0.2)
		await tween.finished
		is_roll = false

#other_node-related
func exchange_weapon()->void:
	if Input.is_action_pressed("exchange_weapon"):
		print("space")
		if Input.is_action_just_released("ui_up"):
			current_weapon.queue_free()
			hand.add_weapon(weapon_pack[0])
			weapon_pack[0] =current_weapon.stats
			print(weapon_pack)
		elif	 Input.is_action_just_released("ui_down"):
			current_weapon.queue_free()
			hand.add_weapon(weapon_pack[-1])
			weapon_pack[-1] =current_weapon.stats


func image_change()->void:
	var image:Image = art.get_image()
	var height = image.get_height()
	var width = image.get_width()
	#health_mode作为指标
	var n = char_stats.health_mode * height
	for y in range(ceil(n)):
		for x in range(width):
			var ori_color:Color = image.get_pixel(x,y)
			if ori_color == Color.WHITE:
					image.set_pixel(x,y,Color.BLACK)
			if ori_color == Color.BLACK:
				image.set_pixel(x,y,Color.WHITE)
	sprite_2d.texture = ImageTexture.create_from_image(image)
