extends KinematicBody2D

#PRE SETUP
var velocity = Vector2()
var speed = 70
var gravity = 20
var jump = false
var cutoff = false

#slave var slave_tilt = 0
#slave var slave_velocity = Vector2()
slave var sync_pos = Vector2()
slave var sync_vel = Vector2()
var reposition = Vector2()

var time_passed = 0
var calls_per_second = 24/60 #Engine.get_target_fps() #Erase 24/ if it is in the way
var time_for_one_call = 10*(1 / 60*calls_per_second)#Engine.get_target_fps()*calls_per_second)
#var time_for_one_call = 1 / calls_per_second

var on_air_time = 100
var JUMP_MAX_AIRBORNE_TIME = .2

var update_sprite
var update_animation
var timeline = 0
var tilt = 2

var bottom = [0,4]
var lower = [5,9]
var middle = [10,14]
var upper = [15,19]
var top = [20,24]

func _ready():
#SETUP
	#hide()
	set_physics_process(true)
	set_process(true)
#	update_sprite = get_node("Ship").get_frame()
#	update_animation = [middle[0],middle[1]]
#	timeline = middle[0]
	pass

func _physics_process(delta):

#UPDATE ANIMATION
	#update_frame()

#TIMER
	#time_passed += delta

	#if time_passed >= time_for_one_call:
		#update_flames()
		#time_passed -= time_for_one_call

#USING DELTA TO GIVE NATURAL GRAVITY AND MAKING OBJECT MOVE AFTER USING VELOCITY.
	#get_node("Ship").set_frame(tilt)

	var dampen = 0.8

	if (is_network_master()):
		#print("true")
		velocity += velocity * delta
		velocity.x *= dampen
		velocity.y *= dampen
		rset("sync_pos",self.position)
		rset("sync_vel",velocity)
		move_and_slide(velocity, Vector2(0, -1))
		pass
	else:
		self.position = sync_pos
		velocity = sync_vel
		move_and_slide(velocity, Vector2(0, -1))
		pass

	if (is_network_master()):
		reposition = self.position
		rset("sync_pos",reposition)
		if is_visible_in_tree():
			pass
		else:
			show()
	else:
		if self.position >= sync_pos+Vector2(20,20) or self.position <= sync_pos+Vector2(-20,-20):
			self.position = sync_pos
			if is_visible_in_tree():
				pass
			else:
				show()
				pass
		else:
			pass

	pass

func _process(delta):
	
	if (is_network_master()):
		rset("sync_pos",self.position)
	else:
		self.position = sync_pos
	
	pass

#func update_frame(): # For updating the flame sprites beside the ship
#
#	if update_sprite != get_node("Ship").get_frame():
#		#
#		var new_anim = abs(get_node("Exaust").get_frame()-update_animation[0])#[update_animation[0],update_animation[1]]
#		if get_node("Ship").get_frame() == 0:
#			update_animation = [bottom[0],bottom[1]]
#			new_anim = new_anim + update_animation[0]
#		elif get_node("Ship").get_frame() == 1:
#			update_animation = [lower[0],lower[1]]
#			new_anim = new_anim + update_animation[0]
#		elif get_node("Ship").get_frame() == 2:
#			update_animation = [middle[0],middle[1]]
#			new_anim = new_anim + update_animation[0]
#		elif get_node("Ship").get_frame() == 3:
#			update_animation = [upper[0],upper[1]]
#			new_anim = new_anim + update_animation[0]
#		elif get_node("Ship").get_frame() == 4:
#			update_animation = [top[0],top[1]]
#			new_anim = new_anim + update_animation[0]
#		else:
#			pass
#		update_sprite = get_node("Ship").get_frame()
#		pass
#	else:
#		pass
#	pass

#func update_flames():
#	if timeline >= update_animation[0] and timeline <= update_animation[1]-1:
#		timeline += 1
#	else:
#		timeline = update_animation[0]
#	get_node("Exaust").set_frame(timeline)
#	pass



# CONTROLS

sync func control_UP():
	#print("Up")
	velocity.y -= speed #* force.x
#	tilt += 0.25
#	if get_node("Ship").get_frame() < 3:
#		get_node("Ship").set_frame(tilt)
#	else:
#		tilt = 4
#		get_node("Ship").set_frame(tilt)
	pass

sync func control_DOWN():
	velocity.y += speed #* force.x
#	tilt -= 0.25
#	if get_node("Ship").get_frame() > 1:
#		get_node("Ship").set_frame(tilt)
#	else:
#		tilt = 0
#		get_node("Ship").set_frame(tilt)
	pass

sync func control_HORIZONTAL_STOP():
	if abs(velocity.y) <= 0.01:
		velocity.y = 0
	else:
		pass
#
#	if tilt != 2:
#		if tilt < 2:
#			tilt += 0.25
#		elif tilt > 2:
#			tilt -= 0.25
#		else:
#			pass
#	else:
#		tilt = 2
	pass

sync func control_LEFT():
	velocity.x -= speed
	pass

sync func control_RIGHT():
	velocity.x += speed
	pass

sync func control_VERTICAL_STOP():
	if abs(velocity.x) <= 0.01:
		velocity.x = 0
	else:
		pass
	pass