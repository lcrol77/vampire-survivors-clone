extends CharacterBody2D

@export var movement_speed = 40.0
@onready var sprite_2d: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	movement()

func movement() -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction.x > 0: sprite_2d.flip_h = true
	elif direction.x < 0: sprite_2d.flip_h = false
	velocity = direction * movement_speed
	move_and_slide()
