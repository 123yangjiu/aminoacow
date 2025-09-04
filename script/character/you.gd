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
var is_action:bool=false
var acceleration:int = 600
var friction:int = 1000

func _ready() -> void:
	sprite_2d.texture = art
	char_stats.health = char_stats.max_health
	char_stats.image_changed.connect(image_change)
	if init_weapon:
		hand.add_weapon(init_weapon)
	#test
	await get_tree().create_timer(1).timeout

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		sprite_2d.flip_h = true
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	if Input.is_action_just_pressed("attack") and ! is_action:
		current_weapon.attack()


func node_flip_h()->void:
	
	pass

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
