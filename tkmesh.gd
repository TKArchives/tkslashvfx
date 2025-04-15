@tool

extends MeshInstance2D

class_name TKMesh

@export var inner_radius: float = 80
@export var outer_radius: float = 100
@export var start_angle: float = 0
@export var end_angle: float = PI * 2.0
@export var segment_density: int = 20
@export var offset_curve: Curve
@export var offset_multiple: float = 2.0
@export var offset: float = 0.0

func _init() -> void:
	mesh = ArrayMesh.new()
	
	texture = ImageTexture.create_from_image(Image.create(1, 1, false, Image.FORMAT_RGBA8))
	material = ShaderMaterial.new()
	material.shader = preload("res://tkvfx.gdshader")
	
	offset_curve = Curve.new()
	offset_curve.add_point(Vector2(0.0, 0.0), 0.0, 3.0)
	offset_curve.add_point(Vector2(1.0, 1.0))

func _process(delta: float) -> void:
	mesh.clear_surfaces()
	
	var angle_span = end_angle - start_angle
	var segments = segment_density * angle_span / PI
	
	var vertices = []
	for i in range(segments + 1):
		var angle = start_angle + angle_span * i / segments
		var outer_x = outer_radius * cos(angle)
		var outer_y = outer_radius * sin(angle)
		vertices.append(Vector2(outer_x, outer_y))
		var inner_x = inner_radius * cos(angle)
		var inner_y = inner_radius * sin(angle)
		vertices.append(Vector2(inner_x, inner_y))

	var uvs = []
	for i in range(segments + 1):
		var angle = start_angle + angle_span * i / segments
		var u = (angle - start_angle) / angle_span
		uvs.append(Vector2(u, 0))
		uvs.append(Vector2(u, 1))

	var indices = []
	for i in range(segments):
		var base_index = i * 2
		indices.append(base_index)
		indices.append(base_index + 2)
		indices.append(base_index + 1)
		indices.append(base_index + 1)
		indices.append(base_index + 2)
		indices.append(base_index + 3)
	
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = PackedVector2Array(vertices)
	arrays[Mesh.ARRAY_TEX_UV] = PackedVector2Array(uvs)
	arrays[Mesh.ARRAY_INDEX] = PackedInt32Array(indices)

	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	
	offset = fmod(offset + offset_multiple * delta, offset_curve.max_domain) / offset_curve.max_value
	material.set_shader_parameter("offset", offset_curve.sample(offset))
