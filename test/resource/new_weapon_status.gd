class_name NewWeaponStatus
extends Resource
enum TYPE_NAME{
	QIANG,
	JIAN,
	GONG
}
enum TYPE_PLACE{
	_up,
	_down,
	_else,
	_idle,
	_hand
}
var place:TYPE_PLACE

@export_category("normal_state")
@export var name :TYPE_NAME
@export var texture:Texture
@export var sprite_offset:Vector2
@export var init_offset:Vector2
@export var attackshape:Shape2D
@export var attackshape_offset:Vector2

@export_category("pack_state_up")
@export var pack_up_position:Vector2
@export var pack_up_rotation:float
@export var pack_up_scale:Vector2

@export_category("pack_state_down")
@export var pack_down_position:Vector2
@export var pack_down_rotation:float
@export var pack_down_scale:Vector2

@export_category("pack_state_idle")
@export var pack_idle_position:Vector2
@export var pack_idle_rotation:float
@export var pack_idle_scale:Vector2

@export_category("action")
@export var normal_action:PackedScene
@export var normal_aiction_audio:AudioStream
@export var exchange_action_up:PackedScene
@export var exchange_aiction_up_audio:AudioStream
@export var exchange_action_down:PackedScene
@export var exchange_aiction_down_audio:AudioStream
@export var idle_action:PackedScene

@export_category("hand_state")
@export var left_hand_offset:Vector2 =Vector2(-3.0,0.5)
@export var if_left_hand_flip:bool
@export var right_hand_offset:Vector2 = Vector2(2.0,0.5)
@export var if_right_hand_flip:bool
