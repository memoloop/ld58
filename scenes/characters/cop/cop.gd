extends CharacterBody2D
class_name Cop

@export var attack: float = 5.0
@export var hp: float = 10.0
@export var money: int = 50
var speed: float = 75.0
var direction: Vector2 = Vector2.ZERO
var target = "nobody" # Can be "player" or "collector"
var target_player: Player = null
var target_collector: Collector = null

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_timer: Timer = $AttackTimer

func _physics_process(_delta):
	# Animation
	animated_sprite.flip_h = direction.x < 0
	if direction != Vector2.ZERO: animated_sprite.play("walk")
	else: animated_sprite.play("idle")

	give_position_to_collector()

	# Follow target
	match target:
		"player":
			if target_player != null: direction = (target_player.global_position - position).normalized()
		"collector":
			if target_collector != null: direction = (target_collector.global_position - position).normalized()
		"nobody":
			direction = Vector2.ZERO

	death()

	# Apply velocity
	velocity = direction * speed
	move_and_slide()

func _on_find_collector_area_body_entered(body: Node2D):
	if body is Player: 
		target = "player"
		target_player = body
		body.targeted_by_cop = true
	elif body is Collector:
		target = "collector"
		body.target = "cop"
		target_collector = body
		body.cop_position = global_position
		body.targeted_by_cop = true

func _on_attack_area_body_entered(body: Node2D):
	if body is Player or body is Collector:
		attack_timer.start()
		if body is Collector: target_collector.attack_timer.start()

func _on_attack_timer_timeout():
	if target == "collector" and target_collector != null and target_collector.targeted_by_cop:
		target_collector.hp -= attack
	elif target == "player" and target_player != null and target_player.targeted_by_cop:
		target_player.hp -= attack
	attack_timer.start()

func _on_find_collector_area_body_exited(body: Node2D):
	if body is Player:
		target_player = null
		body.targeted_by_cop = false
		target = "nobody"
	elif body is Collector:
		target_collector = null
		body.targeted_by_cop = false
		body.target = "player"
		target = "nobody"

func death():
	if hp <= 0.0:
		Global.money += money
		queue_free()

func give_position_to_collector():
	if target_collector != null and target == "collector":
		target_collector.cop_position = global_position