extends Node

@export var enemy_spawn_rate : int
@export var enemy_list : Array[PackedScene]
@export var enemy_generation_rate : Array[int]
@export var gen_once : bool = true

var totalEnemyCount = 0
var tileMap
var player

func generator() -> void:
	if gen_once and totalEnemyCount > 0:
		return
	if gen_once and get_child_count() > 1:
		return
		
	print("Generating...")
	# Probability of each enemy calculate by:
	# \ln(enemy_spawn_rate) * \frac 1 { ememy_generatetion_rate }
	for i in range(len(enemy_list)):
		var R = randf()
		var rate = log(enemy_spawn_rate) / enemy_generation_rate[i]
		if R > rate:
			continue
		++totalEnemyCount
		print("Generating ", i)
		var new : Ninja = enemy_list[i].instantiate()
		new.char_stats = new.char_stats.duplicate(true)
		new.random_spawn(tileMap, player)
		add_child(new)

func _ready() -> void:
	print("Generator Ready")
	$GenerationTick.timeout.connect(generator)
