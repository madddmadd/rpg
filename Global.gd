extends Node
@onready var bullet_scene= preload("res://bullet.tscn")
@onready var enemy_scene= preload("res://enemy.tscn")

var WATER_LAYER=0
var GROUND_LAYER=1
var BUILD_LAYER=2
var SPAWN_LAYER=3
