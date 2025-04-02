extends Node2D

var player_turn : bool = true
var accept_move : bool = false
var current_player : CharacterBody2D
var player_moves : Array = []
var enemy_moves : Array = []
@onready var ui = $UI

var is_menu_disabled : bool = false

func _ready():
	handle_turns(player_turn)
	ui.disable_menu()


func _process(float) -> void:
	pass


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
		ui.enable_menu()
		ui.change_attack_list(node.get_attacks())
		ui.change_skills_list(node.get_skills())
		ui.change_action_log(node.name + "'s Turn")
		node.action()
		await node.move_done
	

	for move in player_moves:
		var player_name = move[0]
		var player_action = move[1]
		var player_target = move[2]
		if player_target != null:
			ui.change_action_log(player_name + " did " + player_action + " to " + player_target)
			# calculate damage here
			var action_info = find_child(player_name).get_action_info(player_action)
			if "Uses" in action_info and action_info["Uses"] < 0:
				pass
			if action_info["Target"] == 1:
				find_child(player_target).deplete_health(action_info["Damage"])
			else:
				for enemy in get_tree().get_nodes_in_group("enemy"):
					enemy.deplete_health(action_info["Damage"])
			if action_info.has("Uses"):
				action_info["Uses"] -= 1
				
		else:
			ui.change_action_log(move[0] + " did " + move[1])
		await get_tree().create_timer(2.0).timeout
	
	player_turn = false
	handle_turns(player_turn)
	
func enemy_phase() -> void:
	ui.change_action_log("Enemy Phase")
	accept_move = false
	
	enemy_moves = []
	
	await get_tree().create_timer(2.0).timeout
	for node in get_tree().get_nodes_in_group("enemy"):
		ui.change_action_log(node.name + "'s Turn")
		await get_tree().create_timer(1.0).timeout
		node.action()
		await node.move_done
	
	for move in enemy_moves:
		if move[2] != null:
			ui.change_action_log(move[0] + " did " + move[1] + " to " + move[2])
		else:
			ui.change_action_log(move[0] + " did " + move[1])
		await get_tree().create_timer(2.0).timeout
	
	player_turn = true
	handle_turns(player_turn)
