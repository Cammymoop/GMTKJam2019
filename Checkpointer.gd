extends Node

var checkpoint_position : Vector2 = Vector2(0, 0)

var checkpoint_node_path : String = ''

func _ready():
	print('checkpoint ready')

func set_checkpoint(player : Node2D, checkpoint_path : String):
	print('set to: ' + checkpoint_path)
	checkpoint_node_path = checkpoint_path
	checkpoint_position = player.position

func unset_checkpoint():
	checkpoint_node_path = ''

func get_checkpoint_position() -> Vector2:
	return checkpoint_position

func get_checkpoint_node_path() -> String:
	return checkpoint_node_path

func is_checkpoint() -> bool:
	print(checkpoint_node_path)
	if len(checkpoint_node_path) > 0:
		return true
	return false