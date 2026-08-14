extends CharacterBody3D

@export var speed := 4.5
@export var mouse_sensitivity := 0.0025
var gravity := 18.0
var flash_on := true

@onready var camera = $Camera3D
@onready var flashlight = $Camera3D/Flashlight

func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
    if event is InputEventMouseMotion:
        rotate_y(-event.relative.x * mouse_sensitivity)
        camera.rotation.x = clamp(camera.rotation.x - event.relative.y * mouse_sensitivity, -1.4, 1.4)

    if event.is_action_pressed("flashlight"):
        flash_on = not flash_on
        flashlight.visible = flash_on

    if event.is_action_pressed("interact"):
        var space = get_world_3d().direct_space_state
        var from = camera.global_position
        var to = from + -camera.global_transform.basis.z * 3.0
        var query = PhysicsRayQueryParameters3D.create(from,to)
        var hit = space.intersect_ray(query)
        if hit and hit.collider and hit.collider.has_method("interact"):
            hit.collider.interact()

func _physics_process(delta):
    var input_vec = Input.get_vector("move_left","move_right","move_forward","move_back")
    var dir = (transform.basis * Vector3(input_vec.x,0,input_vec.y)).normalized()
    velocity.x = dir.x * speed
    velocity.z = dir.z * speed
    if not is_on_floor():
        velocity.y -= gravity * delta
    else:
        velocity.y = 0
    move_and_slide()
