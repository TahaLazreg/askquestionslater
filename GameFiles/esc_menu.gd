extends MarginContainer

signal EscapeMenu
signal ReloadLevel
signal ExitGame

func _on_resume_pressed() -> void:
	emit_signal("EscapeMenu")

func _on_restart_pressed() -> void:
	emit_signal("ReloadLevel")

func _on_exit_pressed() -> void:
	emit_signal("ExitGame")

func _input(event: InputEvent) -> void:
	if (not event.is_action_pressed("restart_level")):
		return
	emit_signal("ReloadLevel")
