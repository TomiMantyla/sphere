extends MeshInstance
 
func _ready():
	
	var surface_tool = SurfaceTool.new()
	var tmpMesh = Mesh.new()
		
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)

	
	# Add the second vertex to the surface tool (the bottom right vertex).
	surface_tool.add_normal(Vector3(0, 0, -1));
	surface_tool.add_color(Color(0, 1, 0, 1));
	surface_tool.add_vertex(Vector3(2, 0, 0));
	
	# Add the third vertex to the surface tool (the top vertex).
	surface_tool.add_normal(Vector3(0, 0, -1));
	surface_tool.add_color(Color(0, 0, 1, 1));
	surface_tool.add_vertex(Vector3(1, 2, 0));
	
	surface_tool.add_normal(Vector3(0, 0, -1));
	surface_tool.add_color(Color(1, 0, 0, 1));
	surface_tool.add_vertex(Vector3(0, 0, 0));
	
	surface_tool.add_index(0);
	surface_tool.add_index(1);
	surface_tool.add_index(2);
	
	mesh = surface_tool.commit()
	
