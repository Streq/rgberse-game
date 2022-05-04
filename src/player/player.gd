extends KinematicBody2D


var velocity = Vector2()
var dir = Vector2()
var up_dir = Vector2.UP
var gravity = 200.0
var jump_speed = 200.0
var jump = false
var change = false
var acceleration = 200.0
var floor_friction = 40.0
enum COLOR {
	RED = 1<<0,
	GREEN = 1<<1,
	BLUE = 1<<2
}

onready var COLORS_BEHAVIOUR = {
	COLOR.GREEN: ColorBehavior.new(Vector2.UP, COLOR.GREEN),
	COLOR.RED: ColorBehavior.new(Vector2.RIGHT, COLOR.RED),
	COLOR.BLUE: ColorBehavior.new(Vector2.DOWN, COLOR.BLUE),
	
}


export (COLOR) var color = COLOR.GREEN setget set_color



func set_color(val):
	color = val
	

func _physics_process(delta):
#	velocity -= gravity*delta*up_dir
#	if is_on_floor() and jump:
#		jump = false
#		velocity += up_dir*jump_speed
#	#up_dir rotated
#	var floor_tangent = Vector2(up_dir.y, -up_dir.x)
#	velocity += dir.project(floor_tangent)*delta*acceleration
#	velocity *= 0.95

	dir = InputUtils.get_input_dir()
	var cb = COLORS_BEHAVIOUR[color]
	
	#move
	velocity = move_and_slide(velocity, cb.up_dir)
	velocity.x += abs(cb.up_dir.y) * dir.x * delta * acceleration
	velocity.y += abs(cb.up_dir.x) * dir.y * delta * acceleration

	#fall
	velocity -= cb.up_dir * gravity * delta
	
	#damping
	var damp_factor = Math.approach(1,0,delta * 1)
	velocity.x *= damp_factor
	velocity.y *= damp_factor


	if is_on_floor():
		if jump:
			#jump
			velocity += cb.up_dir * jump_speed
			jump = false
		else:
			#friction
			velocity.x = Math.approach(velocity.x, 0, abs(cb.up_dir.y * floor_friction * delta))
			velocity.y = Math.approach(velocity.y, 0, abs(cb.up_dir.x * floor_friction * delta))
	
	#changeColors
	if change:
#			changeColorFromBackground(this, gameState.static_grid)
		pass



func _input(event):
	if event.is_action_pressed("jump"):
		jump = true
	if event.is_action_released("jump"):
		jump = false
	if event.is_action_pressed("transform"):
		change = true


class ColorBehavior:
	var up_dir := Vector2()
	var col_layer := 0
	
	func _init(up_dir: Vector2, col_layer: int):
		self.up_dir = up_dir
		self.col_layer = col_layer
