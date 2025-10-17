class_name TweenCommend
extends Node

@export var _owner:Node

var all_tween:Dictionary[StringName,Tween]


func get_tween(_name:StringName)->bool:
	var BOOL = all_tween.get(_name,false)
	if BOOL:
		return true
	else:
		return false

func add_tween(tween:Tween,_name:StringName)->void:
	if !_owner:
		print("未分配控制者")
		return
	if all_tween.has(_name):
		erase_tween(_name)
	all_tween[_name] = tween
	await tween.finished
	erase_tween(_name)

func erase_tween(_name:StringName)->void:
	if all_tween.has(_name):
		for _key in all_tween.keys():
			if _key == _name and all_tween[_key] is Tween:
				all_tween[_key].kill()
				all_tween[_key]=null
