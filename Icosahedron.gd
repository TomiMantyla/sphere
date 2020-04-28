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
	
	var tri = TriTess.new(Vector3(0,1,0), Vector3(1,0,0), Vector3(-1, 0, 0))
	mesh=tri.get_mesh()
	
func _process(delta): 
	rotate_y(delta)

class TriTess extends MeshInstance:

	# Member variables
	#export var side_length = 2.0
	export(int) var freq = 3
	
	var top 
	var right
	var left 

	var tri_mesh
	var vertices = []
	var st = SurfaceTool.new()
	
	const hcoff = 0.86602540378
	
	func meshify():
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		#Ensimmäinen kolmio
		st.add_color(Color.red)
		st.add_vertex(vertices[0][0])
		st.add_vertex(vertices[1][1])
		st.add_vertex(vertices[1][0])
		var f = freq+1
		for i in range(1, freq):
			for j in range(i+1):
				#Ensin ylöspäin osoittavat kolmiot
				st.add_color(Color.red)
				st.add_vertex(vertices[i][j])
				st.add_vertex(vertices[i+1][j+1])
				st.add_vertex(vertices[i+1][j])
				#Sitten alaspäin osoittavat kolmiot
			for j in range(i):
				st.add_color(Color.blue)
				st.add_vertex(vertices[i][j])
				st.add_vertex(vertices[i][j+1])
				st.add_vertex(vertices[i+1][j+1])
		st.generate_normals()
		tri_mesh = st.commit()
	
	func get_mesh():
		calculate_vertices()
		return(tri_mesh)
	
	func _init(v0, v1, v2):
		
		top = v0
		right = v2
		left = v1
		
	func calculate_vertices():
		
		print("täällä ollaan!")
		#var down = Vector3(-0.5*side_length, -1.0*hcoff*side_length, 0.0)
		#var right = Vector3(side_length, 0.0, 0.0)
		
		var tl = left - top
		var r = right - left
		
		var t_down = tl/freq
		var t_right = r/freq
		
		var f = freq+1
		
		vertices.resize(f) 
		for i in range(f):
			vertices[i] = []
			vertices[i].resize(i+1)
		
		for i in range(f):
			#print(i)
			for j in range(i+1):
				#print("    "+str(j))
				vertices[i][j]=(i*t_down + j*t_right)
		#print(vertices)
		for i in range(f+1):
			for j in range(i+1):
				pass
		meshify()
	
	#func _process(delta): 
		#rotate_y(delta)
	
