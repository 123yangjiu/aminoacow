class_name NewPlayer
extends CharacterBody2D

enum TWEEN_TYPE{
	bend,
	bend_back,
	flip,
	roll,
	jump,
	free_fall
}
	


const NEW_WEAPON = preload("uid://4iby6oili3lx")
#all_commend
@onready var health_commend: HealthCommend = $all_commend/health_commend
@onready var tween_commend: TweenCommend = $all_commend/tween_commend


#child_node-related
@onready var anchor: Node2D = $Anchor
@onready var hand_anchor: Node2D = $Anchor/Mainsprite2D/HandAnchor
@onready var camera_2d: Camera2D = $Camera2D
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@export var all_commend:Array[Node]
@onready var mainsprite_2d: Sprite2D = $Anchor/Mainsprite2D
@onready var weapon: NewWeapon = $Anchor/Mainsprite2D/HandAnchor/Weapon

#physice_input-related
var direction := 1.0 :set = set_direction
	#move
var speed_up_speed := 60
var max_speed := 200
var slow_down_speed := 90
var bend_range := 10
	#jump
var _is_on_floor:bool :set = set_on_floor
var jump_speed := -380
var jump_scale := 1.2
var gravity_mag := 1.9
var max_down_speed := 600
var is_down_speed:=false
signal direction_change(direction)
	#roll
var roll_speed := 400
var roll_sd_speed :=100
var roll_interval := 0.3

#other_physics-related
var camera_flip_offest_x :=5
var hand_flip_range :=1.5
var roll_hf_range :=-2.5

#what_i_can_do
var no_roll:Array
var no_attack:Array
var no_gravity:Array
var no_move:Array
var no_jump:Array
var no_input:Array
var no_motion:Array
var no_bend:Array
var no_direction:Array
var no_shake:Array
var no_bend_back:Array


func _ready() -> void:
	weapon._init_status()
	await get_tree().create_timer(1).timeout
	#血量模块测试
	#var all_commend_array:Array =  self.all_commend.get_children()
	#for i:HealthCommend in all_commend_array:
		#i.take_damage(1)

func _physics_process(delta: float) -> void:
	if is_on_floor():
		_is_on_floor = true
	else :
		_is_on_floor = false
	move_and_slide()
	add_gravity(delta)
	input_manager()

func input_manager()->void:
	if no_input.size() !=0:
		return
	move()
	jump()
	roll()
	weapon_attack()

func move()->void:
	if no_move.size()+no_motion.size() !=0:
		return
	direction = Input.get_axis("left_move","right_move")
	var real_direction = Input.get_axis("left_move","right_move")
	if Input.is_action_pressed("left_move") or Input.is_action_pressed("right_move"):
		velocity.x = move_toward(velocity.x,max_speed*real_direction,speed_up_speed)
		#粒子效果
		cpu_particles_2d.emitting =true
		#倾斜效果
		if no_bend.size() !=0:
			tween_commend.erase_tween("bend")
			var tween = create_tween().set_ease(Tween.EASE_OUT)
			tween_commend.add_tween(tween,"bend_back")
			tween.tween_property(self,"rotation_degrees",0,0.02)
			return
		if tween_commend.all_tween.get("bend") == null:
			var	tween = create_tween().set_ease(Tween.EASE_OUT)
			tween_commend.add_tween(tween,"bend")
			tween.tween_property(self,"rotation_degrees",bend_range*direction,0.2)
			self.scale = Vector2(1.0,1.0)
		if no_shake.size() !=0:
			tween_commend.erase_tween("shake")
			return
		if tween_commend.all_tween.get("shake")==null and is_on_floor():
			var tween = create_tween()
			tween_commend.add_tween(tween,"shake")
			tween.tween_property(self,"scale",Vector2(1.1,1/1.1),0.05)
			tween.tween_property(self,"scale",Vector2(1,1),0.08)
			tween.tween_property(self,"scale",Vector2(1/1.1,1.1),0.05)

	else :
		velocity.x = move_toward(velocity.x,0,slow_down_speed)
		if no_bend_back.size() !=0:
			tween_commend.erase_tween("bend_back")
			return
		self.scale = Vector2(1.0,1.0)
		#粒子效果
		cpu_particles_2d.emitting = false
		#倾斜效果
		if tween_commend.all_tween.get("bend_back") == null:
			tween_commend.erase_tween("bend")
			tween_commend.erase_tween("shake")
			var tween = create_tween().set_ease(Tween.EASE_OUT)
			tween_commend.add_tween(tween,"bend_back")
			tween.tween_property(self,"rotation_degrees",0,0.15)

