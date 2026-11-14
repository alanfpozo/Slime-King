class_name Knight
extends CharacterBody2D

@export var speed := 100.0

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D

var player: Player


func _ready() -> void:
	player = Player.instance
	
	
func _physics_process(delta: float) -> void:
	velocity = speed * global_position.direction_to(player.global_position)
	velocity.y = 0
	move_and_slide()

	animated_sprite_2d.flip_h = velocity.x < 0
	animated_sprite_2d.animation = "idle" if velocity.is_zero_approx() else "run"


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.die()
