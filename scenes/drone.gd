extends Node2D


@export
var id = 0


var tagged = false


func _process(_delta):
	$Sprite2D.texture.region = Rect2(id * 6, 12, 6, 6)
