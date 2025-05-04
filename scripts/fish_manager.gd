class_name FishManager
extends Node


signal fish_caught(fish: Fish)
signal game_over


@export var initial_cursor_speed: float = 100;
@export var cursor_speedup: float = 1
@export var show_fish_duration: float = 1.0
@export var round_duration: float = 99


@export_group("Dependencies")
@export var fishing_bar: FishingBar
@export var fish_get: FishGet
@export var restart_button: Button
@export var fish_settings: FishSettings
@export var score_label: Label
@export var fish_sfx: AudioStreamPlayer
@export var time_label: Label


var showing_fish: bool = false
var score: int = 0
var round_time: float = 0


func _ready() -> void:
	restart_button.pressed.connect(restart)
	restart()


func restart():
	fishing_bar.is_paused = false
	fishing_bar.cursor_speed = initial_cursor_speed
	score = 0
	round_time = round_duration
	update_score_label()


func update_score_label():
	score_label.text = str(score)


func _process(delta: float) -> void:
	fishing_bar.cursor_speed += cursor_speedup * delta
	if round_time > 0:
		round_time -= delta
		if round_time <= 0:
			fishing_bar.is_paused = true
			game_over.emit()
			round_time = 0
		time_label.text = str(int(round_time))
	else:
		# Stop when the time is over
		return
	
	if not showing_fish and Input.is_action_just_pressed("ui_accept"):
		fishing_bar.is_paused = true
		var fish_tier = fishing_bar.get_segment_at_cursor().tier
		var fishes = fish_settings.get_fishes_of_tier(fish_tier)
		var winning_fish: Fish = fishes.pick_random()
		fish_caught.emit(winning_fish)
		fish_get.show_fish(winning_fish)
		score += fish_tier.score
		showing_fish = true
		fish_sfx.play()
		await get_tree().create_timer(show_fish_duration).timeout
		showing_fish = false
		update_score_label()
		fish_get.hide_fish()
		fishing_bar.is_paused = false
		fishing_bar.create_segments()
