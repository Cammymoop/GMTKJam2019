extends RigidBody2D

var enabled = true

export var normal_friction = 1.0

export var slide_friction = 0.2
var slide_on = false

func _ready():
	physics_material_override.friction = normal_friction

func disable() -> void:
	enabled = false
	$CollisionShape2D.set_deferred("disabled", true)
	gravity_scale = 0

func enable() -> void:
	enabled = true
	$CollisionShape2D.set_deferred("disabled", false)
	gravity_scale = 1

func slide():
	slide_on = true
	physics_material_override.friction = slide_friction
	$SlideTimer.start()

func _on_SlideTimer_timeout():
	slide_on = false
	#print('done with the sliding')
	physics_material_override.friction = normal_friction
