extends CharacterBody2D
@onready var area_2d: Area2D = $Area2D

var ButtonHeld: bool = false

func _ready():
	area_2d.input_event.connect(_hello)

func _hello(viewport: Node, event: InputEvent, shape_idx: int):
	if Input.is_action_pressed("Click"):
		print("position.x = " + str(position.x) + " and event position = " + str(event.position.x))
		position.x = event.position.x

#func _process(delta: float) -> void:
	#if Input.is_action_pressed("Click"):
		#ButtonHeld = true
	#else:
		#ButtonHeld = false
#
#func _input(event):
	##if event is InputEventScreenDrag:
		##position.x = event.position.x
	#
		#if event is InputEventMouseMotion and ButtonHeld:
			#position.x = event.position.x
