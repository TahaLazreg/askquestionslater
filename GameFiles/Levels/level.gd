extends Node3D

# * Mechanics of the guns
# * Add a new gun ~
# * Switching guns ~
# * Enemies
@export var dialogue_file = "res://GameFiles/Dialogue/EN/test_dialogue.txt"
@export var unavailable_guns: Array[int] = []
var play_dialogue = false;
var menu = preload("res://GameFiles/esc_menu.tscn").instantiate();

var inFocus: bool = true;
var inMenu: bool = false;
var isPaused: bool = false;

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
	
	# Play dialogue if its available
	var text_box: DialogBox = get_node("TextBox")
	if (text_box == null):
		return
	text_box.connect("RanOutText", pause_game)
	
	pause_game()
	text_box.start_dialogue(dialogue_file)
	
	# Block unavailable guns
	var unavail_gun = unavailable_guns.pop_back()
	while (unavail_gun != null):
		%Player/Body/Guns/Weapons.remove_child(%Player/Body/Guns/Weapons.get_child(unavail_gun))
		unavail_gun = unavailable_guns.pop_back()

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
	if (isPaused and not inMenu):
		return;
	
	if (not inMenu):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		menu.visible = true;
		inMenu = true;
		pause_game()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		menu.visible = false;
		inMenu = false;
		pause_game()
		
func restart_level():
	
	var player = %Player
	var enemies = get_node("Enemies")
	var pickups = get_node("Pickups")
	
	if (player != null):
		player.get_node("Reloadable").reload()

	if (enemies != null):
		for enemy in enemies.get_children():
			enemy.get_node("Reloadable").reload()

	if (pickups != null):
		for pickup in pickups.get_children():
			pickup.get_node("Reloadable").reload()
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func pause_game():
	%Player.set_physics_process(isPaused);
	%Player.paused = !isPaused;
	if get_node("Enemies") == null:
		return
	for enemy in get_node("Enemies").get_children():
		enemy.set_physics_process(isPaused);
		if (!isPaused): enemy.can_shoot = false;
	isPaused = !isPaused

func exit_game():
	get_tree().quit()
