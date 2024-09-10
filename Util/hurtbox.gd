extends Area2D

@export_enum("Cooldown", "HitOnce", "DisableHitBox") var HurtboxType = 0

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var disable_timer: Timer = $DisableTimer

signal hurt(damage)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("attack"):
		if area.get("damage") != null:
			match HurtboxType:
				0: # Cooldown
					collision.call_deferred("set", "disabled", true)
					disable_timer.start()
				1:
					pass
				2: # DisableHitBox
					if area.has_method("temp_disable"):
						area.temp_disable()
			var damage = area.damage
			emit_signal("hurt", damage)
			if area.has_method("enemy_hit"):
				area.enemy_hit(1)

func _on_disable_timer_timeout() -> void:
	collision.call_deferred("set", "disabled", false)
