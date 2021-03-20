extends KinematicBody2D

const TARGET_FPS = 60

var gravity : int = 30
var y_force : int = gravity
var movement : Vector2 = Vector2.ZERO

var accel : int = 14
var decel : int = accel * 2
var max_speed : int = 400
var max_air_speed : int = max_speed * .8
var wall_impulse : int = 0
var wall_slip : int = 0
var wall_collisions : int = 0
var deadzone_speed : float = 3
var jump_force : int = 900


var direction : int = RIGHT
var wall_direction : int = RIGHT

enum {
	LEFT = -1,
	RIGHT = 1
}

var air_accel : int = accel * .8

var pressed_jump : bool = false


var state : int = IDLE
var prev_state : int = IDLE
enum {
	IDLE,
	WALKING,
	JUMPING,
	FALLING,
	ATTACKING,
	WALL_GRABBING,
	DASHING,
	DEAD
}

var anim_state : Dictionary = {
	IDLE : "idle",
	WALKING : "walk",
	JUMPING : "jump",
	FALLING : "fall",
	ATTACKING : "",
	WALL_GRABBING : "wall_grab",
	DASHING : "dash",
}

signal state_changed(prev_state, state)

# animation state machine
onready var anim_state_machine = $animation_tree.get("parameters/playback")


func _ready() -> void:
	
	# camera
	var cam_limit_1 : Position2D = get_parent().get_node("cam_limit_left_top")
	var cam_limit_2 : Position2D = get_parent().get_node("cam_limit_right_bottom")
	if cam_limit_1 != null && cam_limit_2 != null:
		$camera.limit_left = cam_limit_1.position.x
		$camera.limit_top = cam_limit_1.position.y
		$camera.limit_right = cam_limit_2.position.x
		$camera.limit_bottom = cam_limit_2.position.y
	
	#label
	$label.text = str(state)
	$timer_label.text = "%d:%02d" % [player_data.minutes, player_data.seconds]
	
	# connect state_changed to animation_player function
	connect("state_changed", self, "_on_state_changed")
	player_data.connect("time_changed", self, "_on_player_data_time_changed")
	


func check_ground() -> bool:
	return is_on_floor()


func check_direction() -> void:
	if movement.x > 0 : direction = RIGHT
	if movement.x < 0 : direction = LEFT


func is_wall_colliding() -> bool:
	var collisions = 0
	for raycast in $left_wall.get_children():
		collisions += raycast.get_overlapping_bodies().size()
	for raycast in $right_wall.get_children():
		collisions += raycast.get_overlapping_bodies().size()
	return true if collisions > 0 else false

func _change_state(next_state : int) -> void:
	if next_state == DASHING:
		$sounds/dash.play()
	if next_state == JUMPING:
		$sounds/jump.play()
	prev_state = state
	state = next_state
	emit_signal("state_changed", prev_state, state)


func _physics_process(delta) -> void:
	$sprite.flip_h = true if direction == LEFT else false
	$sprite.offset.x = -8 if direction == LEFT else 0
	
	match state:
		IDLE:
			idle(delta)
			$label.text = "IDLE"
		WALKING:
			walk(delta)
			$label.text = "WALKING"
		JUMPING:
			jump(delta)
			$label.text = "JUMPING"
		FALLING:
			fall(delta)
			$label.text = "FALLING"
		ATTACKING:
			attack(delta)
		WALL_GRABBING:
			wall_grab(delta)
			$label.text = "WALL_GRABBING"
		DASHING:
			dash(delta)
			$label.text = "DASHING"
		DEAD:
			pass
	movement.y += y_force
	movement = move_and_slide(movement * delta * TARGET_FPS, Vector2.UP, true)


func _input(event):
	if Input.is_action_just_released("jump"):
		pressed_jump = false
	
	# debug purpose: die
#	if event is InputEventKey:
#		if event.as_text() == "D":
#			die()


func idle(delta) -> void:
	wall_slip = 0
	wall_impulse = 0
	movement.x = 0
	
	if !check_ground() && $coyote_time.is_stopped():
		$coyote_time.start()
#		state = FALLING
	if Input.is_action_pressed("walk_left") || Input.is_action_pressed("walk_right"):
		prev_state = state
		_change_state(WALKING)
	if Input.is_action_just_pressed("jump"):
		apply_jump()
		_change_state(JUMPING)
	if Input.is_action_just_pressed("dash"):
		$dash_timer.start()
		_change_state(DASHING)


