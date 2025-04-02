extends CharacterBody2D

@onready var game = $".."
@onready var ui_node = $"../UI"

signal move_done
signal move_wait

func _ready():
	ui_node.move_received.connect(player_move)
	self.move_wait.connect(action)
	add_to_group("player")

func player_move(name, data):
	if self == data:
		game.accept_move = false
		ui_node.change_action_log(self.name + " did " + name)
		emit_signal("move_wait")

func action() -> void:
	await self.move_wait
	await get_tree().create_timer(2.0).timeout
	emit_signal("move_done")
