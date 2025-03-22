extends CharacterBody3D

const bullet = preload("res://GameFiles/Enemies/enemy_bullet.tscn")

@onready var player = %Player

const VISION_ANGLE = deg_to_rad(60);
const VISION_RANGE = 15;
var can_shoot = false;

func _ready() -> void:
	$ShootTimer.start()

func _physics_process(delta: float) -> void:
	can_shoot_player();
	
		
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()

func _on_death() -> void:
	queue_free()


func _on_shoot_timer_timeout() -> void:
	if !can_shoot:
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
	
	if (angleBetween < VISION_ANGLE/2 and global_position.distance_squared_to(player.global_position) < VISION_RANGE * VISION_RANGE):
		can_shoot = true;
		transform = transform.looking_at(player.global_position, Vector3(0, 1, 0), true);
	else: can_shoot = false;
