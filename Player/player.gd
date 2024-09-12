extends CharacterBody2D

@export var movement_speed = 40.0
@export var hp = 80
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var walk_cycle_timer: Timer = $WalkCycleTimer

# Attacks
var ice_spear = preload("res://Player/Attacks/IceSpear/ice_spear.tscn")

# AttackNodes
@onready var ice_spear_timer:Timer = get_node("%IceSpearTimer")
@onready var ice_spear_attack_timer:Timer = get_node("%IceSpearAttackTimer")

# IceSpear
var ice_spear_ammo = 0
var ice_spear_base_ammo = 1
var ice_spear_attack_speed = 1.5
var ice_spear_level = 1

# Enemy related
var enemies_close = []

func _ready() -> void:
	attack()

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
	
func _on_hurtbox_hurt(damage: Variant, _angle,_knockback) -> void:
	hp -=damage
	print("hp ", hp)

func attack():
	if ice_spear_level > 0:
		ice_spear_timer.wait_time = ice_spear_attack_speed
		if ice_spear_timer.is_stopped():
			ice_spear_timer.start()

func _on_ice_spear_timer_timeout() -> void:
	ice_spear_ammo += ice_spear_base_ammo
	ice_spear_attack_timer.start()

func _on_ice_spear_attack_timer_timeout() -> void:
	if ice_spear_ammo > 0:
		var ice_spear_attack = ice_spear.instantiate()
		ice_spear_attack.position = position
		ice_spear_attack.target = get_random_target()
		ice_spear_attack.level = ice_spear_level
		add_child(ice_spear_attack)
		ice_spear_ammo -=1
		if ice_spear_ammo > 0:
			ice_spear_attack_timer.start()
		else:
			ice_spear_attack_timer.stop()

func get_random_target()->Vector2:
	if enemies_close.size() > 0:
		return enemies_close.pick_random().global_position
	return Vector2.UP

func _on_enemy_detection_area_body_entered(body: Node2D) -> void:
	if not enemies_close.has(body): 
		enemies_close.append(body)


func _on_enemy_detection_area_body_exited(body: Node2D) -> void:
	if enemies_close.has(body): 
		enemies_close.erase(body)
