class_name SetAmountBoxSpawner extends BoxSpawner

@export var spawn_path: Path2D
@export var number_spawned: float
var spawn_curve: Curve2D

func _ready() -> void:
	spawn_boxes_func.call_deferred()

func spawn_boxes_func():
	spawn_curve = spawn_path.curve
	
	var spawn_distance: float = 0
	var curve_len := spawn_curve.get_baked_length()
	
	for box in number_spawned:
		var box_spawnpoint = spawn_curve.sample_baked(spawn_distance)
		spawn_distance += (curve_len / number_spawned) 
		
		instantiate_box(box_spawnpoint)
		
		#print("Box location: ", box_spawnpoint)
