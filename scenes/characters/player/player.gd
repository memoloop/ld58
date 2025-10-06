extends CharacterBody2D
class_name Player

var speed: float = 100.0
var gripping_speed: float = 10.0
var direction: Vector2 = Vector2.ZERO
var last_direction: String = "down"
var animation_direction: String = "down"
var animation_name: String = "idle"
var collector_list: Array[Collector] = []
var hp: float = 30.0
var targeted_by_cop: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast: RayCast2D = $RayCast2D

func _physics_process(_delta):
	# Movement
	direction.x = Input.get_axis("walk_left", "walk_right")
	direction.y = Input.get_axis("walk_up", "walk_down")

	# Apply velocity
	velocity.x = direction.x * speed
	velocity.y = direction.y * speed
	move_and_slide()

	get_direction_as_string()
	set_raycast_direction()
	get_raycast_collision()
	give_position_to_collectors()

	# Animation
	match last_direction:
			"right":
				animation_direction = "side"
				animated_sprite.flip_h = false
			"left":
				animation_direction = "side"
				animated_sprite.flip_h = true
			"down": animation_direction = "down"
			"up": animation_direction = "up"
	if direction != Vector2.ZERO: animation_name = "walk"
	else: animation_name = "idle"
	animated_sprite.play(animation_name + "_" + animation_direction)

func get_direction_as_string():
	if direction.x > 0: last_direction = "right"
	elif direction.x < 0: last_direction = "left"
	elif direction.y > 0: last_direction = "down"
	elif direction.y < 0: last_direction = "up"

func set_raycast_direction():
	match last_direction:
		"down":
			ray_cast.target_position = Vector2(0, 10)
		"up":
			ray_cast.target_position = Vector2(0, -10)
		"left":
			ray_cast.target_position = Vector2(-10, 0)
		"right":
			ray_cast.target_position = Vector2(10, 0)

func get_raycast_collision():
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		if Input.is_action_pressed("interact"):
			if collider is Collector:
				if Global.collection_stuffs >= 5:
					collider.is_enlisted = true
					collider.collision_layer = 2
					collider.collision_mask = 2
					collider.z_index = -1
					collector_list.append(collider)
					collider.target = "player"
					Global.collectors += 1
					Global.money += collider.money
					Global.collection_stuffs -= 5

			if collider is Shelf:
				collider.progress -= gripping_speed

func give_position_to_collectors():
	var index = 0
	for collector in collector_list:
		if collector != null: collector.player_position = global_position
		else: collector_list.remove_at(index)
		index += 1
