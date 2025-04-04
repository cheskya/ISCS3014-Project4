extends CanvasLayer

@onready var action_list = $ActionMenu/MarginContainer/ActionList
@onready var attack_list = $ActionMenu/MarginContainer/AttackList
@onready var skills_list = $ActionMenu/MarginContainer/SkillsList
@onready var enemy_list = $ActionMenu/MarginContainer/EnemyList
@onready var action_log = $ActionLog
@onready var action_log_text = $ActionLog/MarginContainer/CenterContainer/Label
@onready var game = $".."

signal move_received(name, data, target)

var is_from_attack : bool = false
var current_action : String
var current_target : String
var current_list : Node
var enemy_snapshot : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_menu(skills_list)
	hide_menu(attack_list)
	hide_menu(enemy_list)
	action_log.hide()
	show_menu(action_list)
	enemy_snapshot.append(null)
	for node in get_tree().get_nodes_in_group("enemy"):
		enemy_list.add_item(node.name)
		enemy_snapshot.append(node)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_action_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if (index == 0): # select attack menu
		hide_menu(action_list)
		show_menu(attack_list)
	elif (index == 1): # select skills menu
		hide_menu(action_list)
		show_menu(skills_list)
	elif (index == 2) and game.accept_move:
		action_list.deselect_all()
		emit_signal("move_received", action_list.get_item_text(index), game.current_player, null)
	elif (index == 3) and game.accept_move:
		action_list.deselect_all()
		emit_signal("move_received", null, game.current_player, null)


func _on_attack_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if (index == 0): # select go back to actions menu
		hide_menu(attack_list)
		show_menu(action_list)
		return
	else: # select any attack
		hide_menu(attack_list)
		current_action = attack_list.get_item_text(index)
		is_from_attack = true
		self.change_enemies_list(get_tree().get_nodes_in_group("enemy"), is_from_attack)
		show_menu(enemy_list)


func _on_skills_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if (index == 0): # select go back to actions menu
		hide_menu(skills_list)
		show_menu(action_list)
		return
	else: # select any skill
		hide_menu(skills_list)
		current_action = skills_list.get_item_text(index)
		is_from_attack = false
		self.change_enemies_list(get_tree().get_nodes_in_group("enemy"), is_from_attack)
		show_menu(enemy_list)


func _on_enemy_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if (index == 0 && is_from_attack): # select go back to attack menu
		hide_menu(enemy_list)
		show_menu(attack_list)
		return
	elif (index == 0 && not is_from_attack): # select go back to skills menu
		hide_menu(enemy_list)
		show_menu(skills_list)
		return
	else:
		hide_menu(enemy_list)
		current_target = enemy_list.get_item_text(index)
		show_menu(action_list)
	
	if game.accept_move:
		emit_signal("move_received", current_action, game.current_player, current_target)


func change_action_log(text: String):
	action_log_text.set_text(text)
	action_log.show()
	pass


func change_attack_list(list: Dictionary):
	attack_list.clear()
	attack_list.add_item("Back to Actions")
	for attack in list:
		attack_list.add_item(attack)
	

func change_skills_list(list: Dictionary):
	skills_list.clear()
	skills_list.add_item("Back to Actions")
	for skill in list:
		skills_list.add_item(skill)


func change_enemies_list(list: Array, is_attack: bool):
	enemy_list.clear()
	if is_attack:
		enemy_list.add_item("Back to Attacks")
	else:
		enemy_list.add_item("Back to Skills")

	for enemy in list:
		enemy_list.add_item(enemy.name)


func hide_menu(menu: Node):
	menu.hide()
	menu.deselect_all()


func show_menu(menu: Node):
	menu.show()
	current_list = menu


func disable_menu():
	var i = 0
	while i < current_list.item_count:
		current_list.set_item_disabled(i, true)
		i += 1


func enable_menu():
	var i = 0
	while i < current_list.item_count:
		current_list.set_item_disabled(i, false)
		i += 1
