extends CharacterBody3D

# TODO try again with quake controls

const WALK_SPEED = 5.0
const SPRINT_SPEED = 15.0
const DASH_SPEED = 35.0
const DASH_IMPULSE = 8.0
const JUMP_VELOCITY = 7.0

const SHOT_SPEED = 35.0

const SPD_HARD_LIMIT = 25;

const ACCEL = 5.0
const DECEL = 10.0

var max_speed = WALK_SPEED;
var speed = 0;

var just_shot = false;


var tilt_limit = deg_to_rad(67)
var is_dashing = false
var dash_cooldown = false
var is_sprinting = false

@export_range(0.0, 1.0) var mouse_sens_h := 0.025 * 5
@export_range(0.0, 1.0) var mouse_sens_v := 0.05
@onready var cam_pivot = %CamPivot
var _camera_input_direction := Vector2.ZERO

var dead_zone = 1.0;

@onready var cam = %Camera3D;

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	
	if not is_camera_motion:
		return
	
	_camera_input_direction = event.screen_relative
	_camera_input_direction.y *= mouse_sens_v
	_camera_input_direction.x *= mouse_sens_h
	if (_camera_input_direction.y < dead_zone and _camera_input_direction.y > -dead_zone): _camera_input_direction.y = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	cam_pivot.rotation.x -= _camera_input_direction.y * delta
	cam_pivot.rotation.x = clamp(cam_pivot.rotation.x, -tilt_limit, tilt_limit)
	cam_pivot.rotation.y -= _camera_input_direction.x * delta
	_camera_input_direction = Vector2.ZERO
	
	#Handle dash
	if (Input.is_action_just_pressed("dash") and !dash_cooldown):
		max_speed += DASH_IMPULSE
		speed += DASH_IMPULSE / 2
		is_dashing = true
		dash_cooldown = true
		$DashDuration.start()
		$DashCooldown.start()
	
	
	# ShootGun
	if Input.is_action_just_pressed("shoot") and not just_shot:
		just_shot = true;
		$ShotDuration.start()
		$ShotCooldown.start()

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		speed += 1
		velocity.y += JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_lft", "move_rgt", "move_fwd", "move_bck")
	var forward = cam_pivot.transform.basis.z.normalized()
	var right = cam_pivot.transform.basis.x.normalized()
	#var direction = forward + right
	#direction = direction.normalized()
	var curr_movement = forward * input_dir.y + right * input_dir.x
	
	curr_movement.y = 0;
	curr_movement = curr_movement.normalized()
	
	max_speed = WALK_SPEED;
	if (Input.is_action_just_pressed("sprint")):
		if(!is_sprinting):
			max_speed = SPRINT_SPEED;
			is_sprinting = true
		else:
			speed -= SPRINT_SPEED - WALK_SPEED
			is_sprinting = false
	
	if speed > SPD_HARD_LIMIT:
		speed = SPD_HARD_LIMIT;
	
	if curr_movement:
		print("mvmt")
		velocity.x = curr_movement.x * speed
		velocity.z = curr_movement.z * speed
		if(speed < max_speed): speed += ACCEL;
	else:
		print("no mvmt")
		velocity.x = 0
		velocity.z = 0
		if (speed > 0): speed -= DECEL
		if (speed < 0): speed = 0
		
		
	var dash_delta = Vector3.ZERO;
	if is_dashing: 
		dash_delta = forward * -DASH_SPEED
	
	velocity.x += dash_delta.x
	velocity.z += dash_delta.z
	
		
	var shot_delta = Vector3.ZERO
	if(just_shot):
		shot_delta = -forward
		shot_delta.x *= SHOT_SPEED
		shot_delta.z *= SHOT_SPEED
		shot_delta.y *= SHOT_SPEED # y lasts longer bc it doesn't get reset when shot ends
		speed += 8
		process_shot(shot_delta, self)

	move_and_slide()

func _on_dash_duration_timeout() -> void:
	max_speed -= DASH_IMPULSE
	is_dashing = false

func _on_dash_cooldown_timeout() -> void:
	dash_cooldown = false

func process_shot(shot_delta: Vector3, char: CharacterBody3D) -> void:
	pass


func _on_shot_duration_timeout() -> void:
	just_shot = false


func _on_shot_cooldown_timeout() -> void:
	pass
