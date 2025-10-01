class_name WeaponContainer
extends Control

#child_node
@onready var texture_rect_up: TextureRect = $VBoxContainer/TextureRectUp
@onready var texture_rect_down: TextureRect = $VBoxContainer/TextureRectDown

@export var confirm_shader:Shader

func _update_texture(texture_up:Texture,texture_down:Texture)->void:
	texture_rect_up.texture = texture_up
	texture_rect_down.texture = texture_down

func _flip()->void:
	var tween := create_tween().set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(self,"position",Vector2(position.x*-1,position.y),0.1)

func _add_shader(up_or_down)->void:
	if up_or_down:
		texture_rect_up.material.shader = confirm_shader
		texture_rect_down.material.shader = null
	else:
		texture_rect_down.material.shader = confirm_shader
		texture_rect_up.material.shader = null

func _delete_shader()->void:
	texture_rect_down.material.shader = null
	texture_rect_up.material.shader = null