func jump()->void:
	if no_jump.size()+no_motion.size() !=0 or _is_on_floor==null:
		return
	if _is_on_floor:
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_speed
			var tween = create_tween()
			tween_commend.add_tween(tween,"jump")
			tween.tween_property(self,"scale",Vector2(1/1.2,1.2),0.2)

func roll()->void:
	if no_roll.size()+no_motion.size() !=0:
		return
	if Input.is_action_just_pressed("roll"):
		#存储状态
		no_roll.append("roll")
		no_input.append("roll")
		no_gravity.append("roll")
		#非tween数据
		velocity.x = roll_speed*direction
		var ori_sd_speed = slow_down_speed
		slow_down_speed = roll_sd_speed
		move_and_slide()
	
		var tween = create_tween().set_ease(Tween.EASE_OUT)
		tween_commend.add_tween(tween,"roll")
		tween.tween_property(self,"rotation_degrees",360*direction,0.2)
		await tween.finished

		#清除状态
		no_input.erase("roll")
		no_gravity.erase("roll")
		slow_down_speed = ori_sd_speed
		await get_tree().create_timer(roll_interval).timeout
		no_roll.erase("roll")

func weapon_attack()->void:
	if no_attack.size() !=0:
		return
	if Input.is_action_just_pressed("attack"):
		weapon.play_normal(self)

func add_gravity(delta)->void:
	if no_gravity.size() !=0 and _is_on_floor==null:
		velocity.y = move_toward(velocity.y,0,get_gravity().y*gravity_mag*delta*5)
		return
	if ! _is_on_floor:
		velocity.y = move_toward(velocity.y,max_down_speed,get_gravity().y*gravity_mag*delta)
		if velocity.y >=300:
			is_down_speed = true

func set_direction(value)->void:
	if no_direction.size() !=0:
		return
	match value:
		0:
			return
		1.0,-1.0:
			if direction != value:
				#hand反转动画
				var tween = create_tween()
				tween_commend.add_tween(tween,"flip")
				if velocity.x !=0:
					tween.tween_property(hand_anchor,"position",hand_anchor.position+Vector2(hand_flip_range*direction,0),0.1)
				tween.tween_property(hand_anchor,"scale",Vector2(value,scale.y),0.25)
				tween.parallel().tween_property(hand_anchor,"position",Vector2(2+value/2,0),0.25)
				tween.parallel().tween_property(camera_2d,"offset",Vector2(camera_flip_offest_x*value,0),0.2)
				direction_change.emit(direction)
				
			direction = value

func set_on_floor(value)->void:
	if _is_on_floor == null:
		_is_on_floor = value
	if value != _is_on_floor:
		if value == false:
			#起飞了
			if ! tween_commend.all_tween.get("jump",false):
				var tween = create_tween()
				tween_commend.add_tween(tween,"free_fall")
				tween.tween_property(self,"scale",Vector2(1/1.4,1.4),1)
		elif value == true:
			#落地了
			if tween_commend.all_tween.get("free_fall",false):
				tween_commend.erase_tween("free_fall")
			if is_down_speed:
				var tween = create_tween().set_trans(Tween.TRANS_BOUNCE)
				tween_commend.add_tween(tween,"land")
				tween.tween_property(self,"scale",Vector2(1/0.75,0.75),0.05)
				tween.parallel().tween_property(self,"rotation_degrees",bend_range*direction,0.05)
				is_down_speed= false
		_is_on_floor = value
