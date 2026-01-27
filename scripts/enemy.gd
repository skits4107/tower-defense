class_name Enemy
extends PathFollow2D

var speed:float = 50;

func _process(delta: float) -> void:
	progress += speed * delta
