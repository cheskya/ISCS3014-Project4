extends CharacterBody2D

@onready var ui_node = $"../UI"

signal move_done(data)

func _ready():
	add_to_group("enemy")

func action():
	var move_name : String
	var target_name : String
	
	var first_move : int = randi_range(0, 2)
	if first_move == 0 or first_move == 1: # attack or skill
		var second_move : int = randi_range(1, ui_node.attack_list.item_count-1)
		move_name = ui_node.attack_list.get_item_text(second_move)
	else: # defend
		move_name = ui_node.action_list.get_item_text(first_move)
		ui_node.change_action_log(self.name + " did " + move_name)
		await get_tree().create_timer(2.0).timeout
		emit_signal("move_done", move_name)
		return
	var target : int = randi_range(0, get_tree().get_node_count_in_group("player")-1)
	target_name = get_tree().get_nodes_in_group("player")[target].name
	ui_node.change_action_log(self.name + " did " + move_name + " to " + target_name)
	
	await get_tree().create_timer(2.0).timeout
	emit_signal("move_done", move_name)
