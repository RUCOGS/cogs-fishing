class_name FishingTier
extends Resource


@export var name: String
@export var color: Color
@export var point_scale: float = 1.0
@export var probability = 0.5
@export var bar_size: Vector2 = Vector2.ONE
@export var score: int

func sample_bar_size() -> float:
	return randf_range(bar_size.x, bar_size.y)
