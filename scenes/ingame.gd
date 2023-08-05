extends Control


var _time = 0


var _text_id = 1


var _ending = false


var _drone_id = 0


var _hacker_tween = null


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
	if Input.is_action_pressed("up"):
		move($%Hacker, 0)
	elif Input.is_action_pressed("right"):
		move($%Hacker, 1)
	elif Input.is_action_pressed("down"):
		move($%Hacker, 2)
	elif Input.is_action_pressed("left"):
		move($%Hacker, 3)
	else:
		$%Hacker.get_node("Sprite2D").stop()
	if _ending and get_tree().get_nodes_in_group("drones").size() == 0:
		add_sibling(load("res://scenes/win.tscn").instantiate())
		queue_free()


func _draw():
	if _time < 33:
		draw_rect(Rect2(Vector2(get_viewport_rect().size.x / 2 - _time, get_viewport_rect().size.y / 2 - _time), Vector2(_time * 2, _time * 2)), Color.GREEN, false, 1)


func get_drone(drone_position):
	for drone in get_tree().get_nodes_in_group("drones"):
		if drone.position == drone_position:
			return drone
	return null


func move(unit, direction):
	if _ending: return
	var map_position = $%TileMap.local_to_map(unit.position)
	var tile = $%TileMap.get_cell_atlas_coords(0, Vector2i(map_position))
	if WALLS[direction].has(tile): return
	var target_position = Vector2(
		unit.position.x + [0, 6, 0, -6][direction], 
		unit.position.y + [-6, 0, 6, 0][direction]
	)
	if $%Hacker.position == target_position: return
	if unit == $%Hacker and is_instance_valid(_hacker_tween) and _hacker_tween.is_running(): return
	var drone = get_drone(target_position)
	if drone != null:
		if unit == $%Hacker:
			if drone.id == $%Hacker.id:
				if $DroneTimer.is_running(): 
					$DroneTimer.start()
				if get_tree().get_nodes_in_group("drones").size() > $%Hacker.id + 1:
					$%Hacker.id += 1
					drone.tagged = true
					drone.modulate = Color(0.5, 0.5, 0.5)
				else:
					$%Text.text = "iterating"
					$TextTimer.stop()
					_ending = true
			else:
				add_sibling(load("res://scenes/ingame.tscn").instantiate())
				queue_free()
		else: return
	_hacker_tween = get_tree().create_tween()
	_hacker_tween.tween_property(unit, "position", target_position, 0.25)
	unit.get_node("Sprite2D").play(["up", "right", "down", "left"][direction])


func _on_drone_timer_timeout():
	var drones = get_tree().get_nodes_in_group("drones")
	for drone in drones:
		if _ending and drone.id == _drone_id:
			drone.modulate = Color(1, 1, 1)
			_drone_id += 1
			return
		if _ending and drone.id + drones.size() == _drone_id:
			$%Text.text = "deactivating"
			drone.queue_free()
			return
		if not drone.tagged: move(drone, randi_range(0, 3))


func _on_text_timer_timeout():
	if _text_id == 0: 
		$%Text.text = "avoid the others"
		_text_id = 1
	elif _text_id == 1:
		$%Text.text = "tag the " + str($%Hacker.id)
		_text_id = 0


func _exit_tree():
	_hacker_tween.kill()


func _on_up_button_down():
	Input.action_press("up")


func _on_right_button_down():
	Input.action_press("right")


func _on_down_button_down():
	Input.action_press("down")


func _on_left_button_down():
	Input.action_press("left")


func _on_up_button_up():
	Input.action_release("up")


func _on_right_button_up():
	Input.action_release("right")


func _on_down_button_up():
	Input.action_release("down")


func _on_left_button_up():
	Input.action_release("left")
