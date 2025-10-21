extends CharacterBody2D
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _physics_process(_delta):
	if !is_multiplayer_authority(): return

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if dir:
		velocity = dir * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()
