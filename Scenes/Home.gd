extends Control


@onready var p1 = $"VBoxContainer/1P"
@onready var p2 = $"VBoxContainer/2P"
@onready var p3 = $"VBoxContainer/3P"
@onready var p4 = $"VBoxContainer/4P"

var total_players = 4


func _ready():
	pass # Replace with function body.


func _on_players_toggled(button_pressed,players):
	if (!button_pressed):
		return
	match players:
		1:
			total_players = 1
			p2.button_pressed = false
			p3.button_pressed = false
			p4.button_pressed = false
		2:
			total_players = 2
			p1.button_pressed = false
			p3.button_pressed = false
			p4.button_pressed = false
		3:
			total_players = 3
			p2.button_pressed = false
			p1.button_pressed = false
			p4.button_pressed = false
		4:
			total_players = 4
			p2.button_pressed = false
			p3.button_pressed = false
			p1.button_pressed = false

func _on_Play_button_up():
	Global.total_players = total_players
	get_tree().change_scene_to_file('res://Scenes/Main.tscn')
