extends CharacterBody2D

var ui_node

signal move_done(data)

func _ready():
	ui_node = get_node("../UI")
	add_to_group("enemy")

func action():
	var move_name : String
	
	var first_move : int = randi_range(0, 2)
	if first_move == 2:
		await get_tree().create_timer(2.0).timeout
		move_name = ui_node.action_list.get_item_text(first_move)
		print(self.name, " did ", move_name)
		emit_signal("move_done", move_name)
		return
	
	if first_move == 0:
		var second_move : int = randi_range(1, ui_node.attack_list.item_count-1)
		move_name = ui_node.attack_list.get_item_text(second_move)
		print(self.name, " did " , move_name)
	else:
		var second_move : int = randi_range(1, ui_node.skills_list.item_count-1)
		move_name = ui_node.skills_list.get_item_text(second_move)
		print(self.name, " did " , move_name)
	
	await get_tree().create_timer(2.0).timeout
	emit_signal("move_done", move_name)
