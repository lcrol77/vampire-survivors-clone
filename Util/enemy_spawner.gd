extends Node2D

@export var spawns: Array[SpawnInfo] = []

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")

var time = 0

func _on_timer_timeout() -> void:
	time+=1
	var enemy_spawns = spawns
	print(time)
	for spawn in enemy_spawns:
		if time >= spawn.time_start and time <= spawn.time_end:
			if spawn.spawn_delay_counter < spawn.enemy_spawn_delay:
				spawn.spawn_delay_counter +=1
			else: 
				spawn.spawn_delay_counter = 0
				var new_enemy = spawn.enemy
				var cnt = 0
				while cnt < spawn.enemy_num:
					var enemy_spawn = new_enemy.instantiate()
					enemy_spawn.global_position = get_rand_pos()
					add_child(enemy_spawn)
					cnt += 1

func get_rand_pos() -> Vector2:
	var vpr = get_viewport_rect().size * randf_range(1.1,1.4)
	var top_left = Vector2(player.global_position.x -vpr.x/2, player.global_position.y - vpr.y / 2)
	var top_right = Vector2(player.global_position.x +vpr.x/2, player.global_position.y - vpr.y / 2)
	var bottom_left = Vector2(player.global_position.x -vpr.x/2, player.global_position.y + vpr.y / 2)
	var bottom_right = Vector2(player.global_position.x +vpr.x/2, player.global_position.y + vpr.y / 2)
	var pos_side = ["up", "down","right","left"].pick_random()
	var spawn_pos_1 = Vector2.ZERO
	var spawn_pos_2 = Vector2.ZERO
	match pos_side:
		"up":
			spawn_pos_1 = top_left
			spawn_pos_2 = top_right
		"down":
			spawn_pos_1 = bottom_left
			spawn_pos_2 = bottom_right
		"left":
			spawn_pos_1 = top_left
			spawn_pos_2 = bottom_left
		"right":
			spawn_pos_1 = top_right
			spawn_pos_2 = bottom_right
	var x_spawn = randf_range(spawn_pos_1.x, spawn_pos_2.x)
	var y_spawn = randf_range(spawn_pos_1.y, spawn_pos_2.y)
	return Vector2(x_spawn,y_spawn)
