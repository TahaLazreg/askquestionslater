extends Node
class_name Health

@export var MAX_HP = 3;
@export var curr_hp: int = 3;

signal on_death;

func _ready() -> void:
	curr_hp = MAX_HP
	
func deal_dmg(dmg_to_take):
	curr_hp -= dmg_to_take;
	if (curr_hp <= 0):
		curr_hp = 0
		on_death.emit()

func heal_dmg(dmg_to_heal):
	curr_hp += dmg_to_heal;
	if (curr_hp > MAX_HP):
		curr_hp = MAX_HP
		

func reset_hp():
	curr_hp = MAX_HP;
