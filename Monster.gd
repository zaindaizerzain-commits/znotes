extends CharacterBody3D

var awake := false
var speed := 1.6
var target: Node3D

func _ready():
    target = get_parent().get_node("Player")

func _physics_process(delta):
    if not awake or target == null:
        return

    var distance = global_position.distance_to(target.global_position)

    # Abu Al-Ala follows slowly at first.
    if distance < 18.0:
        var direction = (target.global_position - global_position)
        direction.y = 0
        if direction.length() > 0.1:
            direction = direction.normalized()
            velocity.x = direction.x * speed
            velocity.z = direction.z * speed
            look_at(Vector3(target.global_position.x, global_position.y, target.global_position.z), Vector3.UP)
            move_and_slide()

    # Horror escalation.
    if distance < 2.0:
        get_parent().get_node("UI/Objective").text = "💀 أبو العلا لحق فيك... اهرب!!!"