func walk(delta) -> void:
	check_direction()
	wall_slip = 0
	wall_impulse = 0
	var input_run : bool = Input.is_action_pressed("walk_left") || Input.is_action_pressed("walk_right")
	
	if !is_on_floor() && $coyote_time.is_stopped():
		$coyote_time.start()
#		_change_state(FALLING)
	
	if !input_run:
		
		if abs(movement.x) > 0:
			movement.x += decel * -direction
		if abs(movement.x) <= decel: movement.x = 0
		if movement.x == 0:
			_change_state(IDLE)
	
#	if Input.is_action_just_released("walk_left") || Input.is_action_just_released("walk_right"):
#		state = IDLE
	
	if Input.is_action_pressed("walk_right"):
		if movement.x < 0:
			movement.x += accel * 3
		movement.x += accel
		
	if Input.is_action_pressed("walk_left"):
		if movement.x > 0:
			movement.x -= accel * 3
		movement.x -= accel
		
	
	if movement.x >= max_speed:
			movement.x = max_speed
	if movement.x <= -max_speed:
			movement.x = -max_speed
	
	if Input.is_action_just_pressed("jump"):
		apply_jump()
		_change_state(JUMPING)
	
	if Input.is_action_just_pressed("dash"):
		$dash_timer.start()
		_change_state(DASHING)


func jump(delta) -> void:
	check_direction()
	wall_slip = 0
#	if check_ground():
#		apply_jump()
	if movement.y > 0:
		_change_state(FALLING)
	
	if Input.is_action_pressed("walk_left"):
		movement.x -= air_accel if movement.x <= 0 else air_accel * 4
		if movement.x < -max_air_speed - wall_impulse:
			movement.x = -max_air_speed - wall_impulse
	if Input.is_action_pressed("walk_right"):
		movement.x += air_accel if movement.x >= 0 else air_accel * 4
		if movement.x > max_air_speed + wall_impulse:
			movement.x = max_air_speed + wall_impulse
	
	
	if Input.is_action_just_released("jump"):
		movement.y /= 2


func apply_jump() -> void:
	movement.y = -jump_force


func fall(delta) -> void:
	wall_slip = 0
	if check_ground():
		if movement.x == 0:
			_change_state(IDLE)
		else:
			_change_state(WALKING)
#		state = IDLE if movement.x == 0 else WALKING
	
	if is_on_wall():
		wall_direction = get_slide_collision(0).normal.x
		y_force = gravity / 10
		movement.y /= 2
		_change_state(WALL_GRABBING)
	
	if Input.is_action_pressed("walk_left"):
		direction = LEFT
		movement.x -= air_accel if movement.x <= 0 else air_accel * 4
		if movement.x < -max_air_speed - wall_impulse:
			movement.x = -max_air_speed - wall_impulse
	if Input.is_action_pressed("walk_right"):
		direction = RIGHT
		movement.x += air_accel if movement.x >= 0 else air_accel * 4
		if movement.x > max_air_speed + wall_impulse:
			movement.x = max_air_speed + wall_impulse
	
#	direction = RIGHT if movement.x > 0 else LEFT


func attack(delta) -> void:
	pass


func wall_grab(delta) -> void:
	
	if direction == LEFT:
		$sprite.offset.x = -10
	else:
		$sprite.offset.x = 0
	
#	var collisions = 0
#	for raycast in $left_wall.get_children():
#		collisions += raycast.get_overlapping_bodies().size()
#	for raycast in $right_wall.get_children():
#		collisions += raycast.get_overlapping_bodies().size()
#	print(collisions)
	
	if !is_wall_colliding():
		y_force = gravity
		_change_state(FALLING)
	var slip_increase : int = 20
	var max_slip : int = 300
	wall_impulse = 100
	if check_ground():
		y_force = gravity
		_change_state(IDLE)
	
	var player_direction : int = direction
	if Input.is_action_pressed("walk_left"):
		player_direction = LEFT
	elif Input.is_action_pressed("walk_right"):
		player_direction = RIGHT
	
	if player_direction != -wall_direction:
		
		wall_slip += slip_increase
	
	if wall_slip >= max_slip:
		y_force = gravity
		$sprite.offset.x = 0
		_change_state(FALLING)
	
	if Input.is_action_just_pressed("jump"):
		y_force = gravity
		movement.x = jump_force * wall_direction / 3
		direction = RIGHT if movement.x > 0 else LEFT
		apply_jump()
		$sprite.offset.x = 0
		_change_state(JUMPING)
	
	if Input.is_action_just_pressed("dash"):
		direction = wall_direction
		$dash_timer.start()
		$sprite.offset.x = 0
		_change_state(DASHING)


