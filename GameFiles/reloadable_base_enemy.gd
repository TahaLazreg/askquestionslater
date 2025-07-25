extends "res://GameFiles/reloadable.gd"

var init_pos;

func _ready() -> void:
	init_pos = get_parent().transform;

func reload() -> void:
	var enemy := get_parent()
	
	enemy.get_node("Health").reset_hp()
	enemy.transform = init_pos;
	enemy.can_shoot = false
	
	enemy.visible = true;
	enemy.is_dead = false;
