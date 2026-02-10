class_name EnemyPath
extends Path2D

var spawn_timer:Timer = Timer.new()
@export var enemy_base:PackedScene;
@export var enemy_types:Array[EnemyResource];
var enemy_spawn_weights:PackedFloat32Array = PackedFloat32Array()

var rng = RandomNumberGenerator.new()

func _ready():
	for enemy_type in enemy_types:
		enemy_spawn_weights.append(enemy_type.spawn_weight)
	
	spawn_timer.wait_time = 3
	spawn_timer.one_shot = false
	spawn_timer.timeout.connect(spawn_enemy)
	add_child(spawn_timer)
	spawn_timer.start()


func spawn_enemy():
	var enemy_index = rng.rand_weighted(enemy_spawn_weights)
	var e:Enemy = enemy_base.instantiate()
	e.stats = enemy_types[enemy_index]
	add_child(e)
