class_name NewPlayer
extends CharacterBody2D

#no指示物(结尾加t就是同时适用tween名字的意思)
const n_roll="roll"
const n_normal_attack = "normal_attack"
const n_exchange_attack = "exchange_attack"
const n_idle ="idle"
const n_free_fall ="free_fall"

#各tween的名字
const t_bend = "bend"
const t_bend_back ="bend_back"
const t_flip = "flip"
const t_roll ="roll"
const t_jump ="jump"
const t_free_fall ="free_fall"
const t_jump_fall = "jump_fall"
const t_land_slow ="land_slow"
const t_land_quick ="land_quick"
const t_shake = "shake"
const t_idle = "idle"
const t_normal_attack = "normal_attack"
const t_exchange_attack = "exchange_attack"



#const NEW_WEAPON = preload("uid://4iby6oili3lx")
@export var init_weapon:NewWeaponStatus


#all_commend
@export var all_commend:Array[Node]
@onready var health_commend: HealthCommend = $all_commend/health_commend
@onready var tween_commend: TweenCommend = $all_commend/tween_commend

#child_node-related
@onready var anchor: Node2D = $Anchor
@onready var hand_anchor: Node2D = $Anchor/Mainsprite2D/HandAnchor
@onready var weapon_pack: WeaponPack = $Anchor/WeaponPack

@onready var camera_2d: Camera2D = $Camera2D
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var mainsprite_2d: Sprite2D = $Anchor/Mainsprite2D
@onready var left_hand: Sprite2D = $Anchor/Mainsprite2D/HandAnchor/LeftHand
@onready var right_hand: Sprite2D = $Anchor/Mainsprite2D/HandAnchor/RightHand
@onready var weapon: NewWeapon = $Anchor/Mainsprite2D/HandAnchor/Weapon

#physice_input-related各种物理效果
var direction := 1.0 :set = set_direction
	#move
var speed_up_speed := 60
var max_speed := 200
var slow_down_speed := 90
var bend_range := 10
	#jump
var _is_on_floor:bool :set = set_on_floor
var jump_speed := -380
var jump_a_speed := 200

var jump_range :=1.2
var jump_time := 0.1

var jump_interval_time :=0.075

var jump_free_fall_range :=1.2
var jump_free_fall_time :=0.3
	#gravity
var no_gravity_slow_down := 1.9
var max_down_speed := 600
var the_down_speed = 350
var is_down_speed:=false

var land_quick_range :=0.75
var land_quick_time :=0.05

var land_slow_time :=0.05

var free_fall_range :=1.4
var free_fall_time :=0.8
	#roll
var roll_speed := 400
var roll_sd_speed :=100
var roll_interval := 0.3
	#idle
var idle_time:=3
var current_time =0
var is_idle:=false
signal idled(who:NewPlayer)
signal cancel_idle(who:NewPlayer)


#other_physics-related
var camera_flip_offest_x :=5
var hand_flip_range :=1.5
var roll_hf_range :=-2.5

#what_i_can_do字面意思
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
var no_idle:Array
var no_down_tween:Array
var no_exchange:Array


func _ready() -> void:
	if ! weapon.weapon_exchange_down.is_connected(weapon_pack.add_down_weapon):
		weapon.weapon_exchange_down.connect(weapon_pack.add_down_weapon)
	if ! weapon.weapon_exchange_up.is_connected(weapon_pack.add_up_weapon):
		weapon.weapon_exchange_up.connect(weapon_pack.add_up_weapon)
	#初始化武器
	if init_weapon:
		weapon._init_status(init_weapon)
	#连接idle和取消idle的信号
		if ! idled.is_connected(weapon.on_idled):
			idled.connect(weapon.on_idled)
		if !cancel_idle.is_connected(weapon.on_cancel_idle):
			cancel_idle.connect(weapon.on_cancel_idle)
	else :
		weapon_pack.to_idle(self)
	await get_tree().create_timer(1).timeout
	#血量模块测试
	#health_commend.take_damage(20)

func _physics_process(delta: float) -> void:
	if is_on_floor():
		_is_on_floor = true
	else :
		_is_on_floor = false
	move_and_slide()
	add_gravity(delta)
	input_manager(delta)

