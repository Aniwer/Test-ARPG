extends CharacterBody2D

const PlayerHurtSoundScene = preload("res://Player/player_hurt_sound.tscn")
const ACCELERATION = 500
const FRICTION = 500
const MAX_SPEED = 100
const ROLL_SPEED = 125
const INVINCIBLIITY_DURATION = 0.6

enum {
	MOVE,
	ROLL,
	ATTACK
}

var moving_state = MOVE
var roll_vector = Vector2.DOWN
var state = PlayerStates
var dialog = Dialog
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
# @onready var swordHitBox = $HitBoxPivot/SwordHitBox
@onready var hurtBox = $HurtBox
@onready var blinkAnimationPlayer = $BlinkAnimationPlayer
@export var inv: Inv

func _ready():
	# Make random seed different everytime
	randomize()
	state.connect("no_health", queue_free)
	animationTree.active = true

func _physics_process(delta):
	match moving_state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
	
	if dialog.del_player == true:
		queue_free()

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		# swordHitBox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move_and_slide()
	
	if Input.is_action_just_pressed("roll"):
		moving_state = ROLL
		
	if Input.is_action_just_pressed("attack"):
		moving_state = ATTACK
		

func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move_and_slide()

func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func roll_animation_finished():
	velocity = Vector2.ZERO
	moving_state = MOVE

func attack_animation_finished():
	moving_state = MOVE

func _on_hurt_box_area_entered(area):
	hurtBox.start_invincibility(INVINCIBLIITY_DURATION)
	hurtBox.create_hit_effect()
	var playHurtSound = PlayerHurtSoundScene.instantiate()
	get_tree().current_scene.add_child(playHurtSound)
	state.health -= area.damage
	
func _on_hurt_box_invincible_started():
	blinkAnimationPlayer.play("Start")
	
func _on_hurt_box_invincible_ended():
	blinkAnimationPlayer.play("Stop")
	
func player():
	pass
	
func collect(item):
	print(item)
	inv.insert(item)
