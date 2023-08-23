extends CharacterBody3D

const BASE_SPEED = 5.0;
const RUN_SPEED = 5.0;
const JUMP_VELOCITY = 4.5;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity");

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta;

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY;

	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward");
	var input_run = Input.get_action_strength("Run");
	var speed = BASE_SPEED + RUN_SPEED * input_run;
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized();
	direction = direction.rotated(Vector3(0,1,0), get_node("Camera").rotation.y + rotation.y);
	if direction:
		velocity.x = direction.x * speed;
		velocity.z = direction.z * speed;
	else:
		velocity.x = move_toward(velocity.x, 0, speed);
		velocity.z = move_toward(velocity.z, 0, speed);

	move_and_slide();