func input_manager(delta)->void:
	#管理输入
	if no_input.size() !=0:
		return
	move()
	jump()
	roll()
	weapon_attack()
	idle(delta)

func move()->void:
	if no_move.size()+no_motion.size() !=0:
		return
	direction = Input.get_axis("left_move","right_move")
	#用于实现攻击时只移动不转向
	var real_direction = Input.get_axis("left_move","right_move")
	if Input.is_action_pressed("left_move") or Input.is_action_pressed("right_move"):
		velocity.x = move_toward(velocity.x,max_speed*real_direction,speed_up_speed)
		#粒子效果
		cpu_particles_2d.emitting =true
		#倾斜效果
		if no_bend.size() !=0:
			#取消倾斜
			tween_commend.erase_tween(t_bend)
			var tween = create_tween().set_ease(Tween.EASE_OUT)
			tween_commend.add_tween(tween,t_bend_back)
			tween.tween_property(self,"rotation_degrees",0,0.02)
			return
		if tween_commend.all_tween.get(t_bend) == null:
			var	tween = create_tween().set_ease(Tween.EASE_OUT)
			tween_commend.add_tween(tween,t_bend)
			tween.tween_property(self,"rotation_degrees",bend_range*direction,0.2)
		#摇动效果
		if no_shake.size() !=0:
			tween_commend.erase_tween(t_shake)
			return
		if tween_commend.all_tween.get(t_shake)==null and is_on_floor():
			var tween = create_tween()
			tween_commend.add_tween(tween,t_shake)
			tween.tween_property(self,"scale",Vector2(1.1,1/1.1),0.05)
			tween.tween_property(self,"scale",Vector2(1,1),0.08)
			tween.tween_property(self,"scale",Vector2(1/1.1,1.1),0.05)

	else :
		velocity.x = move_toward(velocity.x,0,slow_down_speed)
		if _is_on_floor:
			scale=Vector2(1.0,1.0)
		if no_bend_back.size() !=0:
			tween_commend.erase_tween(t_bend_back)
			return
		#self.scale = Vector2(1.0,1.0)
		#粒子效果
		cpu_particles_2d.emitting = false
		#倾斜效果
		if tween_commend.all_tween.get(t_bend_back) == null:
			tween_commend.erase_tween(t_bend)
			tween_commend.erase_tween(t_shake)
			var tween = create_tween().set_ease(Tween.EASE_OUT)
			tween_commend.add_tween(tween,t_bend_back)
			tween.tween_property(self,"rotation_degrees",0,0.15)
			tween.parallel().tween_property(mainsprite_2d,"rotation_degrees",0,0.15)

func jump()->void:
	if no_jump.size()+no_motion.size() !=0 or _is_on_floor==null:
		return
	if Input.is_action_just_released("jump") and velocity.y<=-250:
		velocity.y *=0.5
	if _is_on_floor:
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_speed
			#idle时间
			current_time =0
			if tween_commend.get_tween(t_idle):
				weapon.qiang_jumpidle(self)
			#动画相关
			tween_commend.erase_tween(t_shake)
			var tween = create_tween()
			tween_commend.add_tween(tween,t_jump)
			tween.tween_property(self,"scale",Vector2(1/jump_range,jump_range),jump_time)

func roll()->void:
	if no_roll.size()+no_motion.size() !=0:
		return
	if Input.is_action_just_pressed("roll"):
		#idle时间
		if is_idle:
			cancel_idle.emit(self)
		#no指示物及tween名字
		var type = n_roll
		
		
		no_roll.append(type)
		no_input.append(type)
		no_gravity.append(type)
		#非tween数据
		velocity.x = roll_speed*direction
		var ori_sd_speed = slow_down_speed
		slow_down_speed = roll_sd_speed
		move_and_slide()
	
		var tween = create_tween().set_ease(Tween.EASE_OUT)
		tween_commend.add_tween(tween,type)
		tween.tween_property(self,"rotation_degrees",360*direction,0.2)
		await tween.finished
		#清除状态
		self.rotation_degrees =0
		no_input.erase(type)
		no_gravity.erase(type)
		slow_down_speed = ori_sd_speed
		await get_tree().create_timer(roll_interval).timeout
		no_roll.erase(type)

