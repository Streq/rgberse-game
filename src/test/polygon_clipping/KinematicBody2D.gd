extends KinematicBody2D

var velocity = Vector2()
var dir = Vector2()

func _physics_process(delta):
	velocity = InputUtils.get_input_dir()*100
	
	velocity = move_and_slide(velocity)
	
