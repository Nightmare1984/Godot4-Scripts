shader_type spatial;

// ________Primary Color Uniform___________
uniform vec4 primary_color : source_color;
// ____Roughness Uniform_______
uniform float roughness = 0.2;
// __________Normal Map Uniforms_____________
uniform sampler2D normalmap_a : hint_normal;
uniform sampler2D normalmap_b : hint_normal;
uniform float normalmap_a_strangth = 0.77;
uniform float normalmap_b_strangth = 0.65;
// _____________Movement________________________
uniform vec2 movement_direction = vec2(0.2,0.3);
uniform float movement_strangth = 0.5;
// ________UV Scale__________
uniform float uv_scale = 1.0;

float fresnel(float amount, vec3 normal, vec3 view)
{
	// ___________________________Schlick's Approximation_________________________________
	return pow ((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}
void fragment() {
	// ___________Fresnel Calculation________________
	float basic_fresnel = fresnel(3.0, NORMAL, VIEW);
	// ____________________UV Calculation_____________________________
	vec2 uv = UV * uv_scale;
	vec2 uv_movement = movement_direction * TIME * movement_strangth;
	// ____________________Normal Map Calculation______________________________________
	vec3 normalmap = texture(normalmap_a, uv + uv_movement).rgb * normalmap_a_strangth;
	normalmap += texture(normalmap_b, uv - uv_movement).rgb * normalmap_b_strangth;
	// _________________Final Output_____________________
	ALBEDO = primary_color.rgb + (0.2 * basic_fresnel);
	ROUGHNESS = roughness * (1.0 - basic_fresnel);
	NORMAL_MAP = normalmap;
}
