extends CharacterBody2D
class_name Collector

var is_enlisted: bool = false
var direction: Vector2 = Vector2.ZERO
var speed: float = 80.0
var player_position: Vector2 = Vector2.ZERO

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(_delta):
    if is_enlisted:
        process_when_enlisted()
    else:
        direction = Vector2.ZERO

    # Animation
    animated_sprite.flip_h = direction.x < 0
    if direction.x != 0: animated_sprite.play("walk")
    else: animated_sprite.play("idle")

func process_when_enlisted():
    # Follow the player by his direction
    direction = (player_position - position).normalized()

    # Apply velocity
    velocity.x = direction.x * speed
    velocity.y = direction.y * speed
    move_and_slide()