extends MeshInstance

#export var edge_length=1.0
export var frequency = 1

const phi = (1+sqrt(5))/2

var radius

var full_circle = 0
var color_index = 0
var prev_i = 0

var vertices = []
var m
var st = SurfaceTool.new()
var mdt = MeshDataTool.new()
var ManipulatorFile = preload("res://MeshManipulator.gd")

var start_time

func _ready():
	
	start_time = OS.get_ticks_msec()
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
	
	radius = vertices[0].length()
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	#Top --Who says which vertex is on top?
	for i in range(1,6):
		#st.add_vertex(vertices[0])
		#st.add_vertex(vertices[i%5+1])
		#st.add_vertex(vertices[i])
		tri = TriTess.new(st, vertices[0], vertices[i%5+1], vertices[i], frequency)
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
		#Bottom
#	for i in range(1, 6):
#		st.add_vertex(vertices[11])
#		st.add_vertex(vertices[i+5])
#		st.add_vertex(vertices[i%5+6])
		tri = TriTess.new(st, vertices[11], vertices[i+5], vertices[i%5+6], frequency)
		st = tri.get_st()
	#st.generate_normals()
	#st.generate_tangents()
	
	st.index()
	m=st.commit()
	#print(m.surface_get_arrays(0)[ArrayMesh.ARRAY_NORMAL])
	mesh = m
	
	
		
	var mani = ManipulatorFile.MeshManipulator.new(m)
		
#	mdt.set_vertex_color(6, Color.blue)
#	for i in range(mdt.get_vertex_count()):
#		var n = mani.get_neighbours(i)
#		if n.size() == 4:
#			mdt.set_vertex_color(i, Color.blue)
#			for v in n:
#				mdt.set_vertex_color(v, Color.white)

	
	
	
	m = mani.proximity_indexer(0.0001)
	mdt.create_from_surface(m, 0)
	
	
#	var hops = mani.dijkstra(0)[0]
#	for i in range(mdt.get_vertex_count()):
#		if hops[i]%2 == 0:
#			mdt.set_vertex_color(i, Color.blue)
#		else:
#			mdt.set_vertex_color(i, Color.white)
	

	for i in range(mdt.get_vertex_count()):
		var vertex = mdt.get_vertex(i)
		mdt.set_vertex(i, vertex.normalized()*radius)
	
	hexify(0)
	hexify_far(0)
	
	m.surface_remove(0)
	mdt.commit_to_surface(m)
	m = mani.deindex()
	mdt.clear()
	mdt.create_from_surface(m, 0)
	hexify_flatten()
	#hexify_color()
	m.surface_remove(0)
	mdt.commit_to_surface(m)
	mesh = m
	#print(mani.dijkstra(0))
#	for i in range(mdt.get_vertex_count()):
#		if mani.get_neighbours(i).size() == 0:
#			print(i)
#		else:
#			print (mani.get_neighbours(i))
	#print(mani.get_neighbours(0))
#	for i in range(mdt.get_vertex_count()):
#		print(mani.get_far_neighbours(i))
	print("Mesh created in "+ str((OS.get_ticks_msec()-start_time)/1000.0)+" seconds.")


func hexify(start_index, visited = []):
	visited.append(start_index)
	var mm = ManipulatorFile.MeshManipulator.new(m)
	var fn = mm.get_far_neighbours(start_index)
	#mdt.set_vertex_color(start_index, Color.black)
	var pv = mdt.get_vertex(mm.get_neighbours(start_index)[0])
	var sv = mdt.get_vertex(start_index)
	var mv = pv.dot(sv)/sv.dot(sv)*sv
	#print(((pv.dot(sv)/sv.dot(sv))*sv).length())
	#print(sv.length())
	mdt.set_vertex(start_index, mv)
	mdt.set_vertex_normal(start_index, mv)
	mdt.set_vertex_color(start_index, Color.whitesmoke)
	for v in fn:
		if !visited.has(v):
			hexify(v, visited)

func hexify_far(start_index, visited = []):
	visited.append(start_index)
	mdt.set_vertex_color(start_index, Color.black)
	var mm = ManipulatorFile.MeshManipulator.new(m)
	var fn = mm.get_far_far_neighbours(start_index)
	for v in fn:
		if !visited.has(v):
			hexify_far(v, visited)

