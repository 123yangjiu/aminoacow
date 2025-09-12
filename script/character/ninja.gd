#meta-name: Character
#meta-description: Where make every character different
class_name Ninja
extends CharacterBody2D

@export var char_stats:CharacterStats

#node-related
@onready var sprite_2d: Sprite2D = $Sprite2D

#char_stats_variable-related
@onready var art:Texture2D = char_stats.art
@onready var init_image:Image = art.get_image()
@onready var SPEED = char_stats.speed
@onready var JUMP_VELOCITY:float = char_stats.jump_speed

var tileMap : TileMapLayer
var player : CharacterBody2D


func _ready() -> void:
	sprite_2d.texture = art
	char_stats.health = char_stats.max_health
	char_stats.image_changed.connect(image_change)

func image_change()->void:
	var image:Image = art.get_image()
	var height = image.get_height()
	var width = image.get_width()
	#health_mode作为指标
	var n = (1-char_stats.health_mode) * height
	for y in range(ceil(n)):
		for x in range(width):
			var ori_color:Color = image.get_pixel(x,y)
			if ori_color == Color.BLACK:
				image.set_pixel(x,y,Color.WHITE)
	sprite_2d.texture = ImageTexture.create_from_image(image)
	
func _physics_process(delta: float) -> void:
	move_and_slide()
	if not is_on_floor():
		velocity += get_gravity() * delta


func random_reset_position():
	print("Reseting Position")
	var center = tileMap.local_to_map(player.position)
	var validBlock : Array[Vector2i] = []
	var OX = 20
	var OY = 20
	for i in range(-OX, OX + 1):
		for j in range(-OY, OY + 1):
			var P = center + Vector2i(i, j)
			if tileMap.get_cell_source_id(P) != -1:
				continue
				
			# TODO: check the valid type of block !
			if tileMap.get_cell_source_id(P + Vector2i(0, 1)) == -1:
				continue
				
			validBlock.append(P)
			
	if (len(validBlock) == 0):
		print("No valid Block...")
		return
		
	var idx = randi_range(0, len(validBlock) - 1)
	#position = tileMap.map_to_local(validBlock[idx])
	position = tileMap.map_to_local(Vector2i(11, 4))
	print("Position to ", position)
	
func random_spawn(_tileMap : TileMapLayer, _player):
	tileMap = _tileMap
	player = _player
	random_reset_position()
	
