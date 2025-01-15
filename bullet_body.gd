extends Area3D

@export var DMG = 1;
const BULLET_SPEED = 1;

func _physics_process(delta: float) -> void:
	position += transform.basis.z.normalized() * BULLET_SPEED

func _on_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	var health: Health = area.get_parent().get_node("Health")
	health.deal_dmg(1);
