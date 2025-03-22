extends Node3D

@export var SHOT_IMPULSE = 3;

const bullet = preload("res://GameFiles/Guns/bullet.tscn")

@export var bullets = 50;
@export var max_bullets = 50;
@export var shot_cooldown = 0.05;
var can_shoot = true

@export var momentum_mult = 0.85;
@export var dir_mult = 0.9;

## Shoot - this shot cancels a good chunk of momentum and throws you back a bunch
func process_shot(char: CharacterBody3D, forward: Vector3, backwards = false) -> void:
	if (not can_shoot or bullets <= 0):
		return
	
	var dir_2D: Vector3 = forward
	# Limit upwards momentum a bit or else it feels ur out of control
	dir_2D.y *= dir_mult
	# Cancel some momentum so the gun can be used to stop moving so fast
	char.velocity *= momentum_mult
	if backwards:
		char.velocity -= dir_2D * SHOT_IMPULSE;
	else:
		char.velocity += dir_2D * SHOT_IMPULSE;
	
	bullets -= 1;
	can_shoot = false;
	$ShotCooldown.start(shot_cooldown)
	
	for spawn_loc: Node3D in $BulletSpread.get_children():
		var bul_inst = bullet.instantiate();
		get_tree().root.add_child(bul_inst)
		bul_inst.global_position = spawn_loc.global_position;
		bul_inst.global_rotation = spawn_loc.global_rotation;
		if backwards:
			bul_inst.global_rotation.y += deg_to_rad(180)

# TODO replace cooldown with animation markup
func _on_shot_cooldown_timeout() -> void:
	can_shoot = true;
