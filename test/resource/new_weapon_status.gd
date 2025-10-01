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
@export var init_offset:Vector2
@export var attackshape:Shape2D
@export var attackshape_offset:Vector2
@export var normal_action:PackedScene
@export var exchange_action:PackedScene
