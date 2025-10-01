class_name WeaponStats
extends Resource

enum TYPE{
	GONG,
	JIAN,
	QIANG
}

@export_category("normal_state")
@export var attack:int
@export var icon:Texture2D
@export var init_offset:Vector2
@export var attackshape:Shape2D
@export var attackshape_offset:Vector2
@export var id:TYPE
@export var action:PackedScene
@export var animate:SpriteFrames
@export var weapon_ralated:WeaponToken
