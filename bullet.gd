extends Area2D
var direction : Vector2
var speed = 900
var damage =5
@onready var animated_sprite=$AnimatedSprite2D
@onready var tilemap = get_tree().root.get_node("Level/TileMap")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	position = position+speed*delta*direction
	
	

func _on_body_entered(body):
	if body.name == "player":
		return
	if body.name== "Tilemap":
		if body.get_layer_name("building"):
			pass
	if body.is_in_group("enemies"):
		body.hit(damage)
		pass
	direction=Vector2.ZERO
	animated_sprite.play("hit")
	

func _on_timer_timeout():
	animated_sprite.play("hit")



func _on_animated_sprite_2d_animation_finished():
	queue_free()






func _on_hit_enemy():
	pass # Replace with function body.
