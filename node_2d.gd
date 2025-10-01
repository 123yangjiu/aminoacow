extends Node2D
@onready var tween_commend: TweenCommend = $tween_commend

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	var tween = create_tween()
	tween_commend.add_tween(tween,"000")
	tween.tween_property(self,"scale",Vector2(2.0,2.0),0.5)
