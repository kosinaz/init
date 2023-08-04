extends Control


var _time = 0


var _text_id = 1


const WALLS = [
	[Vector2i(2, 4), Vector2i(3, 4), Vector2i(5, 4), Vector2i(6, 4), Vector2i(7, 4), Vector2i(0, 5), Vector2i(2, 5)],
	[Vector2i(2, 4), Vector2i(3, 4), Vector2i(7, 4), Vector2i(1, 5), Vector2i(3, 5), Vector2i(5, 5), Vector2i(7, 5)],
	[Vector2i(3, 4), Vector2i(0, 5), Vector2i(2, 5), Vector2i(3, 5), Vector2i(4, 5), Vector2i(6, 5), Vector2i(7, 5)],
	[Vector2i(2, 4), Vector2i(4, 4), Vector2i(6, 4), Vector2i(1, 5), Vector2i(2, 5), Vector2i(3, 5), Vector2i(6, 5)],
]


func _process(_delta):
	if _time < 33:
		_time += 2
		queue_redraw()


func _draw():
	draw_rect(Rect2(Vector2(32 - _time, 32 - _time), Vector2(_time * 2, _time * 2)), Color.GREEN, false, 1)


func get_drone(drone_position):
	for drone in get_tree().get_nodes_in_group("drones"):
		if drone.position == drone_position:
			return drone
	return null


func move(unit, direction):
	var map_position = $%TileMap.local_to_map(unit.position)
	var tile = $%TileMap.get_cell_atlas_coords(0, Vector2i(map_position))
	if WALLS[direction].has(tile): return
	var target_position = Vector2(
		unit.position.x + [0, 6, 0, -6][direction], 
		unit.position.y + [-6, 0, 6, 0][direction]
	)
	if $%Hacker.position == target_position: return
	var drone = get_drone(target_position)
	if drone != null:
		if unit == $%Hacker:
			if drone.id == $%Hacker.id:
				if $DroneTimer.is_stopped(): 
					$DroneTimer.start()
				$%Hacker.id += 1
				drone.tagged = true
				drone.modulate = Color(0.5, 0.5, 0.5)
			else:
				get_tree().reload_current_scene()
		else: return
	unit.position = target_position


func _on_up_pressed():
	move($%Hacker, 0)


func _on_right_pressed():
	move($%Hacker, 1)


func _on_down_pressed():
	move($%Hacker, 2)


func _on_left_pressed():
	move($%Hacker, 3)


func _on_drone_timer_timeout():
	for drone in get_tree().get_nodes_in_group("drones"):
		if not drone.tagged: move(drone, randi_range(0, 3))


func _on_text_timer_timeout():
	if _text_id == 0: 
		$%Text.text = "avoid the others"
		_text_id = 1
	elif _text_id == 1:
		$%Text.text = "tag the " + str($%Hacker.id)
		_text_id = 0
