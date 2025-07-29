extends Control

@export var first_scene_on_new_game = "res://GameFiles/Cutscenes/IntroCutscene.tscn"
@onready var firstScene = load(first_scene_on_new_game)

func _on_start_button_down() -> void:
	var first = firstScene.instantiate()
	get_tree().root.add_child(first)
	get_tree().current_scene = first
	queue_free()
