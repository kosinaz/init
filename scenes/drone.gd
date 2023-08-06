extends Node2D


@export
var id = 0


var tagged = false


var movement_tween = null


func _process(_delta):
	$Sprite2D.texture.region = Rect2(id * 6, 12, 6, 6)


func _exit_tree():
	if is_instance_valid(movement_tween):
		movement_tween.kill()
