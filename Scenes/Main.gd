extends Node2D


@onready var players = [$PlayersPath/blue_player1,$PlayersPath/green_player2,$PlayersPath/red_player3,$PlayersPath/yellow_player4]
@onready var dice_faces = $DiceFaces
@onready var moving_dice = $MovingDice
@onready var players_path = $PlayersPath
@onready var ladders_path = $LaddersPath
@onready var snakes_path = $SnakesPath
@onready var timer = $Timer
@onready var ladder_timer = $LadderTimer
@onready var snake_timer = $SnakeTimer
@onready var toast = $Toast
@onready var toast_timer = $ToastTimer
@onready var turn_timer = $TurnTimer
@onready var dice_base_1 = $DiceBase
@onready var dice_base_2 = $DiceBase2
@onready var dice_base_3 = $DiceBase3
@onready var dice_base_4 = $DiceBase4
@onready var green_player_2 = $PlayersPath/green_player2
@onready var red_player_3 = $PlayersPath/red_player3
@onready var yellow_player_4 = $PlayersPath/yellow_player4

@onready var dice_audio = $DiceAudio
@onready var snake_audio = $SnakeAudio
@onready var ladder_audio = $LadderAudio
@onready var move_audio = $MoveAudio


signal stop_taking_steps
signal stop_climbing_ladder


@export var dice_no = 1

var can_roll_dice = 1
var dice_pos = [264,1721,264,203,823,203,823,1721] #dice position of different player
var player_unlocked = [0,0,0,0] #tells whether player is unlocked or not
var cur_dice_face = 0 
var turn = 0
var player_pos = [-1,-2,-3,-4] #range is 0-99
var scale_player = [0,0,0,0]

var ladder_bottom_pos = [1,8,24,29,38,44,50,64,78,88]
var ladder_top_pos = [17,27,46,49,40,56,72,84,97,90]
var snake_mouth_pos = [26,37,51,61,65,89,92,94,96,98]
var snake_tail_pos = [4,16,32,59,45,69,66,74,57,80]

var ladder_message = ['Use approved seed (ਸਿਫਾਰਸ਼ੀ ਬੀਜ ਵਰਤੋ)','Complete sowing before 15 May (ਪੂਰੀ ਬਿਜਾਈ 15 ਮਈ ਤੋਂ ਪਹਿਲਾਂ ਕਰੋ)','For Bt varieties, prefer heavy dark soil (ਬੀ ਟੀ ਕਿਸਮਾਂ ਲਈ ਕਾਲੀ ਭਾਰੀ ਮਿੱਟੀ ਵਰਤੋ)','sufficient nutrient supply from organic resources (ਜੈਵਿਕ ਸਰੋਤਾਂ ਤੋਂ ਲੋੜੀਂਦੀ ਪੌਸ਼ਟਿਕ ਤੱਤਾਂ ਦੀ ਪੂਰਤੀ)','Do not let the water stand in the fields (ਖੇਤਾਂ ਵਿੱਚ ਪਾਣੀ ਖੜ੍ਹਾ ਨਾ ਹੋਣ ਦਿਓ)','Avoid growing Okra, Moong, Arhar in the neighbouring field (ਆਂਢ-ਗੁਆਂਢ ਦੇ ਖੇਤ ਵਿੱਚ ਭਿੰਡੀ, ਮੂੰਗ, ਅਰਹਰ ਉਗਾਉਣ ਤੋਂ ਬਚੋ)','Sufficient and timely water management (ਲੋੜੀਂਦਾ ਅਤੇ ਸਮੇਂ ਸਿਰ ਪਾਣੀ ਪ੍ਰਬੰਧਨ)','Timely discussion with PAU scientists and seek their advice (ਪੀਏਯੂ ਦੇ ਵਿਗਿਆਨੀਆਂ ਨਾਲ ਸਮੇਂ ਸਿਰ ਚਰਚਾ ਕਰੋ ਅਤੇ ਉਨ੍ਹਾਂ ਦੀ ਸਲਾਹ ਲਓ)','Apply fertilizers in recommended dosage (ਖਾਦਾਂ ਨੂੰ ਸਿਫ਼ਾਰਸ਼ ਕੀਤੀ ਮਾਤਰਾ ਵਿੱਚ ਪਾਓ)','After last picking leave the cattle for grazing (ਆਖਰੀ ਚੁਗਾਈ ਤੋਂ ਬਾਅਦ ਪਸ਼ੂ ਚਰਾਉਣ ਲਈ ਛੱਡ ਦਿਓ)']
var snake_message = ['Growing non recommended varieties (ਗ਼ੈਰ ਸਿਫਾਰਿਸ਼ ਬੀਜਾਂ ਦੀ ਵਰਤੋਂ)','Application of raw undecomposed FYM (ਕੱਚੀ ਰੂੜੀ ਖਾਦ ਦੀ ਵਰਤੋਂ ਕਰਨਾ)','Using bad quality water for irrigation purpose (ਸਿੰਚਾਈ ਲਈ ਖਰਾਬ ਗੁਣਵੱਤਾ ਵਾਲੇ ਪਾਣੀ ਦੀ ਵਰਤੋਂ ਕਰਨਾ)','Delay in irrigation (ਸਿੰਚਾਈ ਵਿੱਚ ਦੇਰੀ)','Non-roughing off infected plants (ਖ਼ਰਾਬ ਹੋਏ ਬੂਟਿਆਂ ਨੂੰ ਨਾ ਪੁੱਟਣਾ)','Use of non recommended pesticides (ਗੈਰ ਸਿਫ਼ਾਰਸ਼ ਕੀਤੇ ਕੀਟਨਾਸ਼ਕਾਂ ਦੀ ਵਰਤੋਂ)','Inappropriate dosages of pesticides(ਕੀਟਨਾਸ਼ਕ ਦੀਆਂ ਅਣਉਚਿਤ ਖੁਰਾਕਾਂ)','Use of contaminated spray equipment (ਦੂਸ਼ਿਤ ਸਪਰੇਅ ਉਪਕਰਨਾਂ ਦੀ ਵਰਤੋਂ)','Negligence in handling of pests and diseases (ਕੀੜਿਆਂ ਅਤੇ ਬਿਮਾਰੀਆਂ ਨਾਲ ਨਜਿੱਠਣ ਵਿੱਚ ਲਾਪਰਵਾਹੀ)','Delay in picking (ਨਰਮਾ ਚੁਗਣ ਵਿਚ ਦੇਰੀ)']

