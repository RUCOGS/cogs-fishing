extends Node


@export var fish: Fish
@export var fish_get: FishGet


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		fish_get.show_fish(fish)
