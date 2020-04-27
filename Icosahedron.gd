extends MeshInstance

export var edge_length=1.0

const phi = (1+sqrt(5))/2

var vertices = []
var st = SurfaceTool.new()

func _ready():
	
	vertices.resize(12)
	
	vertices[0] = Vector3(0.0, phi, 1.0)
	vertices[1] = Vector3(1.0, 0.0, phi)
	vertices[2] = Vector3(phi, 1.0, 0.0)
	vertices[3] = Vector3(0.0, phi, -1.0)
	vertices[4] = Vector3(-phi, 1.0, 0.0)
	vertices[5] = Vector3(-1.0, 0.0, phi)
	vertices[6] = Vector3(phi, -1.0, 0.0)
	vertices[7] = Vector3(1.0, 0.0, -phi)
	vertices[8] = Vector3(-1.0, 0.0, -phi)
	vertices[9] = Vector3(-phi, -1.0, 0.0)
	vertices[10] = Vector3(0.0, -phi, 1.0)
	vertices[11] = Vector3(0.0, -phi, -1.0)
	
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	#Top --Who says which vertex is on top?
	st.add_color(Color.blue)
	for i in range(1,6):
		st.add_vertex(vertices[0])
		st.add_vertex(vertices[i%5+1])
		st.add_vertex(vertices[i])
	#st.add_vertex(vertices[0])
	#st.add_vertex(vertices[5])
	#st.add_vertex(vertices[1])
	
		
	#Bottom
	for i in range(1, 6):
		st.add_vertex(vertices[11])
		st.add_vertex(vertices[i+5])
		st.add_vertex(vertices[i%5+6])
	
	#Side
	st.add_color(Color.red)
	for i in range(1,6):
		st.add_vertex(vertices[i])
		st.add_vertex(vertices[i%5+1])
		st.add_vertex(vertices[i+5])
	
	st.add_color(Color.aquamarine)
	for i in range(1,6):
		st.add_vertex(vertices[i%5+1])
		st.add_vertex(vertices[i%5+6])
		st.add_vertex(vertices[i+5])
	
	st.generate_normals()
	mesh = st.commit()
	
func _process(delta): 
	rotate_y(delta)
