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
