extends CanvasLayer

@onready var action_list = $ActionMenu/MarginContainer/ActionList
@onready var attack_list = $ActionMenu/MarginContainer/AttackList
@onready var skills_list = $ActionMenu/MarginContainer/SkillsList
@onready var enemy_list = $ActionMenu/MarginContainer/EnemyList
@onready var action_log = $ActionLog
@onready var action_log_text = $ActionLog/MarginContainer/CenterContainer/Label
@onready var game = $".."

signal move_received(name, data)

var is_from_attack : bool = false
var current_action : String
var current_target : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	skills_list.hide()
	attack_list.hide()
	enemy_list.hide()
	action_log.hide()
	action_list.show()
	for node in get_tree().get_nodes_in_group("enemy"):
		enemy_list.add_item(node.name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_action_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if (index == 0): # select attack menu
		action_list.hide()
		action_list.deselect_all()
		attack_list.show()
	elif (index == 1): # select skills menu
		action_list.hide()
		action_list.deselect_all()
		skills_list.show()
	elif (index == 2) and game.accept_move:
		action_list.deselect_all()
		emit_signal("move_received", action_list.get_item_text(index), game.current_player)


func _on_attack_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if (index == 0): # select go back to actions menu
		attack_list.hide()
		attack_list.deselect_all()
		action_list.show()
		return
	else: # select any attack
		attack_list.hide()
		attack_list.deselect_all()
		current_action = attack_list.get_item_text(index)
		enemy_list.set_item_text(0, "Back to Attacks")
		is_from_attack = true
		enemy_list.show()


func _on_skills_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if (index == 0): # select go back to actions menu
		skills_list.hide()
		skills_list.deselect_all()
		action_list.show()
		return
	else: # select any skill
		skills_list.hide()
		skills_list.deselect_all()
		current_action = attack_list.get_item_text(index)
		enemy_list.set_item_text(0, "Back to Skills")
		is_from_attack = false
		enemy_list.show()


func _on_enemy_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if (index == 0 && is_from_attack): # select go back to attack menu
		enemy_list.hide()
		enemy_list.deselect_all()
		attack_list.show()
		return
	elif (index == 0 && not is_from_attack): # select go back to skills menu
		enemy_list.hide()
		enemy_list.deselect_all()
		skills_list.show()
		return
	else:
		enemy_list.hide()
		enemy_list.deselect_all()
		action_list.show()
	
	if game.accept_move:
		emit_signal("move_received", current_action, game.current_player)


func change_action_log(text: String):
	action_log_text.set_text(text)
	action_log.show()
	pass
