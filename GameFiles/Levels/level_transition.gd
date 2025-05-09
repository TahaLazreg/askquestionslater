extends Area3D

@export var level_name = "1_1"

func on_level_end(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	# Add stuff to end screen before loading it
	# Load end screen and allow it to transition to next level
	# Have resource to hold time data and unlocks and shit
	# For now just load next level
	var lvl = load("res://GameFiles/Levels/level_" + level_name + ".tscn").instantiate();
	get_tree().root.add_child(lvl);
	get_parent().queue_free();
	
