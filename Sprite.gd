extends AnimatedSprite

var facing = "right"

var is_holding = false
var current_anim = 'stand'

var dummy_starting_y

func _ready():
	dummy_starting_y = $DummyCrate.position.y

func get_facing() -> String:
	return facing

func set_holding(h : bool) -> void:
	is_holding = h
	$DummyCrate.visible = h
	play_anim(current_anim)

func play_anim(anim_name : String) -> void:
	current_anim = anim_name
	if is_holding:
		anim_name += "_hold"
	play(anim_name)
	_on_Sprite_frame_changed()

func set_facing(f : String) -> void:
	facing = f
	var kick_box = get_node('../KickBox')
	if facing == "right":
		flip_h = false
		offset.x = 1
		kick_box.position.x = 10
	else:
		flip_h = true
		offset.x = 0
		kick_box.position.x = -8

func _on_Sprite_frame_changed():
	if not is_holding:
		return
	
	if current_anim == 'jump' or (current_anim == 'walk' and frame == 0):
		$DummyCrate.position.y = dummy_starting_y - 2
	else:
		$DummyCrate.position.y = dummy_starting_y
