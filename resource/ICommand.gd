class_name ICommand
extends RefCounted

#
func execute()->void:
	assert(false,"execute方法未在子类中实现")

func undo()->void:
	assert(false,"undo方法未在子类中实现")
