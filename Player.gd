extends KinematicBody2D

export var run_speed = 100
export var jump_velocity = 220

export var gravity = 9

export var crate_throw_impulse : Vector2 = Vector2(120, -190)
export var crate_kick_impulse : Vector2 = Vector2(220, -30)

export var next_scene : PackedScene

var found_crate : RigidBody2D = null
var found_kick_crate : RigidBody2D = null
var crate_held : bool = false

var crate_scene : PackedScene = preload("res://Crate.tscn")

var suspend = false

var buffer_jump = 0
var crate_jump_prevent = false

var r_crate
var r_root : Node2D

var y_velocity = 0

var on_ground = false

var BOX_LAYER = 1


func _ready():
	r_root = find_parent("Root")
	r_crate = r_root.find_node("Crate")

# warning-ignore:unused_argument
func _physics_process(delta):
	var move_vector = 0
	if not suspend:
		if Input.is_action_pressed("move_left"):
			move_vector -= run_speed
		if Input.is_action_pressed("move_right"):
			move_vector += run_speed
		
	if not on_ground and Input.is_action_just_released("action_jump"):
		if y_velocity < 0:
			y_velocity = 6
	
	var old_y = y_velocity
	y_velocity = y_velocity + gravity
	
	if not suspend:
		if (buffer_jump > 0 or on_ground) and Input.is_action_just_pressed("action_jump") and not crate_jump_prevent:
			y_velocity = -jump_velocity
			on_ground = false
			buffer_jump = 0
			$Sprite.play_anim("jump")
	
	if buffer_jump > 0:
		buffer_jump -= 1
	
	var movement = Vector2(move_vector, y_velocity)
	var resulting_velocity = move_and_slide(movement, Vector2(0, 1), false, 4, 0.78, false)
	
	y_velocity = resulting_velocity.y
	if not on_ground and y_velocity == 0 and old_y >= 0:
		if crate_jump_prevent:
			crate_jump_prevent = false
		on_ground = true
		$Sprite.play_anim("stand")
	
	
	if on_ground:
		if not suspend:
			if abs(resulting_velocity.x) > 0:
				$Sprite.play_anim("walk")
			else:
				$Sprite.play_anim("stand")
		
		if y_velocity > 0 and not crate_jump_prevent:
			on_ground = false
			buffer_jump = 8
			$Sprite.play_anim('jump')
	
	if resulting_velocity.x != 0:
		var new_facing = "left" if resulting_velocity.x < 0 else "right"
		if new_facing != $Sprite.get_facing():
			$Sprite.set_facing(new_facing)

# warning-ignore:unused_argument
func _process(delta):
	if position.y > 830:
		reset_game()
	
	if Input.is_action_just_pressed("action_reset"):
		reset_game()
	
	if crate_held and Input.is_action_just_pressed("action_grab"):
		throw_crate()
	if crate_held and Input.is_action_just_pressed("action_kick"):
		throw_crate(true)
	
	if found_crate and Input.is_action_just_pressed("action_grab"):
		pickup_crate()
	if found_crate and Input.is_action_just_pressed("action_kick"):
		kick_the_crate()
	
	if Input.is_action_just_pressed("fullscreen_button"):
		OS.window_fullscreen = not OS.window_fullscreen

func pickup_crate():
	if y_velocity < 0 and (r_crate.position.y - position.y) > 29:
		return # crate jump prevention
	crate_held = true
	$Sprite.set_holding(true)
	r_crate.queue_free()
	crate_jump_prevent = true
	on_ground = false

func throw_crate(kick : bool = false):
	crate_held = false
	$Sprite.set_holding(false)
	r_crate = crate_scene.instance()
	r_crate.position = position
	
	var set_down = on_ground and Input.is_action_pressed("move_down")
	
	if set_down:
		position.y -= 15
		r_crate.position.y += 15
	else:
		if kick:
			r_crate.position.y += 15
		else:
			r_crate.position.y -= 17
		
		var facing = $Sprite.get_facing()
		var imp = crate_throw_impulse if not kick else crate_kick_impulse
		if facing == "left":
			imp.x = - imp.x
		
		r_crate.apply_impulse(r_crate.position, imp)
	r_root.add_child(r_crate)
	
	if kick:
		start_kick_anim()

func kick_the_crate():
	var imp = crate_kick_impulse
	if $Sprite.get_facing() == "left":
		imp.x = - imp.x
	r_crate.apply_impulse(r_crate.position, imp)
	start_kick_anim()

func start_kick_anim():
	$Sprite.play('kick')
	suspend = true
	$KickTimer.start()
	set_collision_mask_bit(BOX_LAYER, false)

func reset_game() -> void:
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()

func _on_GrabBox_body_entered(body):
	found_crate = body

func _on_GrabBox_body_exited(body):
	found_crate = null

func end() -> void:
	if not next_scene:
		return
	if crate_held:
# warning-ignore:return_value_discarded
		get_tree().change_scene_to(next_scene)


func _on_KickTimer_timeout():
	$Sprite.play_anim('stand')
	suspend = false
	set_collision_mask_bit(BOX_LAYER, true)

func _on_KickBox_body_entered(body):
	found_kick_crate = body

func _on_KickBox_body_exited(body):
	found_kick_crate = null
