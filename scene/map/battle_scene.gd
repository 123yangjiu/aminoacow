extends Node

func _ready() -> void:
	$CharacterLayer/EnemyGenerator.tileMap = $TileMapLayer
	$CharacterLayer/EnemyGenerator.player = $CharacterLayer/Player
