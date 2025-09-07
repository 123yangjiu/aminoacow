class_name WeaponContainer
extends Control

@onready var texture_rect_1: TextureRect = $VBoxContainer/TextureRect1
@onready var texture_rect_2: TextureRect = $VBoxContainer/TextureRect2

func update(texture_up:Texture,texture_down:Texture)->void:
	texture_rect_1.texture = texture_up
	texture_rect_2.texture = texture_down

func flip_self()->void:
	var tween := create_tween().set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(self,"position",Vector2(position.x*-1,position.y),0.1)
