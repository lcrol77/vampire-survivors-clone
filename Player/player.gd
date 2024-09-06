extends CharacterBody2D

@export var movement_speed = 40.0
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var walk_cycle_timer: Timer = $WalkCycleTimer

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction.x > 0: sprite_2d.flip_h = true
	elif direction.x < 0: sprite_2d.flip_h = false
	
	if direction != Vector2.ZERO:
		if walk_cycle_timer.is_stopped():
			if sprite_2d.frame >=sprite_2d.hframes -1:
				sprite_2d.frame = 0
			else: sprite_2d.frame += 1
			walk_cycle_timer.start()
	
	velocity = direction * movement_speed
	move_and_collide(velocity * delta)
	
