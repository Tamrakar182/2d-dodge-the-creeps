extends Area2D

signal hit

## sets the speed at which character will move in px/s
export var speed = 400.0
var screen_size = Vector2.ZERO

func _ready():
	## gets the screen size
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	## sets the intial direction to zero
	var direction = Vector2.ZERO
	
	## horizontal travesal by adding to move right in the x-axis
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	## horizontal travesal by subtracting to move left in the x-axis	
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	## vertical travesal by adding to move down in the y-axis
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	## vertical travesal by subtracting to move up in the y-axis	
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
		
	## to make sure player is pressing at least one key
	if direction.length() > 0:
		direction = direction.normalized()
		
	## driver code for animation
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	## moves the character according to direction, its multiplied to delta
	## to make it time dependent and not frame dependent
	position += direction * speed * delta
	
	## limits the position of character so that it doesnt go outside the viewport
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if direction.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = direction.x < 0
	elif direction.y != 0:
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.flip_v = direction.y > 0
		$AnimatedSprite.animation = "up"
		

func start(new_position):
	position = new_position
	show()
	$CollisionShape2D.disabled = false

func _on_Player_body_entered(_body):
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
	emit_signal("hit")
