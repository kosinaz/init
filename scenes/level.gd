extends Control


@export
var level = 0


var _time = 0


var _text_id = 1


var _ending = false


var _drone_id = 0


var _drone_map = {}


var _hacker_map = {}


func _ready():
	_hacker_map[$%TileMap.local_to_map($%Hacker.position)] = $%Hacker
	if has_node("%Hacker2"): 
		_hacker_map[$%TileMap.local_to_map($%Hacker2.position)] = $%Hacker2
	for drone in get_tree().get_nodes_in_group("drones"):
		_drone_map[$%TileMap.local_to_map(drone.position)] = drone
		if level == 4:
			drone.modulate = Color(0.5, 0.5, 0.5)


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
	elif is_instance_valid($%Hacker.movement_tween) and not $%Hacker.movement_tween.is_running():
		$%Hacker.get_node("Sprite2D").stop()
	if has_node("%Hacker2"):
		if Input.is_action_pressed("up2"):
			move($%Hacker2, 0)
		elif Input.is_action_pressed("right2"):
			move($%Hacker2, 1)
		elif Input.is_action_pressed("down2"):
			move($%Hacker2, 2)
		elif Input.is_action_pressed("left2"):
			move($%Hacker2, 3)
		elif is_instance_valid($%Hacker2.movement_tween) and not $%Hacker2.movement_tween.is_running():
			$%Hacker2.get_node("Sprite2D").stop()
	if level == 4:
		if $%Hacker2.position.x < $%Hacker.position.x:
			move($%Hacker2, 1)
		elif $%Hacker2.position.x > $%Hacker.position.x:
			move($%Hacker2, 3)
		if $%Hacker2.position.y < $%Hacker.position.y:
			move($%Hacker2, 2)
		elif $%Hacker2.position.y > $%Hacker.position.y:
			move($%Hacker2, 0)
	if _ending and get_tree().get_nodes_in_group("drones").size() == 0:
		if level == 4:
			add_sibling(load("res://scenes/win.tscn").instantiate())
		else:
			add_sibling(load("res://scenes/level" + str(level + 1) + "title.tscn").instantiate())
		queue_free()


func _draw():
	if _time < 33:
		draw_rect(Rect2(Vector2(get_viewport_rect().size.x / 2 - _time, get_viewport_rect().size.y / 2 - _time), Vector2(_time * 2, _time * 2)), Color.GREEN, false, 1)


func get_drone(drone_position):
	for drone in get_tree().get_nodes_in_group("drones"):
		if $%TileMap.local_to_map(drone_position) == $%TileMap.local_to_map(drone.position):
			return drone
	return null


func move(unit, direction):
	if level == 4:
		$DroneTimer.start()
	if _ending: return
	if is_instance_valid(unit.movement_tween) and unit.movement_tween.is_running(): return
	var target_map_position = Vector2i(
		$%TileMap.local_to_map(unit.position).x + [0, 1, 0, -1][direction], 
		$%TileMap.local_to_map(unit.position).y + [-1, 0, 1, 0][direction]
	)
	var target_position = $%TileMap.map_to_local(target_map_position)
	var tile = $%TileMap.get_cell_atlas_coords(0, Vector2i(target_map_position))
	if tile == Vector2i(-1, -1): return
	if target_map_position == $%TileMap.local_to_map($%Hacker.position) or (has_node("%Hacker2") and target_map_position == $%TileMap.local_to_map($%Hacker2.position)):
		if level < 4: return
		add_sibling(load("res://scenes/level" + str(level) + ".tscn").instantiate())
		queue_free()
		return
	var target_drone = _drone_map.get(target_map_position)
	if target_drone != null:
		if unit == $%Hacker or (has_node("%Hacker2") and unit == $%Hacker2 and level == 3):
			if target_drone.id == $%Hacker.id:
				if not $DroneTimer.time_left: 
					$DroneTimer.start()
				var drones = get_tree().get_nodes_in_group("drones")
				if drones.size() > $%Hacker.id + 1:
					$%Hacker.id += 1
					for current_drone in drones:
						current_drone.get_node("TargetAnimation").visible = $%Hacker.id == current_drone.id
					target_drone.tagged = true
					if level < 4:
						target_drone.modulate = Color(0.5, 0.5, 0.5)
					else:
						target_drone.modulate = Color(1, 1, 1)
					target_drone.get_node("Sprite2D").stop()
				else:
					if level == 4: 
						add_sibling(load("res://scenes/win.tscn").instantiate())
						queue_free()
						return
					$%Text.text = "iterating"
					$TextTimer.stop()
					_ending = true
			else:
				add_sibling(load("res://scenes/level" + str(level) + ".tscn").instantiate())
				queue_free()
		elif level < 4: return
	unit.movement_tween = get_tree().create_tween()
	unit.movement_tween.tween_property(unit, "position", target_position, 0.25)
	unit.movement_tween.tween_callback(_clear_map_position.bind($%TileMap.local_to_map(unit.position), unit))
	unit.get_node("Sprite2D").play(["up", "right", "down", "left"][direction])
	if unit == $%Hacker or (has_node("%Hacker2") and unit == $%Hacker2):
		if _hacker_map.has(target_map_position) and _hacker_map[target_map_position] != null:
			add_sibling(load("res://scenes/level" + str(level) + ".tscn").instantiate())
			queue_free()
		else:
			_hacker_map[target_map_position] = unit
	else:
		_drone_map[target_map_position] = unit


