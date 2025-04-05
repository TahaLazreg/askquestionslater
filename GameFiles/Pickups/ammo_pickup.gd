extends Area3D

@export var gun_type = "Shotgun"

func _on_body_shape_entered(body_rid: RID, body: Player, body_shape_index: int, local_shape_index: int) -> void:
	if !visible: return
	
	var gun = body.get_node("Body/Guns/Weapons/" + gun_type);
	gun.add_bullets(gun.max_bullets);
	visible = false;
