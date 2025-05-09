extends Node3D

# * Mechanics of the guns
# * Add a new gun ~
# * Switching guns ~
# * Enemies

var menu = preload("res://GameFiles/esc_menu.tscn").instantiate();

var inFocus: bool = true;
var inMenu: bool = false;

func _ready() -> void:
	get_viewport().focus_entered.connect(on_focus_change)
	get_viewport().focus_exited.connect(on_focus_change)
	var existing_menu = get_tree().get_first_node_in_group("Esc Menu");
	
	if (existing_menu != null):
		existing_menu.queue_free();
	
	menu.visible = false;
	add_child(menu);

	menu.connect("EscapeMenu", process_menu_call)
	menu.connect("ReloadLevel", restart_level)
	menu.connect("ExitGame", exit_game)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	

func on_focus_change() -> void:
	if (inMenu):
		return
	
	inFocus = not inFocus
	if (inFocus):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("esc_menu")):
		process_menu_call();
		
func process_menu_call() :
	if (not inMenu):
		# TODO proper pause
		%Player.set_physics_process(false);
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		menu.visible = true;
		inMenu = true;
		
		if get_node("Enemies") == null:
			return
		for enemy in get_node("Enemies").get_children():
			enemy.set_physics_process(false);
			enemy.can_shoot = false;
	else:
		# TODO proper pause
		%Player.set_physics_process(true);
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		menu.visible = false;
		inMenu = false;
		
		if get_node("Enemies") == null:
			return
		for enemy in get_node("Enemies").get_children():
			enemy.set_physics_process(true);
		
func restart_level():
	print("loop de loop")
	var level = get_tree().get_first_node_in_group("Level")
	for child in get_tree().root.get_children():
		if (child != level): child.queue_free();
		
	get_tree().reload_current_scene()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func exit_game():
	get_tree().quit()
