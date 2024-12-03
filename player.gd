extends CharacterBody2D

@export var speed = 200
@onready var animated_sprite = $animated_sprite
var new_direction: Vector2 = Vector2.ZERO
var animation: String
var is_attacking
var is_sprinting = false
var sprint_speed = 350
var speed_scale = "speed_scale"
var health = 100
var max_health = 100
var regen_health = 2
var stamina = 100
var max_stamina = 100
var regen_stamina = 5
var stamina_drain =10
@onready var bullet_scene =preload("res://bullet.tscn")
var bullet_damage=15
var bullet_reload=100
var bullet_tsf=1
var ammo_amount=18
signal updated_healthbar
signal ammo_amount_upd
signal updated_staminabar
func _physics_process(delta):
	var direction: Vector2 = Vector2.ZERO
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")

	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()

	var movement = direction * speed * delta
	if not is_attacking:
		move_and_collide(movement)
		playerDirection(direction)

func playerDirection(direction: Vector2):
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

	if normalized_direction.y > 0:
		return "down"
	elif normalized_direction.y < 0:
		return "up"
	elif normalized_direction.x > 0:
		animated_sprite.flip_h = false
		return "right"
	elif normalized_direction.x < 0:
		animated_sprite.flip_h = true
		return "right"

	return default_return

func _input(event):
	if event.is_action("shoot"):
		var now = Time.get_ticks_msec()
		if now >= bullet_tsf and ammo_amount > 0:
			is_attacking = true
			animation = "attack_" + returnedDirection(new_direction)
			animated_sprite.play(animation)
			bullet_tsf = now + bullet_reload
			ammo_amount = ammo_amount - 1
			ammo_amount_upd.emit(ammo_amount)
			var bullet = bullet_scene.instantiate()
			bullet.damage=bullet_damage
			bullet.direction = new_direction.normalized()
			bullet.position = position + new_direction.normalized() * 4
			get_tree().root.get_node("Level").add_child(bullet)
	if event.is_action_pressed("sprint"):
		if not is_sprinting and stamina > 0:  # Only toggle sprinting if there's stamina
			is_sprinting = true
			speed = sprint_speed
			animated_sprite.speed_scale = 2
			print("sprinting")
		elif is_sprinting:  # If sprinting is already active, toggle it off
			is_sprinting = false
			speed = 200
			animated_sprite.speed_scale = 1
			print("not sprinting")

func _process(delta):
	# Regenerate health and stamina every tick, ensuring they don't exceed their max values
	health = clamp(health + regen_health * delta, 0,max_health)
	updated_healthbar.emit(health, max_health)

	# Regenerate stamina
	stamina = clamp(stamina + regen_stamina * delta, 0,max_stamina)

	updated_staminabar.emit(stamina, max_stamina)
	
	# Sprinting logic (stamina drain and depletion)
	if is_sprinting:
		stamina -= stamina_drain * delta
	
		if stamina <= 0:
			is_sprinting = false  # Stop sprinting if stamina is depleted
			speed = 200
			animated_sprite.speed_scale = 1
			print("stamina depleted, stopped sprinting")    
func _on_animated_sprite_animation_finished():
	is_attacking= false
func _on_timer_timeout():
	if ammo_amount<18:
		ammo_amount+=1
		ammo_amount_upd.emit(ammo_amount)
