extends AnimatedSprite

var r_dropoff_point : Node2D

var grab_speed = 45
var grab_speed_2 = 60
var raise_speed = 60
var side_speed = 45
var reset_speed = 45


var crate_scene : PackedScene = preload("res://Crate.tscn")

var targeted_crate : RigidBody2D = null

var mode = 'standby'

var home = Vector2(0, 0)

var close_enough = 1.8

func _ready():
	home = global_position
	
	var dp_path = get_parent().get_dropoff_node()
	if not dp_path:
		dp_path = '../GrabDropoff'
	r_dropoff_point = get_parent().get_node(dp_path)

func _process(delta):
	if mode == 'standby' and targeted_crate:
		set_mode('grabbit')
	
	if mode == 'grabbit':
		if not targeted_crate:
			set_mode('reset')
			return
		
		var there = move_to(targeted_crate.position, grab_speed, grab_speed, false, delta)
		if there:
			set_mode('grabbed')
	elif mode == 'grabbed':
		var there = move_to(r_dropoff_point.position, raise_speed, side_speed, true, delta)
		if there:
			do_release()
			set_mode('reset')
	elif mode == 'reset':
		var there = move_to(home, reset_speed, reset_speed, false, delta)
		if there:
			set_mode('standby')

func move_to(pos, f_speed, s_speed, y_first : bool, delta) -> bool:
	var fp = pos.y if y_first else pos.x
	var fc = global_position.y if y_first else global_position.x
	var sp = pos.x if y_first else pos.y
	var sc = global_position.x if y_first else global_position.y
	
	var fset = 'global_position:' + ('y' if y_first else 'x')
	var sset = 'global_position:' + ('x' if y_first else 'y')
	
	var f_diff = abs(fp - fc)
	if f_diff > close_enough:
		if f_diff < (delta * f_speed):
			set_indexed(fset, fp)
		else:
			set_indexed(fset, fc + ((delta * f_speed) * sign(fp - fc)))
	else:
		set_indexed(fset, fp)
		var s_diff = abs(sp - sc)
		if s_diff > close_enough:
			if s_diff < (delta * s_speed):
				set_indexed(sset, sp)
				return true
			else:
				set_indexed(sset, sc + ((delta * s_speed) * sign(sp - sc)))
		else:
			set_indexed(sset, sp)
			return true
	return false

func set_mode(new_mode):
	mode = new_mode
	if mode == 'grabbed':
		do_grab()
	if mode == 'reset':
		show_release()
	
	if mode == 'grabbit':
		play('no_grab')
	if mode == 'standby':
		play('grab')

func do_grab() -> void:
	targeted_crate.queue_free()
	show_grab()
func show_grab() -> void:
	$DummyCrate.visible = true
	play('grab')

func do_release() -> void:
	var c = crate_scene.instance()
	c.position = global_position
	find_parent('Root').add_child(c)
	show_release()
func show_release() -> void:
	$DummyCrate.visible = false
	play('no_grab')

func _on_CrateDetector_body_entered(body):
	targeted_crate = body

func _on_CrateDetector_body_exited(body):
	targeted_crate = null