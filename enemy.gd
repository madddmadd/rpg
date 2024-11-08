extends CharacterBody2D

var speed = 200.0
var direction: Vector2
var new_direction = Vector2(0, 1)
var rng = RandomNumberGenerator.new()
var timer = 0
@onready var player = $"../player"
@onready var animated_sprite = $animated_sprite
var animation: String
var is_attacking = false

func _ready():
	rng.randomize()
	# Set up and start a Timer if needed here

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