func _clear_map_position(map_position, unit):
	if unit == $%Hacker or (has_node("%Hacker2") and unit == $%Hacker2):
		_hacker_map[map_position] = null
	else:
		_drone_map[map_position] = null


func _on_drone_timer_timeout():
	var drones = get_tree().get_nodes_in_group("drones")
	for drone in drones:
		if _ending and drone.id == _drone_id:
			print(drone.id)
			drone.modulate = Color(1, 1, 1)
			_drone_id += 1
			return
		if _ending and drone.id + drones.size() == _drone_id:
			$%Text.text = "deactivating"
			drone.queue_free()
			return
		if not drone.tagged: 
			if level == 1:
				move(drone, randi_range(0, 3))
			elif not randi_range(0, 3):
				return
			elif level == 2:
				if drone.id == $%Hacker.id:
					if drone.position.x < $%Hacker.position.x:
						move(drone, 3)
					elif drone.position.x > $%Hacker.position.x:
						move(drone, 1)
					if drone.position.y < $%Hacker.position.y:
						move(drone, 0)
					elif drone.position.y > $%Hacker.position.y:
						move(drone, 2)
				else:
					if drone.position.x < $%Hacker.position.x:
						move(drone, 1)
					elif drone.position.x > $%Hacker.position.x:
						move(drone, 3)
					if drone.position.y < $%Hacker.position.y:
						move(drone, 2)
					elif drone.position.y > $%Hacker.position.y:
						move(drone, 0)
			elif level == 3:
				if drone.id == 1 or drone.id == 2:
					if drone.id == $%Hacker.id:
						if drone.position.x < $%Hacker.position.x:
							move(drone, 3)
						elif drone.position.x > $%Hacker.position.x:
							move(drone, 1)
						if drone.position.y < $%Hacker.position.y:
							move(drone, 0)
						elif drone.position.y > $%Hacker.position.y:
							move(drone, 2)
					else:
						if drone.position.x < $%Hacker.position.x:
							move(drone, 1)
						elif drone.position.x > $%Hacker.position.x:
							move(drone, 3)
						if drone.position.y < $%Hacker.position.y:
							move(drone, 2)
						elif drone.position.y > $%Hacker.position.y:
							move(drone, 0)
				if drone.id == 0 or drone.id == 3:
					if drone.id == $%Hacker.id:
						if drone.position.x < $%Hacker2.position.x:
							move(drone, 3)
						elif drone.position.x > $%Hacker2.position.x:
							move(drone, 1)
						if drone.position.y < $%Hacker2.position.y:
							move(drone, 0)
						elif drone.position.y > $%Hacker2.position.y:
							move(drone, 2)
					else:
						if drone.position.x < $%Hacker2.position.x:
							move(drone, 1)
						elif drone.position.x > $%Hacker2.position.x:
							move(drone, 3)
						if drone.position.y < $%Hacker2.position.y:
							move(drone, 2)
						elif drone.position.y > $%Hacker2.position.y:
							move(drone, 0)


func _on_text_timer_timeout():
	if _text_id == 0: 
		$%Text.text = "avoid the others"
		_text_id = 1
	elif _text_id == 1:
		$%Text.text = "tag your target"
		_text_id = 0


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


func _on_up_2_button_down():
	Input.action_press("up2")


func _on_up_2_button_up():
	Input.action_release("up2")


func _on_right_2_button_down():
	Input.action_press("right2")


func _on_right_2_button_up():
	Input.action_release("right2")


func _on_down_2_button_down():
	Input.action_press("down2")


func _on_down_2_button_up():
	Input.action_release("down2")


func _on_left_2_button_down():
	Input.action_press("left2")


func _on_left_2_button_up():
	Input.action_release("left2")
