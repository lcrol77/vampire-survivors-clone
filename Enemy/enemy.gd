extends CharacterBody2D

@export var movement_speed = 20.0
@export var hp = 10
@export var knockback_recovery = 3.5
var knockback = Vector2.ZERO

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var walk_cycle_timer: Timer = $WalkCycleTimer
@onready var hit_sound: AudioStreamPlayer2D = $hit_sound

var death_anim: PackedScene = preload("res://Enemy/explosion.tscn")

signal remove_from_array(object)

func _physics_process(delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction = global_position.direction_to(player.global_position)
	if direction.x > 0.1: sprite_2d.flip_h = true
	elif direction.x < 0.1: sprite_2d.flip_h = false
	
	# TODO: would like to make this animation controlled by an animation player
	if direction != Vector2.ZERO:
		if walk_cycle_timer.is_stopped():
			if sprite_2d.frame >=sprite_2d.hframes -1:
				sprite_2d.frame = 0
			else: sprite_2d.frame += 1
			walk_cycle_timer.start()
	velocity = direction * movement_speed
	velocity += knockback
	move_and_collide(velocity * delta)

func death():
	emit_signal("remove_from_array", self)
	var enemy_death = death_anim.instantiate()
	enemy_death.scale = sprite_2d.scale
	enemy_death.global_position = global_position
	get_parent().call_deferred("add_child", enemy_death)
	queue_free()

func _on_hurtbox_hurt(damage: Variant, angle, knockback_amount) -> void:
	hp -=damage
	knockback = angle * knockback_amount
	if hp <=0:
		death()
	else:
		hit_sound.play()
