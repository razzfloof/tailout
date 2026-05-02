class_name Ball extends CharacterBody2D

@export var speed: float = 400
@export var damage: float = 10
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	velocity.x = 1
	velocity.y = 1
	
func _physics_process(delta: float) -> void:
	var collision: KinematicCollision2D = move_and_collide(velocity * speed * delta)
	if collision:
		var reflect = collision.get_remainder().bounce(collision.get_normal())
		velocity = velocity.bounce(collision.get_normal())
		move_and_collide(reflect)
		#print(collision.get_collider())
		
		var impacted_object = collision.get_collider()
		
		# checking to see if impacted object is box
		var box: Box = impacted_object as Box
		
		if box:
			box.take_damage(damage)
