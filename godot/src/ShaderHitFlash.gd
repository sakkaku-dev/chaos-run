extends HitFlash2D

func _set_hit_flash(mat: ShaderMaterial, enable: bool):
	mat.set_shader_parameter("enable", enable)
