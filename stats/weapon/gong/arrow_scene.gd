extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VisibleOnScreenNotifier2D/Timer.timeout.connect(queue_free)
	
	
@export var G : float = 200.
@export var speed : int = 50
@export var initSpeedY : float = -30.0
var hitCount : int = 0 
var flying : bool = false
var speedY : float = 0
var attack : int 
var maxHitCount : int



func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("Not visible, removed")
	$VisibleOnScreenNotifier2D/Timer.start()



func shot(start, direction, set_attack, set_max_hit_count) -> void:
	position = start + Vector2(10, 0) * (1 if direction else -1)
	print("Start shotting at ", position)
	attack  = set_attack
	maxHitCount = set_max_hit_count
	hitCount = 0
	speedY = initSpeedY
	flying = true
	speed = 400 if direction else -400
	
func _physics_process(delta: float) -> void:
	speedY += G * delta
	var motion = Vector2(speed, speedY) * delta
	position += motion
	#move_toward(motion)
	print("To ", position)


func _on_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is Ninja:
		body.char_stats.take_damage(attack)
		hitCount += 1
	else:
		# collide with something wrong!
		print("Collide with something wrong!!")
		queue_free()

	if hitCount >= maxHitCount:
		queue_free()
	
	pass # Replace with function body.
