extends Node

onready var levels = get_children()
var current_level = -1

func next_level():
	current_level += 1
	get_tree().change_scene_to(levels[current_level].scene)

func prev_level():
	current_level -= 1
	get_tree().change_scene_to(levels[current_level].scene)

func _input(event):
	if OS.is_debug_build():
		if event.is_action_pressed("next_level"):
			next_level()
		if event.is_action_pressed("prev_level"):
			prev_level()
