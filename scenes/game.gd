extends Node2D

var player_turn : bool = true
var accept_move : bool = false
var current_player : CharacterBody2D

func _ready():
	handle_turns(player_turn)

func handle_turns(is_player_turn : bool) -> void:
	if is_player_turn:
		player_phase()
		return
	
	enemy_phase()

func player_phase() -> void:	
	print("Player Phase")
	await get_tree().create_timer(2.0).timeout
	for node in get_tree().get_nodes_in_group("player"):
		current_player = node
		accept_move = true
		print(node.name)
		node.action()
		await node.move_done
	
	player_turn = false
	handle_turns(player_turn)
	
func enemy_phase() -> void:
	print("Enemy Phase")
	accept_move = false
	await get_tree().create_timer(2.0).timeout
	for node in get_tree().get_nodes_in_group("enemy"):
		print(node.name)
		node.action()
		await node.move_done
	
	player_turn = true
	handle_turns(player_turn)
