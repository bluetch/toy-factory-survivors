extends Node

var shoot_stream: AudioStream = null
var player_hurt_stream: AudioStream = null
var enemy_death_stream: AudioStream = null
var pickup_stream: AudioStream = null
var level_up_stream: AudioStream = null

func _ready():
	shoot_stream = load("res://assets/audio/gun-shoot.wav")


func play_sound(sound_name: String):
	if has_node(sound_name):
		var audio_player: AudioStreamPlayer = get_node(sound_name)
		match sound_name:
			"shoot":
				audio_player.stream = shoot_stream
		audio_player.play()
	else:
		print("Sound not found: ", sound_name)
