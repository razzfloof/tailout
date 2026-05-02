class_name IntervalBoxSpawner extends BoxSpawner

@export var spawn_path: Path2D
@export var spawn_interval: float
var spawn_curve: Curve2D

func _ready() -> void:
	spawn_boxes_func.call_deferred()

func spawn_boxes_func():
	spawn_curve = spawn_path.curve
	
	var cumulative_length: float = 0
	var curve_len := spawn_curve.get_baked_length()
	
	while cumulative_length < curve_len:
		
		var box_spawnpoint = spawn_curve.sample_baked(cumulative_length)
		
		instantiate_box(box_spawnpoint)
		
		cumulative_length += spawn_interval
		
		#print("Box location: ", box_spawnpoint)
