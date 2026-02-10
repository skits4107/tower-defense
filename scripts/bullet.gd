class_name Bullet
extends Node2D

var stats:Bullet_Resource;
@onready var sprite = $"Sprite2D"

func _ready():
	sprite.texture = stats.sprite
	sprite.scale.x *= stats.sprite_scale
	sprite.scale.y *= stats.sprite_scale

func _process(delta: float) -> void:
	position += transform.basis_xform(Vector2.RIGHT) * stats.speed
	
