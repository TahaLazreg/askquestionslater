extends CanvasLayer
class_name DialogBox

const BASE_READ_RATE = 0.04;

@onready var name_box = $TextboxContainer/Panel/Textbox/HBoxContainer/VBoxContainer/Name
@onready var text_box: RichTextLabel = $TextboxContainer/Panel/Textbox/HBoxContainer/DialogBox
@onready var end_box = $TextboxContainer/Panel/Textbox/HBoxContainer/EndText

@onready var container = $TextboxContainer

signal RanOutText;

var tween: Tween = null;
var elapsed_tween_time = 0;

var text_q = [];
var ppl_q = [];

enum state {
	READY,
	READING,
	DONE
}

var currState : state = state.READY;

func _ready():
	# start_dialogue();
	pass

func start_dialogue(text_file):
	tween = create_tween();
	tween.connect("finished", on_tween_done);
	
	#enqueue_text_name("There is no escape.", "Hades")
	
	$DialogueParser.get_text_from_file(text_file)
	text_q = $DialogueParser.text_q
	ppl_q = $DialogueParser.ppl_q

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		match currState:
			state.READING:
				text_box.visible_ratio = 1.0;
				tween.stop();
				on_tween_done();
			state.DONE:
				hide_textbox();
				change_to_new_state(state.READY);
				if (text_q.size() == 0 and ppl_q.size() == 0):
					RanOutText.emit();

func _process(delta: float) -> void:
	if (currState == state.READY and !text_q.is_empty()):
		set_text()
		display_textbox()

func hide_textbox():
	name_box.visible = false;
	text_box.visible = false;
	end_box.visible = false;
	container.hide();

func display_textbox():
	name_box.visible = true;
	text_box.visible = true;
	container.show();
	text_box.visible_ratio = 0.0;
	
	tween.kill();
	tween = create_tween();
	tween.connect("finished", on_tween_done);
	tween.tween_property(text_box, "visible_ratio", 1.0, len(text_box.text) * BASE_READ_RATE);
	
	change_to_new_state(state.READING);

func set_text():
	var txt = text_q.pop_front();
	var n_name = ppl_q.pop_front();
	
	name_box.text = n_name;
	text_box.text = txt;

func on_tween_done():
	end_box.visible = true;
	change_to_new_state(state.DONE);

func change_to_new_state(new_state):
	currState = new_state;

func enqueue_text_name(text: String, name: String):
	text_q.append(text);
	ppl_q.append(name);
