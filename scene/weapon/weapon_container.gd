class_name WeaponContainer
extends Control

@onready var texture_rect_up: TextureRect = $VBoxContainer/TextureRectUp
@onready var texture_rect_down: TextureRect = $VBoxContainer/TextureRectDown

@export var confirm_shader:Shader

func update(texture_up:Texture,texture_down:Texture)->void:
	texture_rect_up.texture = texture_up
	texture_rect_down.texture = texture_down

func flip_self()->void:
	var tween := create_tween().set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(self,"position",Vector2(position.x*-1,position.y),0.1)

func add_shader(up_or_down)->void:
	if up_or_down:
		texture_rect_up.material.shader = confirm_shader
		texture_rect_down.material.shader = null
	else:
		texture_rect_down.material.shader = confirm_shader
		texture_rect_up.material.shader = null

func delete_shader()->void:
	texture_rect_down.material.shader = null
	texture_rect_up.material.shader = null
