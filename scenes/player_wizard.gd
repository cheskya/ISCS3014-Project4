extends CharacterBody2D

@onready var game = $".."
@onready var ui_node = $"../UI"
@onready var health_label = $HealthLabel

signal move_done
signal move_wait

var attacks = ["Bonk"]
var skills = ["Lightning", "Acid"]

var health = 10


func _ready():
	ui_node.move_received.connect(player_move)
	self.move_wait.connect(action)
	add_to_group("player")
	health_label.text = str(health)


func player_move(name, data, target):
	if self == data:
		game.accept_move = false
		ui_node.disable_menu()
		game.player_moves.append([self.name, name, target])
		emit_signal("move_wait")


func action() -> void:
	await self.move_wait
	await get_tree().create_timer(1.0).timeout
	emit_signal("move_done")


func get_attacks():
	return attacks


func get_skills():
	return skills
