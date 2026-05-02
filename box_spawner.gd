@abstract class_name BoxSpawner extends Node
const BOX = preload("uid://xeuf0beqtv3i")

func instantiate_box(box_position: Vector2):
	var spawned_box: Box = BOX.instantiate()
	get_tree().root.add_child(spawned_box)
	spawned_box.global_position = box_position
