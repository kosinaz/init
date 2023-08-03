extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_up_pressed():
	var map_position = $%TileMap.local_to_map($%Agent.position)
	var tile = $%TileMap.get_cell_atlas_coords(0, Vector2i(map_position))
	if tile.y == 4:
		if tile.x == 2: return
		if tile.x == 3: return
		if tile.x == 5: return
		if tile.x == 6: return
		if tile.x == 7: return
	if tile.y == 5:
		if tile.x == 0: return
		if tile.x == 2: return
	$%Agent.position.y -= 6


func _on_right_pressed():
	var map_position = $%TileMap.local_to_map($%Agent.position)
	var tile = $%TileMap.get_cell_atlas_coords(0, Vector2i(map_position))
	if tile.y == 4:
		if tile.x == 2: return
		if tile.x == 3: return
		if tile.x == 7: return
	if tile.y == 5:
		if tile.x == 1: return
		if tile.x == 3: return
		if tile.x == 5: return
		if tile.x == 7: return
	$%Agent.position.x += 6


func _on_down_pressed():
	var map_position = $%TileMap.local_to_map($%Agent.position)
	var tile = $%TileMap.get_cell_atlas_coords(0, Vector2i(map_position))
	if tile.y == 4:
		if tile.x == 3: return
	if tile.y == 5:
		if tile.x == 0: return
		if tile.x == 2: return
		if tile.x == 3: return
		if tile.x == 4: return
		if tile.x == 6: return
		if tile.x == 7: return
	$%Agent.position.y += 6


func _on_left_pressed():
	var map_position = $%TileMap.local_to_map($%Agent.position)
	var tile = $%TileMap.get_cell_atlas_coords(0, Vector2i(map_position))
	if tile.y == 4:
		if tile.x == 2: return
		if tile.x == 4: return
		if tile.x == 6: return
	if tile.y == 5:
		if tile.x == 1: return
		if tile.x == 2: return
		if tile.x == 3: return
		if tile.x == 6: return
	$%Agent.position.x -= 6
