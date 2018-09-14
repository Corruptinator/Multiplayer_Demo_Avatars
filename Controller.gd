extends Node2D

#slave var slave_tilt = 0
#slave var slave_velocity = Vector2()

var up = false
var down = false
var vertical = true

var left = false
var right = false
var horizontal = true

var spawn = false
var pos = Vector2()

slave var m_up = false
slave var m_down = false
slave var m_vertical = false

slave var m_left = false
slave var m_right = false
slave var m_horizontal = false

slave var m_spawn = false
slave var m_pos = Vector2()
slave var m_random

slave var m_player_rank = null

var player_id
var control = false

func _ready():
#SETUP
	pass

func _physics_process(delta):

	if (is_network_master()): # MULTIPLAYER CONTROLS
		#print("NETWORK")
		if Input.is_action_just_pressed("ui_spawn"):
			spawn = true
			pass
		else:
			spawn = false
			pass
		
		if Input.is_action_just_pressed("ui_quit"):
			get_node("/root/multiplayer").quit_game()
		else:
			pass
		
		if Input.is_action_pressed("ui_left"):
			horizontal = false
			right = false
			left = true
			pass
		elif Input.is_action_pressed("ui_right"):
			horizontal = false
			right = true
			left = false
			pass
		else:
			horizontal = true
			right = false
			left = false
			pass

		if Input.is_action_pressed("ui_up"):
			vertical = false
			down = false
			up = true
			pass
		elif Input.is_action_pressed("ui_down"):
			vertical = false
			down = true
			up = false
			pass
		else:
			vertical = true
			down = false
			up = false
			pass
		
		rset("m_up", up)
		rset("m_down", down)
		rset("m_vertical", horizontal)
		rset("m_left", left)
		rset("m_right", right)
		rset("m_horizontal", horizontal)
		rset("m_spawn", spawn)
	else:
		up = m_up
		down = m_down
		vertical = m_vertical
		left = m_left
		right = m_right
		horizontal = m_horizontal
		pass
	
	if spawn == true:
		randomizer()
		rset("m_pos", pos)
		rpc("m_spawn",get_tree().get_network_unique_id())
		pass
	else:
		pass

	if up == true:
		for i in get_tree().get_nodes_in_group("players"):
			if i.get_name() == "avatar_"+str(self.get_name()):
				i.rpc ("control_UP")    ####   FIX MULTIPLAYER SPAWN POSITIONS AND SYNC
			else:
				pass
		pass
	elif down == true:
		for i in get_tree().get_nodes_in_group("players"):
			if i.get_name() == "avatar_"+str(self.get_name()):
				i.rpc ("control_DOWN")    ####   FIX MULTIPLAYER SPAWN POSITIONS AND SYNC
			else:
				pass
		pass
	else:
		pass

	if vertical == true:
		for i in get_tree().get_nodes_in_group("players"):
			if i.get_name() == "avatar_"+str(self.get_name()):
				i.rpc ("control_VERTICAL_STOP")    ####   FIX MULTIPLAYER SPAWN POSITIONS AND SYNC
			else:
				pass
		pass
	else:
		pass

	if left == true:
		for i in get_tree().get_nodes_in_group("players"):
			if i.get_name() == "avatar_"+str(self.get_name()):
				i.rpc ("control_LEFT")    ####   FIX MULTIPLAYER SPAWN POSITIONS AND SYNC
			else:
				pass
		pass
	elif right == true:
		for i in get_tree().get_nodes_in_group("players"):
			if i.get_name() == "avatar_"+str(self.get_name()):
				i.rpc ("control_RIGHT")    ####   FIX MULTIPLAYER SPAWN POSITIONS AND SYNC
			else:
				pass
		pass
	else:
		pass

	if horizontal == true:
		for i in get_tree().get_nodes_in_group("players"):
			if i.get_name() == "avatar_"+str(self.get_name()):
				i.rpc ("control_HORIZONTAL_STOP")    ####   FIX MULTIPLAYER SPAWN POSITIONS AND SYNC
			else:
				pass
		pass
	else:
		pass

sync func m_spawn(by_who):
	if (is_network_master()):
		var rename = str(self.get_name())
		var import = load("res://Avatar.tscn").instance()
		import.set_name(str(import.get_name())+rename)
		import.position = pos #get_tree().get_nodes_in_group("spawn")[round(rand_range(0,3))].position
		#get_tree().get_root().add_child(import)
		get_node("/root/Main/Players/Avatars").add_child(import)
	else:
		var rename = str(self.get_name())
		var import = load("res://Avatar.tscn").instance()
		import.set_name(str(import.get_name())+rename)
		import.position = m_pos
		#print(m_pos)
		#get_tree().get_root().add_child(import)
		get_node("/root/Main/Players/Avatars").add_child(import)
	pass

func randomizer():
	randomize()
	pos = get_tree().get_nodes_in_group("spawn")[round(rand_range(0,3))].position
	return pos