func idle(delta)->void:
	if no_idle.size() !=0:
		return
	if Input.is_anything_pressed():
		if Input.is_action_pressed("left_move"):
			current_time += delta
			if current_time >= idle_time:
				idled.emit(self)
		elif Input.is_action_pressed("right_move"):
			current_time += delta
			if current_time >= idle_time:
				idled.emit(self)
	else:
		current_time += delta
		if current_time >= idle_time:
			idled.emit(self)

func weapon_attack()->void:
	if no_attack.size() !=0:
		return
	if Input.is_action_just_pressed("attack"):
		var up_or_down = Input.get_axis("down","up")
		if up_or_down:
			#切武器加切武器攻击
			weapon.play_exchange(self,up_or_down)
			return
		#普通攻击
		weapon.play_normal(self)

func add_gravity(delta)->void:
	if no_gravity.size() !=0  and ! _is_on_floor:
		velocity.y = move_toward(velocity.y,0,get_gravity().y*no_gravity_slow_down*delta*5)
		return
	if ! _is_on_floor:
		velocity.y = move_toward(velocity.y,max_down_speed,get_gravity().y*no_gravity_slow_down*delta)
		if velocity.y >=the_down_speed:
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
				tween.parallel().tween_property(weapon_pack,"scale",Vector2(value,scale.y),0.25)
				tween.parallel().tween_property(hand_anchor,"position",Vector2(2+value/2,0),0.25)
				tween.parallel().tween_property(camera_2d,"offset",Vector2(camera_flip_offest_x*value,0),0.2)
				#direction_change.emit(direction)
			direction = value

func set_on_floor(value)->void:
	#初始化
	if _is_on_floor == null:
		_is_on_floor = value
	#一直在空中
	if _is_on_floor == false:
		#jump速度慢到这个程度后
		if velocity.y>=-300 and velocity.y<0:
			#开始下降
			if ! tween_commend.get_tween(t_jump_fall):
				tween_commend.erase_tween(t_jump)
				var tween = create_tween().set_ease(Tween.EASE_OUT)
				tween_commend.add_tween(tween,t_jump_fall)
				tween.tween_property(self,"scale",Vector2(1,1),0.2)
				tween.tween_interval(jump_interval_time)
				tween.tween_property(self,"scale",Vector2(1/jump_free_fall_range,jump_free_fall_range),jump_free_fall_time)
	#是双脚离地或双脚落地
	if value != _is_on_floor:
		if value == false:
			#自由落体了(通过有无跳跃动画判定)
			if ! tween_commend.get_tween(t_jump):
				var tween = create_tween()
				tween_commend.add_tween(tween,t_free_fall)
				no_idle.append(n_free_fall)
				tween.tween_property(self,"scale",Vector2(1/free_fall_range,free_fall_range),free_fall_time)
			
		elif value == true:
			#落地了
			no_idle.erase(n_free_fall)
			tween_commend.erase_tween(t_jump_fall)
			tween_commend.erase_tween(t_jump)
			if tween_commend.get_tween(t_free_fall):
				tween_commend.erase_tween(t_free_fall)
			if no_down_tween.size() !=0:
				_is_on_floor = value
				return
			if is_down_speed:
				#落地速度很快
				var tween = create_tween().set_trans(Tween.TRANS_BOUNCE)
				tween_commend.add_tween(tween,t_land_quick)
				tween.tween_property(self,"scale",Vector2(1/land_quick_range,land_quick_range),land_quick_time)
				tween.parallel().tween_property(mainsprite_2d,"rotation_degrees",bend_range*direction,land_quick_time)
				tween.tween_property(mainsprite_2d,"scale",Vector2(1,1),land_quick_time)
				tween.parallel().tween_property(mainsprite_2d,"rotation_degrees",0,land_quick_time)
				is_down_speed= false
			else:
				#落地速度一般
				var tween = create_tween().set_trans(Tween.TRANS_BOUNCE)
				tween_commend.add_tween(tween,t_land_slow)
				tween.tween_property(mainsprite_2d,"scale",Vector2(1,1),land_slow_time)
		_is_on_floor = value
