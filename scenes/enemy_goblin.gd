extends CharacterBody2D

@onready var ui_node = $"../UI"

signal move_done(data)

func _ready():
	add_to_group("enemy")

func action():
	var move_name : String
	
	var first_move : int = randi_range(0, 2)
	if first_move == 2: # defend
		move_name = ui_node.action_list.get_item_text(first_move)
		ui_node.change_action_log(self.name + " did " + move_name)
		await get_tree().create_timer(2.0).timeout
		emit_signal("move_done", move_name)
		return
	
	if first_move == 0: # attack
		var second_move : int = randi_range(1, ui_node.attack_list.item_count-1)
		move_name = ui_node.attack_list.get_item_text(second_move)
	else: # skill
		var second_move : int = randi_range(1, ui_node.skills_list.item_count-1)
		move_name = ui_node.skills_list.get_item_text(second_move)
	ui_node.change_action_log(self.name + " did " + move_name)
	
	await get_tree().create_timer(2.0).timeout
	emit_signal("move_done", move_name)
