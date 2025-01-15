extends Area3D

@export var DMG = 1;
const BULLET_SPEED = 1;

func _physics_process(delta: float) -> void:
	position += transform.basis.z.normalized() * BULLET_SPEED

func _on_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	var health: Health = body.get_node("Health")
	if (health != null):
		health.deal_dmg(1);
	queue_free()
