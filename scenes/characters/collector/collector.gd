extends CharacterBody2D
class_name Collector

var is_enlisted: bool = false
var direction: Vector2 = Vector2.ZERO
var speed: float = 80.0
var gripping_speed: float = 10.0
var can_grip: bool = false
var player_position: Vector2 = Vector2.ZERO
var shelf_position: Vector2 = Vector2.ZERO
var target_shelf: Shelf = null
var target_cop: Cop = null
var cop_position: Vector2 = Vector2.ZERO
var target: String = "nobody" # Can be "player" or "shelf" or "cop"
var targeted_by_cop: bool = false
@export var money: int = 10
@export var hp: float = 20.0
@export var attack: float = 2.5

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(_delta):
    if is_enlisted:
        process_when_enlisted()
    else:
        direction = Vector2.ZERO

    # Animation
    if target == "player": animated_sprite.flip_h = direction.x < 0
    if direction.x != 0: animated_sprite.play("walk")
    else: animated_sprite.play("idle")

func process_when_enlisted():
    # Follow the target by his direction
    if target == "cop" and target_cop != null:
        direction = (cop_position - global_position).normalized()
    elif target == "player":
        direction = (player_position - global_position).normalized()
    elif target == "shelf":
        direction = (shelf_position - global_position).normalized()

    death()

    # Grip stuffs on shelf
    if can_grip:
        if target_shelf != null:
            target_shelf.progress -= gripping_speed
            if target_shelf.progress <= 0.0:
                target = "player"
                target_shelf = null

    # Apply velocity
    velocity = direction * speed
    move_and_slide()

func _on_shelf_research_area_body_entered(body: Node2D):
    if is_enlisted and body is Shelf and target != "shelf":
        if not body.is_empty and not body.targeted_by_collector:
            target = "shelf"
            shelf_position = body.global_position
            body.targeted_by_collector = true

func _on_shelf_gripping_area_body_entered(body: Node2D):
    if is_enlisted and target == "shelf" and body is Shelf:
        if not body.is_empty:
            target_shelf = body
            can_grip = true

func death():
    if hp <= 0.0:
        queue_free()
        Global.collectors -= 1