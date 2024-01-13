extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var chase = false
var player
var SPEED = 70
var JUMP_VELOCITY = 300
var BOUNCE_VELOCITY = 200
var READY_COOLDOWN = 1.5
var death_animation = preload("res://enemy_death.tscn")
var ready_action = true	

@onready var anim = get_node("Ani")
@onready var jump_timer = get_node("jump_timer")

func _ready():
	anim.play("Idle")
	
func _physics_process(delta):
	if anim.animation != "Death":
		if not is_on_floor():
			velocity.y += gravity * delta
		player = get_node("../../player/player")
		var direction = (player.position - self.position).normalized()
		if velocity.y > 0:
			anim.play("Fall")
		if chase && is_on_floor() && ready_action:
			ready_action = false
			jump(direction)
		elif is_on_floor():
			velocity.x = 0
			anim.play("Idle")

		if is_on_floor() && jump_timer.is_stopped() && not ready_action:
			start_landing_timer()

	move_and_slide()
	
func _on_area_2d_body_entered(body):
	if body.name == "player":
		chase = true
func _on_area_2d_body_exited(body):
	if body.name == "player":
		chase = false

func _on_play_death_body_entered(body):
	if body.name == "player":
		body.velocity.y = -BOUNCE_VELOCITY
		Death()

func _on_play_hit_body_entered(body):
	if body.name == "player":
		Game.playerHP -= 5
		Death()
		
func Death():
	Game.playerGold += 5
	Utils.saveGame()
	chase = false
	velocity.x = 0
	velocity.y = 0
	var tempAnimation = death_animation.instantiate()
	tempAnimation.position = self.global_position
	get_node("../..").add_child(tempAnimation)
	self.queue_free()

func jump(direction):
	if direction.x > 0:
		get_node("Ani").flip_h = true
	else:
		get_node("Ani").flip_h = false
	velocity.y = -JUMP_VELOCITY
	velocity.x = direction.x * SPEED
	get_node("Ani").play("Jump")


func start_landing_timer():
	if jump_timer.is_stopped():
		jump_timer.start(READY_COOLDOWN)


func _on_jump_timer_timeout():
	ready_action = true
