class_name Player
extends CharacterBody2D

static var instance: Player

const SPEED = 200
const JUMP_VELOCITY = -600

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var max_jumps = 2
var jumps_left = 2


func _enter_tree() -> void:
	instance = self


func _physics_process(delta):
	if is_on_floor():
		jumps_left = max_jumps

	if not is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta
	
	if Input.is_action_just_pressed("player_jump"):
		if is_on_floor() or jumps_left > 0:
			velocity.y = JUMP_VELOCITY
			jumps_left -= 1

	var direction = Input.get_axis("player_left", "player_right")

	if direction != 0:
		velocity.x = direction * SPEED
		if anim and anim.sprite_frames:
			anim.flip_h = (direction == -1)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	if anim and anim.sprite_frames:
		if not is_on_floor():
			if jumps_left == 0 and anim.sprite_frames.has_animation("double_jump"):
				anim.play("double_jump")
			elif anim.sprite_frames.has_animation("jump"):
				anim.play("jump")
			elif anim.sprite_frames.has_animation("Jump"):
				anim.play("Jump")
		elif direction != 0:
			if anim.sprite_frames.has_animation("run"):
				anim.play("run")
			elif anim.sprite_frames.has_animation("walk"):
				anim.play("walk")
		else:
			if anim.sprite_frames.has_animation("idle"):
				anim.play("idle")


func die():
	get_tree().change_scene_to_file("res://game_over.tscn")
