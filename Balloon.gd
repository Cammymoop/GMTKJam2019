extends AnimatedSprite

var popped = false

func _ready():
	randomize()
	$AnimationPlayer.seek(rand_range(0, 2.9))
	
	var r_checkpointer = get_node("/root/Checkpointer")
	
	if r_checkpointer.is_checkpoint():
		if r_checkpointer.is_balloon_name_popped(name):
			queue_free()

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
	
	var r_checkpointer = get_node("/root/Checkpointer")
	r_checkpointer.pop_balloon_name(name)

func die():
	queue_free()

# warning-ignore:unused_argument
func _on_Area2D_body_entered(body):
	if popped:
		return
	pop()
