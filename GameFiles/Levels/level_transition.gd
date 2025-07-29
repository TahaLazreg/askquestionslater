extends Area3D

@export var level_name = "res://GameFiles/Levels/level_1_1.tscn"

func on_level_end(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	# Add stuff to end screen before loading it
	# Load end screen and allow it to transition to next level
	# Have resource to hold time data and unlocks and shit
	# For now just load next level
	var lvl = load(level_name).instantiate();
	get_tree().root.add_child(lvl);
	get_parent().queue_free();
	
