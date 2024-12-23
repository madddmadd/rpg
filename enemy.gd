extends CharacterBody2D

var speed = 205.0
var direction: Vector2
var new_direction = Vector2(0, 1)
var rng = RandomNumberGenerator.new()
var timer = 0
@onready var player = $"../player"
@onready var animated_sprite = $animated_sprite
@onready var animation_player = $AnimationPlayer
var animation: String
var is_attacking = false
@onready var bullet_scene =preload("res://bullet.tscn")
var bullet_damage=5
var bullet_reload=100
var bullet_tsf=1
var health = 100
var max_health = 100
var regen_health=.5
func _ready():
	rng.randomize()
func _physics_process(delta):
	var movement = speed * direction * delta
	var collision = move_and_collide(movement)

	if collision != null and collision.get_collider().name != "player":
		direction = direction.rotated(rng.randf_range(PI / 4, PI / 2))
		timer = rng.randf_range(2, 5)
	else:
		timer = 0

	if !is_attacking:
		enemyDirection(direction)  # Call with the current direction

func _on_timer_timeout():
	if player != null:
		var player_distance = player.position - position
		if player_distance.length() <= 50:
			new_direction = player_distance.normalized()
		elif player_distance.length() <= 500 and timer <= 0:
			direction = player_distance.normalized()
		elif timer <= 0:
			var random_direction = rng.randf()
			if random_direction < 0.05:
				direction = Vector2.ZERO
			elif random_direction < 0.1:
				direction = Vector2.DOWN.rotated(rng.randf() * 2 * PI)

func enemyDirection(direction: Vector2):
	if direction != Vector2.ZERO:
		new_direction = direction
		animation = "walk_" + returnedDirection(new_direction)
		animated_sprite.play(animation)
	else:
		animation = "idle_" + returnedDirection(direction)
		animated_sprite.play(animation)

func returnedDirection(direction: Vector2):
	var normalized_direction = direction.normalized()
	var default_return = "down"

	if abs(normalized_direction.x) > abs(normalized_direction.y):
		# If the X direction is more significant, prioritize sideways movement
		if normalized_direction.x > 0:
			animated_sprite.flip_h = false  # Facing right
			return "right"
		elif normalized_direction.x < 0:
			animated_sprite.flip_h = true   # Facing left
			return "right"
	else:
		# Otherwise, handle up/down movement based on the Y component
		if normalized_direction.y > 0:
			return "down"
		elif normalized_direction.y < 0:
			return "up"

	return default_return
func _on_animated_sprite_animation_finished():
	is_attacking = false
func _process(delta):
	# Regenerate health and stamina every tick, ensuring they don't exceed their max values
	health = clamp(health + regen_health * delta, 0,max_health)
func hit(damage):
	health-=bullet_damage
	
	if health>0:
		direction=Vector2.ZERO
		animation_player.play("damage")
		animated_sprite.play("hit")
		await get_tree().create_timer(2).timeout
		pass
	else:
		queue_free()