func hexify_color():
	var mm = ManipulatorFile.MeshManipulator.new(m)
	var faces
	for f in mdt.get_face_count():
		if mdt.get_vertex_color(mdt.get_face_vertex(f, 0)) == Color.black ||  mdt.get_vertex_color(mdt.get_face_vertex(f, 1)) == Color.black ||  mdt.get_vertex_color(mdt.get_face_vertex(f, 2)) == Color.black:
			mdt.set_vertex_color(mdt.get_face_vertex(f, 0), Color.black)
			mdt.set_vertex_color(mdt.get_face_vertex(f, 1), Color.black)
			mdt.set_vertex_color(mdt.get_face_vertex(f, 2), Color.black)

func hexify_flatten(): #Tehoton, lasketaan turhaan moneen kertaan
	var mm = ManipulatorFile.MeshManipulator.new(m)
	var normal
	print(mdt.get_face_count())
	for f in mdt.get_face_count():	
		if mdt.get_vertex_color(mdt.get_face_vertex(f, 0)) != Color.white:#  mdt.get_vertex_color(mdt.get_face_vertex(f, 1)) == Color.red ||  mdt.get_vertex_color(mdt.get_face_vertex(f, 2)) == Color.red:
			normal = mdt.get_vertex_normal(mdt.get_face_vertex(f, 0))
			mdt.set_vertex_color(mdt.get_face_vertex(f, 0), Color.white)
		elif mdt.get_vertex_color(mdt.get_face_vertex(f, 1)) != Color.white:
			normal = mdt.get_vertex_normal(mdt.get_face_vertex(f, 1))
			mdt.set_vertex_color(mdt.get_face_vertex(f, 1), Color.white)
		elif mdt.get_vertex_color(mdt.get_face_vertex(f, 2)) != Color.white:
			normal = mdt.get_vertex_normal(mdt.get_face_vertex(f, 2))
			mdt.set_vertex_color(mdt.get_face_vertex(f, 2), Color.white)
		if normal!=null:
			mdt.set_vertex_normal(mdt.get_face_vertex(f, 0), normal)
			mdt.set_vertex_normal(mdt.get_face_vertex(f, 1), normal)
			mdt.set_vertex_normal(mdt.get_face_vertex(f, 2), normal)
			normal = null

func _process(delta): 
	rotate_y(delta*0.5)

class TriTess extends MeshInstance: #For creating triangular tessselations of triangles
#Creates unindex mesh!

	var freq = 1 #Frequency of tesselation
	
	#Vectors that define tri that will be tesselated
	var top 
	var right
	var left 

	var tri_mesh
	var vertices = []
	var st

	func _init(surface_tool, v0, v1, v2, frequence=1): #Create new TriTess
	#suface_tool is where tesselation is added.
	#v0, v1, v2 vectors of tri being tesselated, clockwise order
	#frequency is frequency of tesselation.
		top = v0
		right = v1
		left = v2
		freq = frequence
		st = surface_tool
	
	func tesselate(): #Tesselates given tri in init.
		var f = freq+1
		
		#Unit vectors of tesselation
		var t_down = (left - top)/freq
		var t_right = (right - left)/freq	
		
		#Create table for tesselation vectors
		vertices.resize(f) 
		for i in range(f):
			vertices[i] = []
			vertices[i].resize(i+1)
		
		#Calculate vertices for tris of tesselation
		for i in range(f):
			for j in range(i+1):
				vertices[i][j]=(top+i*t_down + j*t_right)
		
		#Assign vertices to each tri of tesselation. 
		st.add_color(Color.white)
		#Top tri first, so that for loop below looks cleaner
		#That's because there is one row more tris pointing up than down.
		st.add_normal(vertices[0][0])
		st.add_vertex(vertices[0][0])
		st.add_normal(vertices[1][1])
		st.add_vertex(vertices[1][1])
		st.add_normal(vertices[1][0])
		st.add_vertex(vertices[1][0])
		for i in range(1, freq):
			#Tri's pointing up
			for j in range(i+1):
				st.add_normal(vertices[i][j])
				st.add_vertex(vertices[i][j])
				st.add_normal(vertices[i+1][j+1])
				st.add_vertex(vertices[i+1][j+1])
				st.add_normal(vertices[i+1][j])
				st.add_vertex(vertices[i+1][j])
			#Tri's pointing down
			for j in range(i):
				st.add_normal(vertices[i][j])
				st.add_vertex(vertices[i][j])
				st.add_normal(vertices[i][j+1])
				st.add_vertex(vertices[i][j+1])
				st.add_normal(vertices[i+1][j+1])
				st.add_vertex(vertices[i+1][j+1])

	func get_st():
		tesselate()
		return(st)
