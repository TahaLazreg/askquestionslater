extends Node

@export var test_file = "res://GameFiles/Dialogue/EN/test_dialogue.txt"

var text_q = [];
var ppl_q = [];

func get_text_from_file(txt_file = "") -> bool:
	text_q = []
	ppl_q = []
	var file_name = txt_file if txt_file.length() > 0 else test_file
	var file = FileAccess.open(file_name, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		
		var lines = content.split("\n", false)
		for line in lines:
			var person_text = line.split("&", true, 1)
			text_q.append(person_text[1])
			ppl_q.append(person_text[0])
		
		return true
	else:
		return false
	
