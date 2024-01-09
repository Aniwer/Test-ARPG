extends Node2D

const grassEffectScene = preload("res://Effects/grass_effect.tscn")

func create_grass_effect():
	var grassEffectInstance = grassEffectScene.instantiate()
	get_parent().add_child(grassEffectInstance)
	grassEffectInstance.global_position = global_position

func _on_hurt_box_area_entered(area):
	create_grass_effect()
	queue_free()
