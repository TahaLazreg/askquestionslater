extends Control

const firstScene = preload("res://GameFiles/Levels/test_trenchbroom_level.tscn")

func _on_start_button_down() -> void:
	var first = firstScene.instantiate()
	get_tree().root.add_child(first)
	get_tree().current_scene = first
	queue_free()
