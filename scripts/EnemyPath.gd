class_name EnemyPath
extends Path2D

var spawn_timer:Timer = Timer.new()
@export var enemy:PackedScene;

func _ready():
	spawn_timer.wait_time = 3
	spawn_timer.one_shot = false
	spawn_timer.timeout.connect(spawn_enemy)
	add_child(spawn_timer)
	spawn_timer.start()


func spawn_enemy():
	var e:Enemy = enemy.instantiate()
	add_child(e)
