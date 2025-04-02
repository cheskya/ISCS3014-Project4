extends CanvasLayer

@onready var action_list = $ActionMenu/MarginContainer/ActionList
@onready var attack_list = $ActionMenu/MarginContainer/AttackList
@onready var skills_list = $ActionMenu/MarginContainer/SkillsList
@onready var action_log = $ActionLog
@onready var action_log_text = $ActionLog/MarginContainer/CenterContainer/Label
@onready var game = $".."

signal move_received(name, data)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	skills_list.hide()
	attack_list.hide()
	action_log.hide()
	action_list.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_action_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if (index == 0): # select attack menu
		action_list.hide()
		if (attack_list.is_anything_selected() == true):
			attack_list.deselect_all()
		attack_list.show()
	elif (index == 1): # select skills menu
		action_list.hide()
		if (skills_list.is_anything_selected() == true):
			skills_list.deselect_all()
		skills_list.show()
	elif (index == 2) and game.accept_move:
		emit_signal("move_received", action_list.get_item_text(index), game.current_player)


func _on_attack_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if (index == 0): # select go back to actions menu
		attack_list.hide()
		if (action_list.is_anything_selected() == true):
			action_list.deselect_all()
		action_list.show()
		return
	
	if game.accept_move:
		emit_signal("move_received", attack_list.get_item_text(index), game.current_player)

func _on_skills_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if (index == 0): # select go back to actions menu
		skills_list.hide()
		if (action_list.is_anything_selected() == true):
			action_list.deselect_all()
		action_list.show()
		return
	
	if game.accept_move:
		emit_signal("move_received", skills_list.get_item_text(index), game.current_player)


func change_action_log(text: String):
	action_log_text.set_text(text)
	action_log.show()
	pass
