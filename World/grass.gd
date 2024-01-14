extends Node2D

const grassEffectScene = preload("res://Effects/grass_effect.tscn")

@export var item: InvItem
var player = null

func create_grass_effect():
	var grassEffectInstance = grassEffectScene.instantiate()
	get_parent().add_child(grassEffectInstance)
	grassEffectInstance.global_position = global_position

func _on_hurt_box_area_entered(area):
	if player != null:
		create_grass_effect()
		queue_free()
		player.collect(item)


func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		player = body
