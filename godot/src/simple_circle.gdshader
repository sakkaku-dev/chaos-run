shader_type canvas_item;

uniform float radius : hint_range(0.0, 1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (distance(UV, vec2(0.5,0.5)) > radius/2.0) 
	{
		COLOR = vec4(0.0);
	}
}

