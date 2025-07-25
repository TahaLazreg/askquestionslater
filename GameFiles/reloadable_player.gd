extends "res://GameFiles/reloadable.gd"

var init_pos;
var init_cam_rot;

func _ready() -> void:
	init_pos = get_parent().transform;
	init_cam_rot = get_parent().get_node("%CamPivot").rotation;

func reload() -> void:
	var player := get_parent() as Player
	player.can_jump = false;
	player.just_jumped = false;
	player.can_dash = true;
	player.curr_gun = 0;

	player.jump_inputed = false;
	player.dash_inputed = false;

	player.is_shooting = false;
	
	for gun in player.get_node("Body/Guns/Weapons").get_children():
		gun.curr_bullets = gun.max_bullets;
		
	player.get_node("Health").reset_hp();
	player.transform = init_pos;
	player.get_node("%CamPivot").rotation = init_cam_rot;
	
	player.curr_level_time = 0;
	player.velocity = Vector3.ZERO
