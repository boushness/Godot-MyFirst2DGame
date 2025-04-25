extends Area2D
signal hit # Signal for when Player is hit

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set screen bounds
	screen_size = get_viewport_rect().size
	
	# Hide sprite after initializing
	hide()
	
	# Test line to start Player, for Debug
	# start(Vector2.ZERO)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # The player's movement vector
	
	# Read input & adjust Player velocity
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	# Play animation if the Player is moving
	if velocity.length() > 0:
		# Normalize velocity if moving diagonally
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	# Set position based on calculated velocity & speed, and keep position inside screen bounds
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# Adjust animation based on direction
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

func _on_body_entered(body: Node2D) -> void:
	hide() # Player disappears after being hit.
	hit.emit() # Emit hit signal
	# Must be deferred as we can't change physics properties on a physics callback.
	# Disable Player collision when hit so multiple hit signals aren't registred at once
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos: Vector2) -> void:
	# Initialize Player position to passed value
	position = pos
	# Show Player sprite
	show()
	# Enable Player collision
	$CollisionShape2D.disabled = false
