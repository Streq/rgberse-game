extends Area2D


func _physics_process(delta):
	global_position += InputUtils.get_dist_to_mouse(self)


func _input(event):
	if event is InputEventMouseButton:
		var m : InputEventMouseButton = event
		if (m.button_index == BUTTON_WHEEL_UP):
			rotation_degrees += 10
		elif (m.button_index == BUTTON_WHEEL_DOWN):
			rotation_degrees -= 10
		elif m.pressed:
			for body in get_overlapping_bodies():
				var b : PhysicsBody2D = body
				for o in b.get_shape_owners():
					var shape_owner = b.shape_owner_get_owner(o)
					for s in b.shape_owner_get_shape_count(o):
				
						var clipped_shape : ConvexPolygonShape2D = b.shape_owner_get_shape(o,s)
						var collider = shape_owner_get_owner(0)
						var clipping_shape : ConvexPolygonShape2D = self.shape_owner_get_shape(0,0)
							
						if (m.button_index == BUTTON_LEFT):
							var res = Geometry.clip_polygons_2d(
									shape_owner.global_transform.xform(clipped_shape.points), 
									global_transform.xform(clipping_shape.points))
							
		#					shape0.points = b.global_transform.xform_inv(clipped)
							for result in res:
#								Geometry.triangulate_polygon()
								clipped_shape.points = (shape_owner.global_transform.xform_inv(result))
							
							
							print(res)
						if (m.button_index == BUTTON_RIGHT):
							print(shape_owner.global_transform.xform(clipped_shape.points))
#							print(global_transform.xform(shape1.points))
							
						
				b.update()
				update()
						
				

func _draw():
	draw_colored_polygon(shape_owner_get_shape(0,0).points, Color.blue)
