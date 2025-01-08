extends Node2D

@onready var Spawned_Enemies = $SpawnedEnemies
@onready var tilemap = $"../TileMap"

@onready var max_enemies =20
var enemy_count = 1
var rng = RandomNumberGenerator.new()



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func spawn_enemy():
	var attempts =0
	var new_attempts=100
	var spawned =false
	while not spawned and attempts <= new_attempts:
		var spawn_tiles=tilemap.get_used_cells(Global.SPAWN_LAYER)
		spawn_tiles.shuffle()
		var rand_pos2=spawn_tiles.pick_random()
		
		var rand_pos= Vector2(rng.randi()% tilemap.get_used_rect().size.x,rng.randi()% tilemap.get_used_rect().size.y)
		if is_valid_spawn_location(Global.SPAWN_LAYER, rand_pos2):
			var enemy = Global.enemy_scene.instantiate()
			enemy.position = tilemap.map_to_local(rand_pos2)+Vector2(tilemap.tile_set.tile_size.x,tilemap.tile_set.tile_size.y)/2
			Spawned_Enemies.add_child(enemy)
			spawned=true
		else:
			attempts+=1
	if attempts >= new_attempts:
		pass
func is_valid_spawn_location(layer,position):
	var spawn_coords = Vector2(position.x,position.y)
	
	if tilemap.get_cell_source_id(Global.SPAWN_LAYER,spawn_coords)!=-1:
		return true



func _on_timer_timeout():
	if enemy_count<max_enemies:
		spawn_enemy()
		enemy_count+=1
	
