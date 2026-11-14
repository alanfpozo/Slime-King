extends CharacterBody2D

const SPEED = 125
const JUMP_VELOCITY = -550

@onready var anim = $"Animated sprite2D"

var max_jumps = 2
var jumps_left = 2

func _physics_process(delta):
	if is_on_floor():
		jumps_left = max_jumps

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up"):
		if is_on_floor() or jumps_left > 0:
			velocity.y = JUMP_VELOCITY
			jumps_left -= 1

	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * SPEED
		if direction == 1:
			anim.flip_h = false
		elif direction == -1:
			anim.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	if not is_on_floor():
		if jumps_left == 0 and anim.sprite_frames.has_animation("double_jump"):
			anim.play("double_jump")
			anim.speed_scale = 2.0
		else:
			anim.play("Jump")
			anim.speed_scale = 1.0
	elif direction != 0:
		anim.play("walk")
		anim.speed_scale = 1.0
	else:
		anim.play("idle")
		anim.speed_scale = 1.0
