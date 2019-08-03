extends AnimatedSprite

var collected = false

var accel = 20
var vel = 0

func _process(delta):
	if collected:
		position.y -= vel * delta
		vel += accel
		if position.y < -400:
			queue_free()

func _on_Area2D_body_entered(body):
	collected = true
	
	var tmap = find_parent("Root").find_node("TileMapPlayerOnly")
	
	for x in range(0, 178):
		for y in range(-17, 100):
			if tmap.get_cell(x, y) == 2:
				tmap.set_cell(x, y, 0)
