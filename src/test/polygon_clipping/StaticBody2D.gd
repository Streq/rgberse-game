extends CollisionObject2D


func _draw():
	shape_owner_get_shape(0,0).points
	for o in get_shape_owners():
		var owner = shape_owner_get_owner(o)
		for s in shape_owner_get_shape_count(o):
			var shape = shape_owner_get_shape(o,s)
			var t_points = owner.transform.xform(shape.points)
			draw_colored_polygon(t_points, Color.blue)
