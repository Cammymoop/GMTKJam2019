extends Node2D


func _on_Timer_timeout():
	var bonus_loader = get_node("/root/BonusLoader")
	var destination = bonus_loader.get_scene()
	
	if len(destination) > 0:
		get_tree().change_scene(destination)
