extends Area2D

@export var damage = 1
@onready var disable_timer: Timer = $DisableTimer
@onready var collision: CollisionShape2D = $CollisionShape2D

func temp_disable():
		collision.call_deferred("set", "disabled", true)
		disable_timer.start()
		
func _on_disable_timer_timeout() -> void:
	collision.call_deferred("set", "disabled", false)
