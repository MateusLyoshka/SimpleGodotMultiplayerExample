extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _physics_process(_delta: float) -> void:
	if !is_multiplayer_authority(): return

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()
