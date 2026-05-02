class_name Box extends StaticBody2D
@export var health: float = 20

func take_damage(damage_amount: float):
	health -= damage_amount
	
	if health <= 0:
		queue_free()
