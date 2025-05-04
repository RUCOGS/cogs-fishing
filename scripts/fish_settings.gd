class_name FishSettings
extends Node


@export var fishes: Array[Fish]
@export var tiers: Array[FishingTier]

var tier_to_fishes: Dictionary[FishingTier, Array]


func _ready() -> void:
	tier_to_fishes = {}
	for tier in tiers:
		tier_to_fishes[tier] = []
	for fish in fishes:
		tier_to_fishes[fish.tier].append(fish)


func get_fishes_of_tier(tier: FishingTier) -> Array:
	return tier_to_fishes[tier]
