extends StaticBody2D
class_name Shelf

var is_empty: bool = false
@export var progress: float = 100.0

@onready var sprite: Sprite2D = $Sprite2D

func _process(_delta):
    if not is_empty and progress <= 0.0:
        is_empty = true
        sprite.region_rect = Rect2(48, 0, 48, 62)