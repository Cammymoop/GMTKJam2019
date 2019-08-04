extends Node2D

export (NodePath) var dropoff_point

export var pachinko = false
export var pachinko_distance = 200

export (NodePath) var pachinko_cam

func _ready():
	if pachinko:
		$Grabber.set_pachinko(pachinko_distance, pachinko_cam)

func get_dropoff_node() -> NodePath:
	return dropoff_point