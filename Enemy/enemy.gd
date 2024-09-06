extends CharacterBody2D

@export var movement_speed = 20.0
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	if direction.x > 0: sprite_2d.flip_h = true
	elif direction.x < 0: sprite_2d.flip_h = false
	velocity = direction * movement_speed
	move_and_collide(velocity * delta)
