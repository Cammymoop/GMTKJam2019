extends AnimatedSprite

var popped = false

func _ready():
	randomize()
	$AnimationPlayer.seek(rand_range(0, 2.9))

func pop():
	var player = find_parent("Root").find_node("Player")
	if player:
		player.got_balloon()
	popped = true
	var rand = (randi() % 3) + 1
	get_node('Pop' + str(rand)).play()
	$AnimationPlayer.stop()
	play('pop')
	connect("animation_finished", self, "die")

func die():
	queue_free()

func _on_Area2D_body_entered(body):
	if popped:
		return
	pop()
