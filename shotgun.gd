extends Node3D

const SHOT_IMPULSE = 20;

@export var bullets = 5;
@export var max_bullets = 5;
@export var shot_cooldown = 0.35;
var can_shoot = true

## Shoot - this shot cancels a good chunk of momentum and throws you back a bunch
func process_shot(char: CharacterBody3D, forward: Vector3) -> void:
	if (not can_shoot or bullets <= 0):
		return
	
	var dir_2D: Vector3 = forward
	# Limit upwards momentum a bit or else it feels ur out of control
	dir_2D.y *= 0.7
	# Cancel some momentum so the gun can be used to stop moving so fast
	char.velocity *= 0.6
	char.velocity += dir_2D * SHOT_IMPULSE;
	
	bullets -= 1;
	can_shoot = false;
	$ShotCooldown.start(shot_cooldown)


func _on_shot_cooldown_timeout() -> void:
	can_shoot = true;
