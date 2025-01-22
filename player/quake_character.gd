extends CharacterBody3D

const Q_MAX_SPEED = 50;
const Q_MAX_ACCEL = 6;
const JUMP_VELOCITY = 9.0

const DASH_IMPULSE = 23;

var can_jump = false
var just_jumped = false
var can_dash = true;

var tilt_limit = deg_to_rad(67)

@export_range(0.0, 1.0) var mouse_sens_h := 0.025 * 5
@export_range(0.0, 1.0) var mouse_sens_v := 0.05
@onready var cam_pivot = %CamPivot
var _camera_input_direction := Vector2.ZERO

const DEAD_ZONE = 0.3;

@onready var cam = %Camera3D;

func _input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	
	if not is_camera_motion:
		return
	
	_camera_input_direction = event.screen_relative
	_camera_input_direction.y *= mouse_sens_v
	_camera_input_direction.x *= mouse_sens_h
	if (_camera_input_direction.y < DEAD_ZONE and _camera_input_direction.y > -DEAD_ZONE): _camera_input_direction.y = 0

func _physics_process(delta: float) -> void:
	# Camera
	cam_pivot.rotation.x -= _camera_input_direction.y * delta
	cam_pivot.rotation.x = clamp(cam_pivot.rotation.x, -tilt_limit, tilt_limit)
	cam_pivot.rotation.y -= _camera_input_direction.x * delta
	_camera_input_direction = Vector2.ZERO
	
	$skeleton.rotation.y = cam_pivot.rotation.y + PI
	#%Guns.rotation.y = cam_pivot.rotation.y + PI
	%Guns.rotation.x = cam_pivot.rotation.x
	
	# Get input
	var input_dir := Input.get_vector("move_lft", "move_rgt", "move_fwd", "move_bck")
	var forward = cam_pivot.transform.basis.z.normalized()
	var right = cam_pivot.transform.basis.x.normalized()
	var curr_movement = forward * input_dir.y + right * input_dir.x
	
	curr_movement.y = 0;
	curr_movement = curr_movement.normalized()
	
	### Movement applied
	
	# Friction
	apply_friction()
	
	# Gravity
	if not is_on_floor():
		if ($CoyoteTime.is_stopped()):
			#print("start timer")
			$CoyoteTime.start()
		velocity += get_gravity() * delta
	else:
		$CoyoteTime.stop()
		can_jump = true
		just_jumped = false
		can_dash = true
		

	# Movement based on controls
	var curr_speed = velocity.dot(curr_movement)
	var max_speed = Q_MAX_SPEED if is_on_floor() else Q_MAX_SPEED / 10;
	var add_speed = min(max_speed - curr_speed, Q_MAX_ACCEL)
	add_speed = max(add_speed, 0)
	
	# Jump
	if Input.is_action_just_pressed("jump") and can_jump and not just_jumped:
		velocity.y += JUMP_VELOCITY
		just_jumped = true
		
	# Dash
	if Input.is_action_just_pressed("dash") and can_dash and (velocity.length() > 12 or not is_on_floor()):
		var dir_2D: Vector3 = -forward
		dir_2D.y = 0
		velocity += dir_2D * DASH_IMPULSE;
		can_dash = false
	
	# Movement - Literally just a copy paste from quake lmao
	velocity = velocity + add_speed * curr_movement;
	
	# TODO should we be able to shoot backwards?
	if Input.is_action_pressed("shoot"):
		%Guns.get_child(0).process_shot(self, forward);
	
	$UI.get_node("BulletCounter").text = str(%Guns.get_child(0).bullets) + " / " + str(%Guns.get_child(0).max_bullets)
	
	move_and_slide()


func _on_dash_cooldown_timeout() -> void:
	can_dash = true; #unused


func apply_friction () -> void:
	if is_on_floor():
		velocity.x *= 0.6
		velocity.z *= 0.6


func _on_coyote_time_timeout() -> void:
	#print("coyote done")
	can_jump = false


func _on_death() -> void:
	# TODO show death screen, do all the little effects
	#print("u died lmao")
	pass
