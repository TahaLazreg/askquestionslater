extends Node3D

# * Mechanics of the guns
# * Add a new gun ~
# * Switching guns ~
# * Enemies

var menu = preload("res://esc_menu.tscn").instantiate();

var inFocus: bool = true;
var inMenu: bool = false;

func _ready() -> void:
	get_viewport().focus_entered.connect(on_focus_change)
	get_viewport().focus_exited.connect(on_focus_change)
	menu.visible = false;
	add_child(menu);

	menu.connect("EscapeMenu", process_menu_call)
	menu.connect("ReloadLevel", restart_level)
	menu.connect("ExitGame", exit_game)

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
		get_node("player").set_physics_process(false);
		for enemy in get_node("Enemies").get_children():
			enemy.set_physics_process(false);
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		menu.visible = true;
		inMenu = true;
	else:
		# TODO proper pause
		get_node("player").set_physics_process(true);
		for enemy in get_node("Enemies").get_children():
			enemy.set_physics_process(true);
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		menu.visible = false;
		inMenu = false;
		
func restart_level():
	get_tree().reload_current_scene()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func exit_game():
	get_tree().quit()
