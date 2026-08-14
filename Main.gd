extends Node3D

var shake_time := 0.0
var elevator_floor := 1
var game_started := false

func _ready():
    game_started = true
    # Prototype: earthquake begins immediately.
    shake_time = 3.5

func _process(delta):
    if shake_time > 0:
        shake_time -= delta
        var p = $Player
        p.rotation.x = sin(Time.get_ticks_msec()*0.05) * 0.015
        p.rotation.z = cos(Time.get_ticks_msec()*0.06) * 0.02
    else:
        $Player.rotation.x = lerp($Player.rotation.x, 0.0, delta*4.0)
        $Player.rotation.z = lerp($Player.rotation.z, 0.0, delta*4.0)

    # Simple horror progression: monster wakes after 12 seconds.
    if Time.get_ticks_msec() > 12000:
        $Monster.awake = true

func floor_up():
    elevator_floor += 1
    if elevator_floor >= 10:
        $UI/Objective.text = "🎉 وصلت للطابق 10... لكن أبو العلا كان بانتظارك. النهاية الأولى!"
    else:
        $UI/Info.text = "أبو العلا  •  الطابق %d\nWASD للحركة  |  E للتفاعل  |  F للكشاف" % elevator_floor
