extends CharacterBody3D

const bullet = preload("res://GameFiles/Enemies/enemy_bullet.tscn")

@onready var player = %Player

@export var VISION_ANGLE = 60;
@export var VISION_RANGE = 15;
var can_shoot = false;
var is_dead = false;

const RAYCAST_UPDATE_RATE = 6;

func _ready() -> void:
	$ShootTimer.start()

func _physics_process(delta: float) -> void:
	if (!can_shoot):
		can_shoot_player();
		return;
	
	transform = transform.looking_at(player.global_position, Vector3(0, 1, 0), true);
	
	$RayCast3D.transform = $RayCast3D.transform.looking_at(player.global_position, Vector3(0, 1, 0), true);
	$RayCast3D.target_position = player.global_position - global_position;
	
		
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()

func _on_death() -> void:
	visible = false;
	can_shoot = false;
	is_dead = true;
	

func _on_shoot_timer_timeout() -> void:
	if !can_shoot or $RayCast3D.is_colliding() or is_dead:
		return
	
	var bul_inst = bullet.instantiate()
	get_tree().root.add_child(bul_inst)
	bul_inst.global_position = global_position;
	bul_inst.global_rotation = global_rotation;
	$ShootTimer.start()
	
func can_shoot_player() -> void:
	var player_dist = (player.global_position - global_position).normalized()
	var forward = transform.basis.z.normalized()
	var angleBetween = acos(player_dist.dot(forward))
	
	# TODO add ray cast for view
	if (angleBetween < deg_to_rad(VISION_ANGLE)/2 and global_position.distance_squared_to(player.global_position) < VISION_RANGE * VISION_RANGE):
		can_shoot = true;
	else: can_shoot = false;
