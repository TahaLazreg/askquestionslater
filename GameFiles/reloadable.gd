extends Node

var parent = null

func _ready() -> void:
	parent = get_parent()
	pass

func reload() -> void:
	var curr_parent = get_parent()
	curr_parent = parent;
