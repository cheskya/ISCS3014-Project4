extends Node2D

var player_turn : bool = true
var accept_move : bool = false
var current_player : CharacterBody2D
var player_moves : Array = []
@onready var ui = $UI

func _ready():
	handle_turns(player_turn)

func handle_turns(is_player_turn : bool) -> void:
	if is_player_turn:
		player_phase()
		return
	
	enemy_phase()

func player_phase() -> void:
	ui.change_action_log("Player Phase")
	
	player_moves = []
	
	await get_tree().create_timer(2.0).timeout
	for node in get_tree().get_nodes_in_group("player"):
		current_player = node
		accept_move = true
		ui.change_action_log(node.name + "'s Turn")
		node.action()
		await node.move_done

	for move in player_moves:
		ui.change_action_log(move[0] + " did " + move[1])
		await get_tree().create_timer(2.0).timeout
	
	player_turn = false
	handle_turns(player_turn)
	
func enemy_phase() -> void:
	ui.change_action_log("Enemy Phase")
	accept_move = false
	await get_tree().create_timer(2.0).timeout
	for node in get_tree().get_nodes_in_group("enemy"):
		ui.change_action_log(node.name + "'s Turn")
		await get_tree().create_timer(1.0).timeout
		node.action()
		await node.move_done
	
	player_turn = true
	handle_turns(player_turn)
