extends CharacterBody2D

@export var movement_speed = 40.0
@export var hp = 80
var last_movement = Vector2.UP
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var walk_cycle_timer: Timer = $WalkCycleTimer

# Attacks
var ice_spear = preload("res://Player/Attacks/IceSpear/ice_spear.tscn")
var tornado = preload("res://Player/Attacks/Tornado/tornado.tscn")

# AttackNodes
@onready var ice_spear_timer:Timer = %IceSpearTimer
@onready var ice_spear_attack_timer:Timer = %IceSpearAttackTimer
@onready var tornado_timer: Timer = %TornadoTimer
@onready var tornado_attack_timer: Timer = %TornadoAttackTimer

# IceSpear
@export_group("IceSpear")
@export var ice_spear_base_ammo = 1
@export var ice_spear_ammo = 0
@export var ice_spear_attack_speed = 1.5
@export var ice_spear_level = 1

# Tornado
@export_group("Tornado")
@export var tornado_ammo = 0
@export var tornado_base_ammo = 1
@export var tornado_attack_speed = 3
@export var tornado_level = 1

# Enemy related
var enemies_close = []

func _ready() -> void:
	attack()

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction.x > 0: sprite_2d.flip_h = true
	elif direction.x < 0: sprite_2d.flip_h = false
	
	if direction != Vector2.ZERO:
		last_movement = direction
		print(last_movement)
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
	if tornado_level > 0:
		tornado_timer.wait_time = tornado_attack_speed
		if tornado_timer.is_stopped():
			tornado_timer.start()

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

func _on_tornado_timer_timeout() -> void:
	tornado_ammo += tornado_base_ammo
	tornado_attack_timer.start()

func _on_tornado_attack_timer_timeout() -> void:
	if tornado_ammo > 0:
		var tornado_attack:Tornado = tornado.instantiate()
		tornado_attack.position = position
		tornado_attack.last_movement = last_movement
		tornado_attack.level = tornado_level
		add_child(tornado_attack)
		tornado_ammo -=1
		if tornado_ammo > 0:
			tornado_attack_timer.start()
		else:
			tornado_attack_timer.stop()

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
