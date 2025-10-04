extends CharacterBody2D

var speed: float = 100.0
var direction: Vector2 = Vector2.ZERO
var last_direction: String = "down"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(_delta):
    # Movement
    direction.x = Input.get_axis("walk_left", "walk_right")
    direction.y = Input.get_axis("walk_up", "walk_down")

    # Apply velocity
    velocity.x = direction.x * speed
    velocity.y = direction.y * speed
    move_and_slide()

    # Animation
    if direction != Vector2.ZERO:
        animated_sprite.play("walk_" + get_direction_as_string())
    else:
        animated_sprite.play("idle_" + get_direction_as_string())

func get_direction_as_string() -> String:
    if direction.x != 0: 
        last_direction = "side"
        if direction.x > 0: animated_sprite.flip_h = false
        if direction.x < 0: animated_sprite.flip_h = true
    elif direction.y > 0: last_direction = "down"
    elif direction.y < 0: last_direction = "up"
    return last_direction