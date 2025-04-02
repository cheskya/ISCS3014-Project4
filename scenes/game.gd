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
			await get_tree().create_timer(1.0).timeout
			# calculate damage here
			var action_info = find_child(player_name).get_action_info(player_action)
			if "Uses" in action_info and action_info["Uses"] <= 0:
				ui.change_action_log("No uses left of " + player_action + "!")
				pass
			if action_info["Target"] == 1:
				if find_child(player_target) != null:
					if find_child(player_target).is_defending:
						find_child(player_target).deplete_health(action_info["Damage"]/2)
					else:
						find_child(player_target).deplete_health(action_info["Damage"])
					if find_child(player_target).health <= 0:
						ui.change_action_log(find_child(player_target).name + " died!")
						find_child(player_target).queue_free()
						await get_tree().create_timer(1.0).timeout
			else:
				for enemy in get_tree().get_nodes_in_group("enemy"):
					if enemy != null:
						if enemy.is_defending:
							enemy.deplete_health(action_info["Damage"]/2)
						else:
							enemy.deplete_health(action_info["Damage"])
						if enemy.health <= 0:
							ui.change_action_log(enemy.name + " died!")
							enemy.queue_free()
							await get_tree().create_timer(1.0).timeout
			if action_info.has("Uses"):
				action_info["Uses"] -= 1
				
		else:
			ui.change_action_log(move[0] + " did " + move[1])
		await get_tree().create_timer(2.0).timeout
	
	if get_tree().get_node_count_in_group("enemy") == 0:
		await get_tree().create_timer(1.0).timeout
		end_screen(true)
		return
	
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.is_defending = false
	
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
		
		if node.has_acid < 2 and node.has_acid != -1:
			node.has_acid += 1
			if node.has_acid == 2:
				node.has_acid = -1
			for player in get_tree().get_nodes_in_group("player"):
				if player.name == "Wizard":
					node.deplete_health(player.actions["Skill"]["Acid"]["Damage"])
					ui.change_action_log(node.name + " got hit by Acid!")
					await get_tree().create_timer(1.0).timeout
					if node.health <= 0:
						ui.change_action_log(node.name + " died!")
						node.queue_free()
						await get_tree().create_timer(1.0).timeout
					break
		
		if node != null:
			node.action()
			await node.move_done
	
	for move in enemy_moves:
		var enemy_name = move[0]
		var enemy_action = move[1]
		var enemy_target = move[2]
		if enemy_target != null:
			ui.change_action_log(enemy_name + " did " + enemy_action + " to " + enemy_target)
			await get_tree().create_timer(1.0).timeout
			# calculate damage here
			var action_info = find_child(enemy_name).get_action_info(enemy_action)
			if "Uses" in action_info and action_info["Uses"] <= 0:
				ui.change_action_log("No uses left of " + enemy_action + "!")
				pass
			if action_info["Target"] == 1:
				if find_child(enemy_target) != null:
					if find_child(enemy_target).is_defending:
						find_child(enemy_target).deplete_health(action_info["Damage"]/2)
					else:
						find_child(enemy_target).deplete_health(action_info["Damage"])
					if find_child(enemy_target).health <= 0:
						ui.change_action_log(find_child(enemy_target).name + " died!")
						find_child(enemy_target).queue_free()
						await get_tree().create_timer(1.0).timeout
			else:
				for player in get_tree().get_nodes_in_group("player"):
					if player != null:
						if player.is_defending:
							player.deplete_health(action_info["Damage"]/2)
						else:
							player.deplete_health(action_info["Damage"])
						if player.health <= 0:
							ui.change_action_log(player.name + " died!")
							player.queue_free()
							await get_tree().create_timer(1.0).timeout
			if action_info.has("Uses"):
				action_info["Uses"] -= 1
				
		else:
			ui.change_action_log(move[0] + " did " + move[1])
		await get_tree().create_timer(2.0).timeout
	
	if get_tree().get_node_count_in_group("player") == 0:
		await get_tree().create_timer(1.0).timeout
		end_screen(false)
		return
	
	for player in get_tree().get_nodes_in_group("player"):
		player.is_defending = false
	
	player_turn = true
	handle_turns(player_turn)

func end_screen(is_player_win: bool) -> void:
	if is_player_win:
		ui.change_action_log("Game Over, You Win!")
	else:
		ui.change_action_log("Game Over, You Lose.")
	get_tree().paused = true
