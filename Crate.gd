extends RigidBody2D

var enabled = true

func disable() -> void:
	enabled = false
	$CollisionShape2D.set_deferred("disabled", true)
	gravity_scale = 0

func enable() -> void:
	enabled = true
	$CollisionShape2D.set_deferred("disabled", false)
	gravity_scale = 1