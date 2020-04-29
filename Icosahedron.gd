extends MeshInstance

#export var edge_length=1.0
export var frequency = 1

const phi = (1+sqrt(5))/2

var vertices = []
var st = SurfaceTool.new()

func _ready():
	
	var tri
	
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
		#st.add_vertex(vertices[0])
		#st.add_vertex(vertices[i%5+1])
		#st.add_vertex(vertices[i])
		tri = TriTess.new(st, vertices[0], vertices[i%5+1], vertices[i], frequency)
		st = tri.get_st()
	
	#st.add_vertex(vertices[0])
	#st.add_vertex(vertices[5])
	#st.add_vertex(vertices[1])
	
		
	#Bottom
#	for i in range(1, 6):
#		st.add_vertex(vertices[11])
#		st.add_vertex(vertices[i+5])
#		st.add_vertex(vertices[i%5+6])
		tri = TriTess.new(st, vertices[11], vertices[i+5], vertices[i%5+6], frequency)
		st = tri.get_st()
#
#	#Side
#	st.add_color(Color.red)
#	for i in range(1,6):
#		st.add_vertex(vertices[i])
#		st.add_vertex(vertices[i%5+1])
#		st.add_vertex(vertices[i+5])
		tri = TriTess.new(st, vertices[i], vertices[i%5+1], vertices[i+5], frequency)
		st = tri.get_st()
#
#	st.add_color(Color.aquamarine)
#	for i in range(1,6):
#		st.add_vertex(vertices[i%5+1])
#		st.add_vertex(vertices[i%5+6])
#		st.add_vertex(vertices[i+5])
		tri = TriTess.new(st, vertices[i%5+1], vertices[i%5+6], vertices[i+5], frequency)
		st = tri.get_st()
		
	#st.generate_normals()
	#mesh = st.commit()
	
	mesh=st.commit()
	
func _process(delta): 
	rotate_y(delta)

class TriTess extends MeshInstance:

	# Member variables
	#export var side_length = 2.0
	var freq = 1
	
	var top 
	var right
	var left 

	var tri_mesh
	var vertices = []
	var st
	
	#const hcoff = 0.86602540378
	
	func meshify():
		#st.begin(Mesh.PRIMITIVE_TRIANGLES)
		#Ensimmäinen kolmio
		st.add_color(Color.red)
		st.add_normal(vertices[0][0])
		st.add_vertex(vertices[0][0])
		st.add_normal(vertices[1][1])
		st.add_vertex(vertices[1][1])
		st.add_normal(vertices[1][0])
		st.add_vertex(vertices[1][0])
		var f = freq+1
		for i in range(1, freq):
			for j in range(i+1):
				#Ensin ylöspäin osoittavat kolmiot
				st.add_color(Color.red)
				st.add_normal(vertices[i][j])
				st.add_vertex(vertices[i][j])
				st.add_normal(vertices[i+1][j+1])
				st.add_vertex(vertices[i+1][j+1])
				st.add_normal(vertices[i+1][j])
				st.add_vertex(vertices[i+1][j])
				#Sitten alaspäin osoittavat kolmiot
			for j in range(i):
				st.add_color(Color.blue)
				st.add_normal(vertices[i][j])
				st.add_vertex(vertices[i][j])
				st.add_normal(vertices[i][j+1])
				st.add_vertex(vertices[i][j+1])
				st.add_normal(vertices[i+1][j+1])
				st.add_vertex(vertices[i+1][j+1])
		#st.generate_normals()
	
	func get_st():
		calculate_vertices()
		return(st)
	
	func _init(surface_tool, v0, v1, v2, frequence=1):
		top = v0
		right = v1
		left = v2
		freq = frequence
		st = surface_tool
		
	func calculate_vertices():
		
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
				vertices[i][j]=(top+i*t_down + j*t_right)
		#print(vertices)
		for i in range(f+1):
			for j in range(i+1):
				pass
		meshify()
	
	#func _process(delta): 
		#rotate_y(delta)
	
