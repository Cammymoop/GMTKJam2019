extends Node

var checkpoint_position : Vector2 = Vector2(0, 0)
var checkpoint_node_path : String = ''

var checkpoint_balloons = 0
var checkpointed_balloon_names = []
var popped_balloon_names = []

var popped_balloon_total = 0

func _ready():
	#print('checkpoint ready')
	pass

func scene_start():
	if is_checkpoint():
		popped_balloon_names = checkpointed_balloon_names.duplicate()
	else:
		popped_balloon_names = []

func set_checkpoint(player : Node2D, checkpoint_path : String, cur_balloons = 0):
	#print('set to: ' + checkpoint_path)
	checkpoint_node_path = checkpoint_path
	checkpoint_position = player.position
	checkpoint_balloons = cur_balloons
	checkpointed_balloon_names = popped_balloon_names.duplicate()

func unset_checkpoint():
	checkpoint_node_path = ''
	checkpointed_balloon_names = []
	popped_balloon_names = []

func get_checkpoint_position() -> Vector2:
	return checkpoint_position

func get_checkpoint_node_path() -> String:
	return checkpoint_node_path
	
func get_checkpoint_balloons() -> String:
	return checkpoint_balloons

func is_checkpoint() -> bool:
	if len(checkpoint_node_path) > 0:
		return true
	return false


func add_popped_balloons(amount : int):
	popped_balloon_total += amount
	print(popped_balloon_total)

func reset_balloons():
	popped_balloon_total = 0

func get_popped_total() -> int:
	return popped_balloon_total


func pop_balloon_name(name : String) -> void:
	popped_balloon_names.append(name)

func is_balloon_name_popped(name : String) -> bool:
	return checkpointed_balloon_names.has(name)