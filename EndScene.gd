extends Node2D

export var start_level : String = "res://GameScene.tscn"

var total_balloons = 0

func _ready():
	var ch = get_node("/root/Checkpointer")
	
	total_balloons = ch.get_popped_total()
	show_balloons(total_balloons)

func show_balloons(count : int):
	var all_balloons = $Balloons.get_children()
	count = min(len(all_balloons), count)
	
	var i = 0
	for b in all_balloons:
		i += 1
		if i > count:
			b.visible = false

func _process(delta):
	if Input.is_action_just_pressed("action_reset") or Input.is_action_just_pressed("action_grab"):
		get_node("/root/Checkpointer").reset_balloons()
		get_tree().change_scene(start_level)