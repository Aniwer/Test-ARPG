extends Area2D

var invincible : bool = false : set = set_invincible
@onready var timer = $Timer

signal invincible_started
signal invincible_ended

const hitEffectScene = preload("res://Effects/hit_effect.tscn")

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincible_started")
	else:
		emit_signal("invincible_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)
	
func create_hit_effect():
	var hitEffectInstance = hitEffectScene.instantiate()
	# Don't use get_parent here! Parent will be free!
	var main = get_tree().current_scene
	main.add_child(hitEffectInstance)
	hitEffectInstance.global_position = global_position

func _on_timer_timeout():
	# Must use self, to call set_invincible()
	self.invincible = false

func _on_invincible_started():
	# set_deferred("monitorable", false)
	set_deferred("monitoring", false)

func _on_invincible_ended():
	# monitorable = true
	set_deferred("monitoring", true)

