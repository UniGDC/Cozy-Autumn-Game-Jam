extends KinematicBody2D
class_name Player

#Input
var x_input: int = 0
var jump_input: int = 0
var interact_input: int = 0

#Interact
export var interact_zone_path: NodePath
onready var interact_zone: Area2D = get_node(interact_zone_path)

#Dialog
var dialog: bool = false


#General
var velocity: Vector2 = Vector2.ZERO
var near_wall: bool = false

#Look
var looking_right: int = 1
export var sprite_path: NodePath
onready var sprite: Sprite = get_node(sprite_path)

#Animation
export var anim_player_path: NodePath
onready var anim_player: AnimationPlayer = get_node(anim_player_path)
var state: int = 0
enum State {IDLE, WALK, JUMP, LAND, FALL}

#Movement
export var move_speed: float
export var move_acc: float
export var idle_deacc: float

#Jumping
export var jump_height: float
export var jump_duration: float
export var fall_duration: float
export var max_fall: float

onready var fall_gravity: float = ((-2 * jump_height) / (fall_duration * fall_duration)) * -1
onready var jump_gravity: float =  ((-2 * jump_height) / (jump_duration * jump_duration)) *-1
onready var jump_velocity: float = ((2 * jump_height) / jump_duration) * -1

var reset_y_vel: bool = true
var can_jump: bool = true
var coyote_time_length: float = 0.15
var jump_was_pressed: bool = false
var remember_jump_length: float = 0.1


func _physics_process(delta: float) -> void:
	input()
	look()
	if !dialog:
		move(delta)
		interact()
	else:
		velocity.x = sign(velocity.x)/20
	animate()


func look() -> void:
	if velocity.x >= 0:
		looking_right = 1
		sprite.scale.x = 1
		$Head.scale.x = 1
	else:
		looking_right = -1
		sprite.scale.x = -1
		$Head.scale.x = -1


func interact() -> void:
	if interact_input:
		var interactables = interact_zone.get_overlapping_bodies() #bodies
		interactables.append_array(interact_zone.get_overlapping_areas())
		if interactables.size() > 0:
			get_closest_to_point(interactables, position).interaction(self)


func animate() -> void:
	if velocity.y < 0:
		state = State.JUMP
	elif velocity.y > 0.2:
		state = State.FALL
	elif abs(velocity.x) > 	0.1:
		state = State.WALK
	elif velocity.x < 0.1 && state == State.FALL && is_on_floor():
		state = State.LAND
	else:
		state = State.IDLE
		
	match state:
		State.JUMP:
			anim_player.play("Jump")
		State.FALL:
			anim_player.play("Fall")
		State.WALK:
			anim_player.play("Walk")
		State.IDLE:
			var idle_f = rand_range(0,2.3)
			var idle_anim: String
			
			if idle_f < 1.4:
				idle_anim = "Idle 1"
			elif idle_f < 2:
				idle_anim = "Idle 2"
			elif idle_f <= 2.3:
				idle_anim = "Idle 3"

				
			if anim_player.current_animation == "Walk":
				anim_player.play(idle_anim)
			else:
				anim_player.queue(idle_anim)
		State.LAND:
			pass
			anim_player.play("Land")


func get_closest_to_point(point_array: Array, point: Vector2) -> Node2D:
	var closest_node: Node2D = null
	var closest_node_distance: float = 0
	for i in point_array:
		var current_node_distance: float = point.distance_to(i.global_position)
		if closest_node == null or current_node_distance < closest_node_distance:
			closest_node = i
			closest_node_distance = current_node_distance
	return closest_node


func move(delta: float) -> void:
	#Left/Right
	var h_direction: int = x_input

	velocity.x += h_direction * move_acc
	
	
	#lerps velocity.x to 0 if player is isn't holding a direction
	if !h_direction:
		velocity.x = lerp(velocity.x, 0, idle_deacc)
	
	#clamps x velocity to recoil value
	velocity.x = clamp(velocity.x, -move_speed, move_speed)
	
	if is_on_wall():
		near_wall = true
	if !$Head.get_overlapping_bodies():
		near_wall = false
	
	if near_wall:
		velocity.x = sign(velocity.x)/20
		
	#Jumping
	if is_on_floor():
		if reset_y_vel:
			velocity.y = 0.1
			reset_y_vel = false
		can_jump = true
		if jump_was_pressed:
			jump()

	if jump_input:
		jump_was_pressed = true
		remember_jump_time()
		if can_jump:
			jump()
	
	if !is_on_floor():
		reset_y_vel = true
		coyote_time()
		apply_gravity(delta)
		
	move_and_slide(velocity, Vector2.UP)


func apply_gravity(delta: float) -> void:
	var gravity: float = jump_gravity if velocity.y < 0 else fall_gravity
	if gravity:
		velocity.y += gravity * delta
	if velocity.y > max_fall:
		velocity.y = max_fall
	

func jump() -> void:
	$JumpSound.play()
	velocity.y = jump_velocity


func coyote_time():
	yield(get_tree().create_timer(coyote_time_length), "timeout")
	can_jump = false


func remember_jump_time():
	yield(get_tree().create_timer(remember_jump_length), "timeout")
	jump_was_pressed = false


func input() -> void:
	#Resets variables
	interact_input = 0
	x_input = 0
	jump_input = 0
	
	#Horizontal
	if Input.is_action_pressed("right"):
		x_input += 1
	if Input.is_action_pressed("left"):
		x_input -= 1
	#Jump
	if Input.is_action_just_pressed("jump"):
		jump_input = 1
	#Interact/Dialgue
	if Input.is_action_just_released("interact"):
		interact_input = 1
		
	
func zoom_in() -> void:
	$Camera2D/AnimationPlayer.play("zoom in")
	
	
func zoom_out() -> void:
	$Camera2D/AnimationPlayer.play("zoom out")


func die() -> void:
	get_tree().reload_current_scene()
