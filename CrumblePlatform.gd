extends KinematicBody2D

var activated = false

var drop_speed = 20

func _physics_process(delta):
	if activated:
		move_and_collide(Vector2(0, drop_speed) * delta, false)

func _on_Area2D_body_entered(body):
	activated = true