var ladder_path_start_pos = [0,3,7,12,16,20,24,29,34,38]
var ladder_path_end_pos = [2,6,11,15,19,23,28,33,37,41]
var snake_path_start_pos = [0,10,18,28,35,45,57,70,80,96]
var snake_path_end_pos = [9,17,27,34,44,56,69,79,95,103]


var step = 0
var ladder_index = -1
var snake_index = -1

func _ready():
	moving_dice.hide()
	set_total_players()

func set_total_players():
	match Global.total_players:
		1:
			dice_base_2.visible = false
			dice_base_3.visible = false
			dice_base_4.visible = false
			
			green_player_2.visible = false
			red_player_3.visible = false
			yellow_player_4.visible = false
		2:
			dice_base_2.visible = true
			dice_base_3.visible = false
			dice_base_4.visible = false
			
			green_player_2.visible = true
			red_player_3.visible = false
			yellow_player_4.visible = false
		3:
			dice_base_2.visible = true
			dice_base_3.visible = true
			dice_base_4.visible = false
			
			green_player_2.visible = true
			red_player_3.visible = true
			yellow_player_4.visible = false
		4:
			dice_base_2.visible = true
			dice_base_3.visible = true
			dice_base_4.visible = true
			
			green_player_2.visible = true
			red_player_3.visible = true
			yellow_player_4.visible = true



func _on_DiceButton_pressed():
	if can_roll_dice != 0:
		can_roll_dice = 0
		dice_audio.play()
		dice_faces.hide()
		moving_dice.show()
		moving_dice.set_frame(0)
		moving_dice.play("roll")



func _on_MovingDice_animation_finished():
	can_roll_dice = 0
	randomize()
	cur_dice_face = randi() % 6

	#for testing only
#	cur_dice_face = dice_no
	moving_dice.hide()
	dice_faces.show()
#	dice_faces.set_frame_and_progress(cur_dice_face,dice_faces.get_frame_progress())
	dice_faces.frame = cur_dice_face
	#dice_faces.playing = false
	dice_faces.pause()
	
	if player_unlocked[turn] and can_roll_dice==0:
		step = player_pos[turn]
		player_pos[turn] += cur_dice_face + 1
		take_one_step()
		
	elif cur_dice_face == 5 :
		player_unlocked[turn] = 1
		players[turn].position = players_path.get_curve().get_point_position(0)
		player_pos[turn] = 0
		_on_Main_stop_taking_steps()
	else:
		_on_Main_stop_taking_steps()



func change_dice_pos():
	turn_timer.start()


func _on_TurnTimer_timeout():
	
	dice_faces.position.x = dice_pos[turn*2]
	dice_faces.position.y = dice_pos[turn*2+1]
	moving_dice.position.x = dice_pos[turn*2]
	moving_dice.position.y = dice_pos[turn*2+1]
	can_roll_dice = 1


func check_players_collision():
	var set = []
