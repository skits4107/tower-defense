class_name Tower
extends Node2D

enum State {HOLDING, PLACED, BUYABLE}

@export var stats:TowerStats;
var state:State = State.BUYABLE

var can_place:bool = true

@onready var sprite:Sprite2D = $"Tower Sprite"
@onready var placement_area:Area2D = $placement_area
@onready var range_area:Area2D = $range_area

var colliding_with:Array[Node2D] = []

func _ready():
	sprite.texture = stats.sprite
	sprite.scale.x = stats.sprite_scale
	sprite.scale.y = stats.sprite_scale
	
	var range_circle:CircleShape2D = range_area.find_child("CollisionShape2D").shape
	range_circle.radius = stats.fire_range


func _process(delta: float) -> void:
	if state == State.BUYABLE:
		modulate = Color.GRAY
	elif state == State.HOLDING:
		position = get_global_mouse_position()
	else:
		modulate = Color.WHITE


func _on_placement_area_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if (parent and parent is Tower or parent is EnemyPath
		and parent != self):
		can_place = false
		modulate = Color.RED
		colliding_with.append(parent)


func _on_placement_area_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if (parent and parent is Tower or parent is EnemyPath
		and parent != self):
		can_place = true
		modulate = Color.WHITE

func _on_placement_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		print("mouse event")
		if state == State.BUYABLE:
			buy()
		elif state == State.HOLDING:
			place()
		else: # State.PLACED
			pass

func buy():
	var new_tower:Tower = self.duplicate()
	get_tree().current_scene.add_child(new_tower)
	new_tower.state = State.HOLDING
	
func place():
	print(can_place)
	if can_place:
		state = State.PLACED
