extends Node

@export var level_name = "1_1"
@export var dialogue_file = "res://GameFiles/Dialogue/EN/test_dialogue.txt"

func _ready() -> void:
	# Play dialogue if its available
	var text_box: DialogBox = get_node("TextBox")
	if (text_box == null):
		return
	text_box.connect("RanOutText", load_next_level)
	text_box.start_dialogue(dialogue_file)

func load_next_level():
	print("loading next")
	var lvl = load("res://GameFiles/Levels/level_" + level_name + ".tscn").instantiate();
	get_tree().root.add_child(lvl);
	queue_free();
