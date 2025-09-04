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
@export var init_weapon:WeaponStats
@onready var current_weapon: Weapon
#node-related
	#shader
var flip_material:ShaderMaterial
var flip_target:bool = true
var flip_animation_speed:float = 5.0
var current_progress:float=0.0: set= set_current_progress
	#action
var is_action:bool=false
var direction_bool:bool = true :set = set_direction
var acceleration:int = 600
var friction:int = 1000






func _ready() -> void:
	#初始化Stats
	sprite_2d.texture = art
	char_stats.health = char_stats.max_health
	char_stats.image_changed.connect(image_change)
	if init_weapon:
		hand.add_weapon(init_weapon)
	#设置Shader
	flip_material = ShaderMaterial.new()
	flip_material.shader = preload("res://resource/shader/flip_shader.gdshader")
	material = flip_material
	#test
	await get_tree().create_timer(1).timeout

func _physics_process(delta: float) -> void:
	#move-related
	add_gravity(delta)
	
	jump()

	smooth_move()

	move_and_slide()
	#other_input-related
	attack()


func set_direction(value)->void:
	#if value != direction_bool:
		#node_flip_h(value)
	direction_bool = value

func node_flip_h(new_direction:bool)->void:
	if ! flip_material:
		return
	var target_progress = 0.0 if new_direction else 1.0
	var new_progress = lerp(current_progress,target_progress,flip_animation_speed*1/60)
	print(new_progress)
	flip_material.set_shader_parameter("flip_progress",new_progress)
	print(flip_material.get_shader_parameter("flip_progress"))

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
func smooth_move()->void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = move_toward(velocity.x,direction * SPEED,acceleration)
		if direction>0:
			direction_bool = true
		else:
			direction_bool = false
	else:
		velocity.x = move_toward(velocity.x, 0, friction)

func attack()->void:
	if Input.is_action_just_pressed("attack") and ! is_action:
		current_weapon.attack()

func set_current_progress(value)->void:
	current_progress = clampf(value,0.0,1.0)

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