func dash(delta) -> void:
	movement.x = max_speed * 3 * direction
	movement.y = 0
	y_force = 0


func die() -> void:
	$death_ui.show()
	$death_ui/container/deaths.text = "%02d" % player_data.deaths
	$death_ui/tween.interpolate_property($death_ui/container, "rect_scale", Vector2.ZERO, Vector2.ONE, .3, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$death_ui/tween.start()
	player_data.deaths += 1
	$sounds/die.play()
	$hurt_area/collision_shape_2d.disabled = true
	movement = Vector2.ZERO
	state = DEAD
	y_force = 0
	$sprite.hide()
	$dying_particles.show()
	$dying_particles.emitting = true
	$dead_timer.start()
	$death_ui/timer.start()


#func _on_player_tree_entered() -> void:
#	ui_main.emit_signal("player_entered")
#
#
#func _on_player_tree_exited() -> void:
#	ui_main.emit_signal("player_exited")


func _on_dash_timer_timeout() -> void:
	if state == DEAD:
		return
	y_force = gravity
	movement.x = max_speed * direction
	_change_state(FALLING)


func _on_state_changed(prev_state, state) -> void:
#	print("%s to %s" % [anim_state[prev_state], anim_state[state]])
	anim_state_machine.travel(anim_state[self.state])
#	if anim_state_machine.get_current_node() == anim_state[prev_state]:
#		anim_state_machine.travel(anim_state[state])


func _on_coyote_time_timeout():
	if state == DASHING:
		return
	if !check_ground() && movement.y >= 0:
		_change_state(FALLING)


func _on_checkpoint_checker_area_entered(area):
	if area.name == "exit_area":
		area.get_parent().emit_signal("exiting_area")
		player_data.spawn_direction = direction
	elif area.name == "checkpoint_area":
		area.get_parent().emit_signal('checkpoint_grabbed')
		player_data.spawn_direction = direction

func _on_cam_limits_changed():
	var trans_interpolation : int = Tween.TRANS_SINE
	var trans_ease : int = Tween.EASE_OUT
	var trans_time : float = 2
	var cam_limit_1 : Position2D = get_parent().get_node("cam_limit_left_top")
	var cam_limit_2 : Position2D = get_parent().get_node("cam_limit_right_bottom")
	if cam_limit_1 != null && cam_limit_2 != null:
#		$camera.limit_left = cam_limit_1.position.x
#		$camera.limit_top = cam_limit_1.position.y
#		$camera.limit_right = cam_limit_2.position.x
#		$camera.limit_bottom = cam_limit_2.position.y
		$camera/tween.interpolate_property($camera, "limit_left", $camera.limit_left, cam_limit_1.position.x, trans_time, trans_interpolation, trans_ease)
		$camera/tween.interpolate_property($camera, "limit_top", $camera.limit_top, cam_limit_1.position.y, trans_time, trans_interpolation, trans_ease)
		$camera/tween.interpolate_property($camera, "limit_right", $camera.limit_right, cam_limit_2.position.x, trans_time, trans_interpolation, trans_ease)
		$camera/tween.interpolate_property($camera, "limit_bottom", $camera.limit_bottom, cam_limit_2.position.y, trans_time, trans_interpolation, trans_ease)
		$camera/tween.start()


func _on_hint_checker_area_entered(area):
	if area.name == "hint_gift_area":
		area.get_parent().emit_signal("player_entered")


func _on_hint_checker_area_exited(area):
	if area.name == "hint_gift_area":
		area.get_parent().emit_signal("player_exited")


func _on_dead_timer_timeout():
	get_tree().reload_current_scene()


func _on_hurt_area_area_entered(area):
	if state != DEAD:
		die()


func _on_player_data_time_changed():
	$timer_label.text = "%d:%02d" % [player_data.minutes, player_data.seconds]


func _on_death_ui_timer_timeout():
	$death_ui/tween.interpolate_property($death_ui/container/deaths, "rect_scale", Vector2.ZERO, Vector2.ONE, .3, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$death_ui/tween.start()
	$death_ui/container/deaths.text = "%02d" % player_data.deaths
