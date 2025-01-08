@tool
extends Area2D


enum pickups{AMMO, HEALTH,STAM}
@export var item :pickups
var health_texture=preload("res://Assets/Assets/Icons/fish_01b.png")
var stam_texture=preload("res://Assets/Assets/Icons/fish_01e.png")
var ammo_texture=preload("res://Assets/Assets/Icons/bulletUP.png")
@onready var sprite =$Sprite2D

func _ready():
		if not Engine.is_editor_hint():
			if item==pickups.HEALTH:
				sprite.set_texture(health_texture)
			elif item==pickups.STAM:
				sprite.set_texture(stam_texture)
			elif item==pickups.AMMO:
				sprite.set_texture(ammo_texture)
func _process(delta):
		if  Engine.is_editor_hint():
			if item==pickups.HEALTH:
				sprite.set_texture(health_texture)
			elif item==pickups.STAM:
				sprite.set_texture(stam_texture)
			elif item==pickups.AMMO:
				sprite.set_texture(ammo_texture)


func _on_body_entered(body):
	if body.name =="player":
		queue_free()
