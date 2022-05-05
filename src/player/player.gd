extends KinematicBody2D

signal can_change(val)

onready var comp_color_detect : Area2D = $comp_color_detect

var velocity = Vector2()
var dir = Vector2()
var up_dir = Vector2.UP
export var gravity = 32.0*5.0
export var jump_speed = 32.0*5.0
export var acceleration = 32.0*10.0
export var floor_friction = 32.0*2.0
var jump = false
var change = false
var can_change = false setget set_can_change


const _RED = 1<<0
const _GREEN = 1<<1
const _BLUE = 1<<2
const _WHITE = (1<<3)-1
enum COLOR {
	RED = _RED,
	GREEN = _GREEN,
	BLUE = _BLUE,
	
	CYAN = _WHITE - _RED,
	MAGENTA = _WHITE - _GREEN,
	YELLOW = _WHITE - _BLUE
}

onready var COLORS_BEHAVIOUR = {
	COLOR.GREEN: ColorBehavior.new(Vector2.UP, COLOR.GREEN, Color.green),
	COLOR.RED: ColorBehavior.new(Vector2.RIGHT, COLOR.RED, Color.red),
	COLOR.BLUE: ColorBehavior.new(Vector2.DOWN, COLOR.BLUE, Color.blue)
}


func _ready():
	self.color = color
	connect("can_change",HUD.get_child(0),"set_visible")
	emit_signal("can_change", false)

export (COLOR) var color = COLOR.GREEN setget set_color



func set_color(val):
	color = val
	collision_mask = color
	comp_color_detect.collision_mask = color
	modulate = COLORS_BEHAVIOUR[color].color
	

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
	self.can_change = comp_color_detect.get_overlapping_areas().size()>0
	if can_change and change:
		change_color_from_background()
		change = false

func set_can_change(val):
	if val != can_change:
		can_change = val
		emit_signal("can_change", val)

func change_color_from_background():
	for area in comp_color_detect.get_overlapping_areas():
		self.color = area.change_color(color)

func _input(event):
	if event.is_action_pressed("jump"):
		jump = true
	if event.is_action_released("jump"):
		jump = false
	if event.is_action_pressed("transform"):
		change = true
	if event.is_action_released("transform"):
		change = false
	if event.is_action_released("restart"):
		get_tree().reload_current_scene()

class ColorBehavior:
	var up_dir := Vector2()
	var col_layer := 0
	var color := Color()
	
	func _init(up_dir: Vector2, col_layer: int, color: Color):
		self.up_dir = up_dir
		self.col_layer = col_layer
		self.color = color

