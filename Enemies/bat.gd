extends CharacterBody2D

const EnemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")
const KNOCK_BACK = 80
const WANDER_TIMER_DURATION = 3 
const INVINCIBLIITY_DURATION = 0.4

@export var ACCELERATION = 400
@export var FRICTION = 200
@export var MAX_SPEED = 100
@export var WANDER_TARGET_RANGE = 5

enum {
	IDLE,
	WANDER,
	CHASE,
}

var moving_state = CHASE
@onready var animatedSprite = $AnimatedSprite
@onready var state = $States
@onready var playerDetection = $PlayerDetection
@onready var hurtBox = $HurtBox
@onready var softCollision = $SoftCollison
@onready var wanderController = $WanderController
@onready var animationPlayer = $AnimationPlayer
@onready var particles = $GPUParticles2D

func _ready():
	moving_state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	match moving_state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
				
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
			accelerate_towards_point(wanderController.target_positon, delta)
			if global_position.distance_to(wanderController.target_positon) <= WANDER_TARGET_RANGE:
				update_wander()
			
		CHASE:
			var player = playerDetection.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				moving_state = IDLE
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * KNOCK_BACK
	move_and_slide()
	
func accelerate_towards_point(point, delta):
	# var direction = (player.global_position - global_position).normalized()
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	animatedSprite.flip_h = velocity.x < 0
	
func update_wander():
	moving_state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(randi_range(1, WANDER_TIMER_DURATION))
	
func create_enemy_death_effect():
	var enemyDeathEffectInstance = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffectInstance)
	enemyDeathEffectInstance.global_position = global_position
	
func seek_player():
	if playerDetection.can_see_player():
		moving_state = CHASE

func pick_random_state(state_list):
	return state_list.pick_random()

func _on_hurt_box_area_entered(area):
	# velocity = area.knockback_vector * KNOCK_BACK
	particles.emitting = true
	velocity = (area.global_position - global_position).normalized() * KNOCK_BACK
	hurtBox.create_hit_effect()
	hurtBox.start_invincibility(INVINCIBLIITY_DURATION)
	state.health -= area.damage


func _on_states_no_health():
	create_enemy_death_effect()
	queue_free()

func _on_hurt_box_invincible_started():
	animationPlayer.play("start")

func _on_hurt_box_invincible_ended():
	animationPlayer.play("stop")
