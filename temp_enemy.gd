extends CharacterBody3D

const bullet = preload("res://enemy_bullet.tscn") # Replace with enemy bullet

func _ready() -> void:
	$ShootTimer.start()

func _on_death() -> void:
	queue_free()


func _on_shoot_timer_timeout() -> void:
	print("pew pew")
	var bul_inst = bullet.instantiate()
	get_tree().root.add_child(bul_inst)
	bul_inst.global_position = global_position;
	bul_inst.global_rotation = global_rotation;
	$ShootTimer.start()
