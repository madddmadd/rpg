extends Node2D
@onready var stamina_value=$%stamina
@onready var health_value=$%health
@onready var player=$player
@onready var ammo_label=$CanvasLayer/panel/ammo/HBoxContainer2/Label2
@onready var heal_label=$CanvasLayer/panel/revives/HBoxContainer2/Label3
@onready var stam_label=$CanvasLayer/panel/stamina_pot/HBoxContainer2/Label4
func _ready():
	player.updated_staminabar.connect(_on_player_updated_staminabar)
	player.updated_healthbar.connect(_on_player_updated_healthbar)
	player.ammo_amount_upd.connect(_on_player_ammo_amount_upd)
func _process(delta):
	pass






func _on_player_updated_healthbar(health,max_health):
	pass

func _on_player_updated_staminabar(stamina,max_stamina):
	stamina_value.value = 100 *stamina/max_stamina
func _on_player_ammo_amount_upd(ammo_amount):
	print("Updating ammo amount: " + str(ammo_amount))
	ammo_label.text = str(ammo_amount)
