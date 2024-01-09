extends CharacterBody2D

@onready var speakBox = $SpeakBox

func _process(delta):
	if len(speakBox.get_overlapping_bodies()) > 0 and Input.is_action_just_pressed("ui_accept"):
		DialogueManager.show_example_dialogue_balloon(load("res://NPC/Test.dialogue"), "hello")
