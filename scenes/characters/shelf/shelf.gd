extends StaticBody2D
class_name Shelf

var is_empty: bool = false
@export var progress: float = 100.0
@export var collection_stuffs = 30

@onready var sprite: Sprite2D = $Sprite2D

func _process(_delta):
    if not is_empty and progress <= 0.0:
        is_empty = true
        sprite.region_rect = Rect2(48, 0, 48, 62)
        Global.collection_stuffs += collection_stuffs