#	for x in player_pos.size():
#		for y in player_pos.size()-x-1:
#			if player_pos[x] == player_pos[x+y+1]:
#				set.append(x+y+1)
#				if set.find(x) !=1:
#					set.append(x)
	for x in player_pos.size():
		for y in player_pos.size():
			if x!=y and player_pos[x] == player_pos[y] :
				if set.find(x)==-1:
					set.append(x)
				if set.find(y)==-1:
					set.append(y)

	var reset = [0,1,2,3]
	if set.size() > 1:
		for x1 in set.size():
			reset.erase(set[x1])
			if set[x1] == 0 and scale_player[0] == 0:
				players[0].position = players_path.get_curve().get_point_position(player_pos[0])
				players[0].position.x += -25
				players[0].scale = Vector2(0.075,0.075)
				scale_player[0] = 1
			if set[x1] == 1 and scale_player[1] == 0:
				players[1].position = players_path.get_curve().get_point_position(player_pos[1])
				players[1].position.y += -25
				players[1].scale = Vector2(0.075,0.075)
				scale_player[1] = 1
			if set[x1] == 2 and scale_player[2] == 0:
				players[2].position = players_path.get_curve().get_point_position(player_pos[2])
				players[2].position.x += 25
				players[2].scale = Vector2(0.075,0.075)
				scale_player[2] = 1
			if set[x1] == 3 and scale_player[3] == 0:
				players[3].position = players_path.get_curve().get_point_position(player_pos[3])
				players[3].position.y += 25
				players[3].scale = Vector2(0.075,0.075)
				scale_player[3] = 1

	if reset.size() > 0:
		for x in reset:
			players[x].scale = Vector2(0.151,0.151)
			scale_player[x] = 0
			if player_pos[x] >= 0:
				players[x].position = players_path.get_curve().get_point_position(player_pos[x])

#		for x1 in reset.size():
#			if reset[x1] == 0 and scale_player[0] == 1:
#				players[0].scale = Vector2(0.151,0.151)
#				players[0].position.x += 25
#				scale_player[0] = 0
#			if reset[x1] == 1 and scale_player[1] == 1:
#				players[1].position.y += 25
#				players[1].scale = Vector2(0.151,0.151)
#				scale_player[1] = 0
#			if reset[x1] == 2 and scale_player[2] == 1:
#				players[2].position.x += -25
#				players[2].scale = Vector2(0.151,0.151)
#				scale_player[2] = 0
#			if reset[x1] == 3 and scale_player[3] == 1:
#				players[3].position.y += -25
#				players[3].scale = Vector2(0.151,0.151)
#				scale_player[3] = 0

func is_at_ladder_or_snake():
	ladder_index = ladder_bottom_pos.find(player_pos[turn])
	snake_index = snake_mouth_pos.find(player_pos[turn])
	if ladder_index != -1:
		ladder_audio.play()
		show_toast(ladder_message[ladder_index])
		player_pos[turn] = ladder_top_pos[ladder_index]
		step = ladder_path_start_pos[ladder_index]
		take_ladder_step()
	elif snake_index != -1:
		snake_audio.play()
		show_toast(snake_message[snake_index])
		player_pos[turn] = snake_tail_pos[snake_index]
		step = snake_path_start_pos[snake_index]
		take_snake_step()
	else:
		_on_Main_stop_climbing_ladder()



func take_one_step():
	timer.start(0.3)
	step += 1
	move_audio.play()
	players[turn].position = players_path.get_curve().get_point_position(step)


func _on_Timer_timeout():
	timer.stop()
	if step < player_pos[turn]:
		take_one_step()
	else:
		emit_signal("stop_taking_steps")

func take_ladder_step():
	ladder_timer.start(0.25)
	step += 1
	players[turn].position = ladders_path.get_curve().get_point_position(step)


func take_snake_step():
	snake_timer.start(0.1)
	step += 1
	players[turn].position = snakes_path.get_curve().get_point_position(step)





func _on_Main_stop_taking_steps():
	check_players_collision()
	is_at_ladder_or_snake()



func _on_Main_stop_climbing_ladder():
	check_players_collision()
	
	turn += 1
	if turn == Global.total_players:
		turn = 0
	change_dice_pos()


func _on_LadderTimer_timeout():
	ladder_timer.stop()
	if step < ladder_path_end_pos[ladder_index]:
		take_ladder_step()
	else:
		ladder_audio.stop()
		emit_signal("stop_climbing_ladder")


func _on_SnakeTimer_timeout():
	snake_timer.stop()
	if step < snake_path_end_pos[snake_index]:
		take_snake_step()
	else:
		emit_signal("stop_climbing_ladder")


func show_toast(message):
	
	toast.dialog_text = message
	toast.popup_centered()
#	can_roll_dice = 0
#	toast_timer.start()


func _on_ToastTimer_timeout():
	toast.visible = false
	




func _on_Home_button_up():
	get_tree().change_scene_to_file("res://Scenes/Home.tscn")
