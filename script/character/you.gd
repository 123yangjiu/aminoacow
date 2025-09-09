class_name Player
extends CharacterBody2D

@export var char_stats:CharacterStats

#node-related
@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var hand: Hand = %Hand
@onready var camera_2d: Camera2D = $Camera2D
@onready var ancher: Node2D = $Ancher

const WEAPON_CONTAINER = preload("res://scene/weapon/weapon_container.tscn")
var weapon_container:WeaponContainer
const EXCHANGE_WEAPON_EFFECT = preload("res://scene/effect/exchange_weapon_effect.tscn")
@export var exchange_weapon_effect:ExchangeWeaponEffect

#char_stats_variable-related
@onready var art:Texture2D = char_stats.art
@onready var hand_art:Texture2D = hand.get_child(0).texture
@onready var init_image:Image = art.get_image()
@onready var hand_init_image:Image = hand_art.get_image()
@onready var SPEED = char_stats.speed
@onready var JUMP_VELOCITY:float = char_stats.jump_speed
@export var weapon_pack:Array[WeaponStats]
@export var init_weapon:WeaponStats
@onready var current_weapon: Weapon

#self-related
	#action
var direction_bool:bool=true :set = set_direction
var acceleration:int = 600
var friction:int = 1000
	#is_doing
var is_action:bool=false
var is_flip:bool = false
var is_roll:bool = false
var is_exchange:bool = false
var not_exchange := false
var is_up_down_pressed

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
	exchange_weapon(direction_bool)

#set_stats-related
func set_direction(value)->void:
	if value != direction_bool and ! is_action:
		is_flip = true
		flip_hand(value)
		if weapon_container:
			weapon_container.flip_self()
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
		ancher.rotation_degrees = lerp(ancher.rotation_degrees,direction*8,0.1)
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
func exchange_weapon(bool_direction)->void:
	if not_exchange:
		return
	if Input.is_action_pressed("exchange_weapon") or is_exchange and weapon_container:
		var dir := 1 if bool_direction else -1
		#添加weapon_container和effect
		if !weapon_container:
			weapon_container = WEAPON_CONTAINER.instantiate()
			add_child(weapon_container)
			weapon_container.position = Vector2(14,0) * dir
		if !exchange_weapon_effect:
			exchange_weapon_effect = EXCHANGE_WEAPON_EFFECT.instantiate()
			camera_2d.add_child(exchange_weapon_effect)
		#现身
		is_exchange = true
		var tween:=create_tween().set_trans(Tween.TRANS_EXPO)
		weapon_container.update(weapon_pack[0].icon,weapon_pack[1].icon)
		tween.tween_property(weapon_container,"modulate",Color(1,1,1,1),0.01)
		tween.parallel().tween_property(exchange_weapon_effect,"color",Color(0.1,0.1,0.1,0.7),0.01)
		Engine.time_scale = 0.2  
		var later_weapon = current_weapon
		var up_down_index = null
		match is_up_down_pressed:
			null:
				if Input.is_action_pressed("ui_down"):
					weapon_container.add_shader(false)
					is_up_down_pressed = "down"
				elif Input.is_action_pressed("ui_up"):
					weapon_container.add_shader(true)
					is_up_down_pressed = "up"
			"down":
				if Input.is_action_pressed("ui_up"):
					weapon_container.add_shader(true)
					is_up_down_pressed = "upup"
			"up":
				if Input.is_action_pressed("ui_down"):
					weapon_container.add_shader(false)
					is_up_down_pressed = "downdown"
		if Input.is_action_just_released("ui_up") or Input.is_action_just_released("ui_down"):
			up_down_index = -1
			match is_up_down_pressed:
				"down","downdown":
					up_down_index = 1
				"up","upup":
					up_down_index = 0
		
		if up_down_index != null:
			current_weapon.queue_free()
			hand.add_weapon(weapon_pack[up_down_index])
			weapon_pack[up_down_index] = later_weapon.stats
			#tween.tween_property(weapon_container,"modulate",Color(1,1,1,0),0.03)
			exchange_over()
			not_exchange = true
			await get_tree().create_timer(2).timeout
			not_exchange = false
			
		if Input.is_action_just_released("exchange_weapon"):
			tween.tween_property(weapon_container,"modulate",Color(1,1,1,0),0.03)
			await tween.finished
			exchange_over()

func exchange_over()->void:
	weapon_container.queue_free()
	exchange_weapon_effect.queue_free()
	Engine.time_scale = 1.0
	is_exchange = false
	is_up_down_pressed = null
	weapon_container.delete_shader()

func image_change()->void:
	var image:Image = art.get_image()
	var hand_image:Image = hand_art.get_image()
	var height = image.get_height()
	var width = image.get_width()
	#health_mode作为指标
	var n = char_stats.health_mode * height
	for y in range(ceil(n)):
		for x in range(width):
			var ori_color:Color = image.get_pixel(x,y)
			var ori_hand_color := hand_image.get_pixel(x,y)
			if ori_color == Color.WHITE:
				image.set_pixel(x,y,Color.BLACK)
			elif ori_color == Color.BLACK:
				image.set_pixel(x,y,Color.WHITE)
			if ori_hand_color == Color.WHITE:
				hand_image.set_pixel(x,y,Color.BLACK)
			elif ori_hand_color == Color.BLACK:
				hand_image.set_pixel(x,y,Color.WHITE)
	sprite_2d.texture = ImageTexture.create_from_image(image)
