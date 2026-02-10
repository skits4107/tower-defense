class_name Tower
extends Node2D

enum State {HOLDING, PLACED, BUYABLE}

@export var stats:TowerStats;
var state:State = State.BUYABLE

var is_placeable:bool = true

@onready var sprite:Sprite2D = $"Tower Sprite"
@onready var placement_area:Area2D = $placement_area
@onready var range_area:Area2D = $range_area

var colliding_with:Array[Node2D] = []

var target:Enemy = null

func _ready():
	sprite.texture = stats.sprite
	sprite.scale.x = stats.sprite_scale
	sprite.scale.y = stats.sprite_scale
	
	var range_circle:CircleShape2D = range_area.find_child("CollisionShape2D").shape
	range_circle.radius = stats.fire_range
	
	var placement_circle:CircleShape2D = placement_area.find_child("CollisionShape2D").shape
	placement_circle.radius *= stats.placement_area_scale


func _process(delta: float) -> void:
	if state == State.BUYABLE:
		modulate = Color.GRAY
	elif state == State.HOLDING:
		position = get_global_mouse_position()
		can_place()
	else:
		modulate = Color.WHITE
	
	if state == State.PLACED and target:
		shoot()

func shoot():
	pass


func _on_placement_area_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if (parent and parent != self and area.name != "range_area"):
		colliding_with.append(parent)


func _on_placement_area_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if (parent and parent != self and area.name != "range_area"):
		colliding_with.erase(parent)

func can_place():
	if colliding_with.is_empty():
		is_placeable = true
		modulate = Color.WHITE
	else:
		is_placeable = false
		modulate = Color.RED

func _on_placement_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event is InputEventMouseButton 
	and event.button_index == MOUSE_BUTTON_LEFT 
	and event.is_pressed()):
		
		print("mouse event")
		if state == State.BUYABLE and not GameManger.is_holding:
			buy()
		elif state == State.HOLDING:
			place()
		else: # State.PLACED
			pass

func buy():
	var new_tower:Tower = self.duplicate()
	get_tree().current_scene.add_child(new_tower)
	new_tower.state = State.HOLDING
	GameManger.is_holding = true
	
func place():
	print(is_placeable)
	if is_placeable:
		state = State.PLACED
		GameManger.is_holding = false


func _on_range_area_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if not parent:
		return
	if parent is not Enemy:
		return
	
	if not target:
		target = parent
		


func _on_range_area_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if not parent:
		return
	
	if target == parent:
		target = null
