class_name FishingBar
extends PanelContainer

class FishingSegment:
	var tier: FishingTier
	var color_rect: ColorRect
	var bar_size: float

@export var fishing_segments_range: Vector2i
@export var cursor_speed: float = 10.0
@export var is_paused = false

var fishing_segments: Array[FishingSegment]

@export_group("Dependencies")
@export var _base_ui: Control
@export var _segments_container: Control
@export var _fishing_cursor: Control
@export var _fishing_cursor_offset: Vector2
@export var _fish_settings: FishSettings

var _total_segments_height: float
var _fishing_segments: Array[FishingSegment]
var _total_fishing_tier_probabilities: float
var _total_fishing_bar_size: float
var _total_cursor_dist: float = 0
var _fishing_cursor_global_start_offset: Vector2
var _fishing_cursor_parent: Control

func _ready() -> void:
	_total_segments_height = _segments_container.size.y
	_total_fishing_tier_probabilities = 0
	for tier in _fish_settings.tiers:
		_total_fishing_tier_probabilities += tier.probability
	await get_tree().process_frame
	_fishing_cursor_parent = _fishing_cursor.get_parent()
	_fishing_cursor_global_start_offset = _fishing_cursor.global_position - _fishing_cursor_parent.global_position
	_fishing_cursor.reparent(_base_ui)
	await get_tree().process_frame
	create_segments()


func _process(delta: float) -> void:
	if not is_paused:
		_total_cursor_dist += cursor_speed * delta
		_fishing_cursor.global_position = _fishing_cursor_parent.global_position + _fishing_cursor_global_start_offset + _fishing_cursor_offset + Vector2(0, pingpong(_total_cursor_dist, _total_segments_height))


func sample_fishing_tier() -> FishingTier:
	var rand_num = randf() * _total_fishing_tier_probabilities
	var cumulative_probability = 0
	for tier in _fish_settings.tiers:
		cumulative_probability += tier.probability
		# Move from smallest cumulative probability to largest
		# If we hit a cumulative probability that's >= rand_num, then we know the rand_num
		# falls within the range of this tier.
		if cumulative_probability >= rand_num:
			return tier
	return null


func create_segments():
	for child in _segments_container.get_children():
		child.queue_free()
	fishing_segments.clear()
	_total_fishing_bar_size = 0
	var count = randi_range(fishing_segments_range.x, fishing_segments_range.y)
	for i in range(count):
		var fishing_segment = FishingSegment.new()
		var color_rect = ColorRect.new()
		_segments_container.add_child(color_rect)
		var tier = sample_fishing_tier()
		
		fishing_segment.color_rect = color_rect
		fishing_segment.tier = tier
		fishing_segment.color_rect.color = tier.color
		fishing_segment.bar_size = tier.sample_bar_size()
		
		fishing_segments.append(fishing_segment)
		_total_fishing_bar_size += fishing_segment.bar_size
	# Normalize bar sizes and then mult by _total_segments_height
	for segment in fishing_segments:
		segment.bar_size = (segment.bar_size / _total_fishing_bar_size) * _total_segments_height 
		segment.color_rect.custom_minimum_size.y = segment.bar_size


func get_segment_at(y_pos: float) -> FishingSegment:
	var cumulative_size = 0
	print("get_segment_at")
	for segment in fishing_segments:
		print("   %s >= %s" % [cumulative_size, y_pos])
		cumulative_size += segment.bar_size
		if cumulative_size >= y_pos:
			return segment
	return null


func get_segment_at_cursor() -> FishingSegment:
	return get_segment_at(pingpong(_total_cursor_dist, _total_segments_height))
