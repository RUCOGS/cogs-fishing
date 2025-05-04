class_name FishGet
extends Control


@export var _animation_player: AnimationPlayer
@export var _name_label: Label
@export var _description_label: Label
@export var _texture_rect: TextureRect
@export var _fish_container: Control
@export var _fish_vbox: Control
@export var _bg_texture: Control
@export var _points_label: Label


func _ready() -> void:
	visible = false
	


func show_fish(fish: Fish):
	_name_label.text = fish.name
	_description_label.text = fish.name
	_animation_player.play("show")
	_texture_rect.texture = fish.texture
	_fish_container.set_anchors_and_offsets_preset(Control.PRESET_CENTER_LEFT)
	_fish_vbox.set_anchors_and_offsets_preset(Control.PRESET_CENTER_LEFT)
	await get_tree().process_frame
	_bg_texture.modulate = fish.tier.color
	_bg_texture.modulate.a = 0.5
	_points_label.text = "+%s" % fish.tier.score
	visible = true


func hide_fish():
	_animation_player.play("hide")
