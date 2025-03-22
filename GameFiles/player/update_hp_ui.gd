extends Label

func _ready() -> void:
	text = str($"../../Health".curr_hp) + " / " +  str($"../../Health".MAX_HP)


func _on_health_on_update() -> void:
	text = str($"../../Health".curr_hp) + " / " +  str($"../../Health".MAX_HP)
