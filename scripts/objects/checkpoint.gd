extends Node2D


var particles : PackedScene = preload("res://scene/particles/checkpoint_particles.tscn")

signal checkpoint_grabbed

func _ready():
	connect("checkpoint_grabbed", self, "_on_checkpoint_grabbed")


func _on_checkpoint_grabbed():
#	var parent = get_parent()
#	for child in parent.get_children():
#		if child == self : break
#		var anim_player = child.get_node("animation_player")
#		if anim_player == null || anim_player.current_animation == "idle" : break
#		anim_player.play_backwards("checkpoint")
		
	
	player_data.spawn_location = position
	
	for child in get_children():
		if child.get_class() == "CPUParticles2D": child.queue_free()
	$animation_player.play("checkpoint")
	var p = particles.instance()
	p.emitting = true
	add_child(p)
