extends Node2D

export var start_level : String = "res://GameScene.tscn"

func _process(delta):
	if Input.is_action_just_pressed("action_reset") or Input.is_action_just_pressed("action_grab"):
		get_tree().change_scene(start_level)