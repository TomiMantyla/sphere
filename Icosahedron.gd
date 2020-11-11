extends MeshInstance

export var frequency = 1

const phi = (1+sqrt(5))/2 #Golden ratio

var radius

var vertices = []
var m
var st = SurfaceTool.new()
var mdt = MeshDataTool.new()


func _ready():
	
	#Let's create icosahedron
	var tri
	
	vertices.resize(12)
	#Vertices of icosahedron
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
	
	radius = vertices[0].length()
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.add_color(Color.blue)
	#Edges of icosahedron
	for i in range(1,6):
		#Top --Who says which vertex is on top?
		tri = TriTess.new(st, vertices[0], vertices[i%5+1], vertices[i], frequency)
		st = tri.get_st()
		
		#Bottom
		tri = TriTess.new(st, vertices[11], vertices[i+5], vertices[i%5+6], frequency)
		st = tri.get_st()
#
#		#Sides
		tri = TriTess.new(st, vertices[i], vertices[i%5+1], vertices[i+5], frequency)
		st = tri.get_st()

		tri = TriTess.new(st, vertices[i%5+1], vertices[i%5+6], vertices[i+5], frequency)
		st = tri.get_st()

	m=st.commit()
	mdt.create_from_surface(m, 0)
	#Okay, this thing will not be icosahedron after this.
	#Pushes vertices out to approximate sphere
	for i in range(mdt.get_vertex_count()):
		var vertex = mdt.get_vertex(i)
		mdt.set_vertex(i, vertex.normalized()*radius)
	m.surface_remove(0)
	mdt.commit_to_surface(m)
	mesh = m
	
func _process(delta): 
	rotate_y(delta*0.3)

class TriTess extends MeshInstance:
#Inner class for tesselating faces of icosahedron
	var freq = 1
	
	var top 
	var right
	var left 

	var tri_mesh
	var vertices = []
	var st
	
	var colors = [Color.red, Color.blue, Color.yellow, Color.green, Color.magenta, Color.cyan]

	func _init(surface_tool, v0, v1, v2, frequence=1):
		top = v0
		right = v1
		left = v2
		freq = frequence
		st = surface_tool
		randomize ( )
		
	func meshify():
	#Tesselates triangle into smaller triangles
		#First or top triangle
		st.add_color(Color.red)
		st.add_normal(vertices[0][0])
		st.add_vertex(vertices[0][0])
		st.add_normal(vertices[1][1])
		st.add_vertex(vertices[1][1])
		st.add_normal(vertices[1][0])
		st.add_vertex(vertices[1][0])
		var f = freq+1
		#Triangles pointing up
		for i in range(1, freq):
			for j in range(i+1):
				st.add_color(colors[randi() % colors.size()])
				st.add_normal(vertices[i][j])
				st.add_vertex(vertices[i][j])
				st.add_normal(vertices[i+1][j+1])
				st.add_vertex(vertices[i+1][j+1])
				st.add_normal(vertices[i+1][j])
				st.add_vertex(vertices[i+1][j])
			#Triangles pointing down
			for j in range(i):
				st.add_color(colors[randi() % colors.size()])
				st.add_normal(vertices[i][j])
				st.add_vertex(vertices[i][j])
				st.add_normal(vertices[i][j+1])
				st.add_vertex(vertices[i][j+1])
				st.add_normal(vertices[i+1][j+1])
				st.add_vertex(vertices[i+1][j+1])
	
	func get_st():
		calculate_vertices()
		return(st)
		
	func calculate_vertices():
	#Calculates coordinates for tesselation
	#and then tesselates triangle using meshify()	
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
			for j in range(i+1):
				vertices[i][j]=(top+i*t_down + j*t_right)
		for i in range(f+1):
			for j in range(i+1):
				pass
		meshify()
		
