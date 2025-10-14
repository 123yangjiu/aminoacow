class_name NewWeaponStatus
extends Resource
enum TYPE{
	GONG,
	JIAN,
	QIANG
}

@export_category("normal_state")
@export var name :TYPE
@export var texture:Texture
@export var sprite_offset:Vector2
@export var init_offset:Vector2
@export var attackshape:Shape2D
@export var attackshape_offset:Vector2

@export_category("action")
@export var normal_action:PackedScene
@export var normal_aiction_audio:AudioStream
@export var exchange_action:PackedScene
@export var exchange_aiction_audio:AudioStream
@export var idle_action:PackedScene


@export_category("hand_state")
@export var left_hand_offset:Vector2 =Vector2(-3.0,0.5)
@export var if_left_hand_flip:bool
@export var right_hand_offset:Vector2 = Vector2(2.0,0.5)
@export var if_right_hand_flip:bool
