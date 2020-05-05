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
	hexify_color()
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
	var visited = []
	var faces
	for f in mdt.get_face_count():
		if mdt.get_vertex_color(mdt.get_face_vertex(f, 0)) == Color.black ||  mdt.get_vertex_color(mdt.get_face_vertex(f, 1)) == Color.black ||  mdt.get_vertex_color(mdt.get_face_vertex(f, 2)) == Color.black:
			mdt.set_vertex_color(mdt.get_face_vertex(f, 0), Color.black)
			mdt.set_vertex_color(mdt.get_face_vertex(f, 1), Color.black)
			mdt.set_vertex_color(mdt.get_face_vertex(f, 2), Color.black)
		
func _process(delta): 
	
#	if full_circle > TAU:
#		mdt.set_vertex_color(prev_i, Color.white)
#		mdt.set_vertex_color(color_index, Color.blue)
#		prev_i = color_index
#		color_index = (color_index+1)%12
#		mdt.commit_to_surface(m)
#		m.surface_remove(0)
#		mesh = m
#		full_circle = 0
	rotate_y(delta*0.5)
	#rotate_x(delta*0.3)
#	full_circle +=delta

class TriTess extends MeshInstance:

	var freq = 1
	
	var top 
	var right
	var left 

	var tri_mesh
	var vertices = []
	var st
	
	var colors = [Color.red, Color.blue, Color.white, Color.black, Color.magenta, Color.cyan]
	
	func meshify():

		st.add_color(Color.white)
		st.add_normal(vertices[0][0])
		st.add_vertex(vertices[0][0])
		st.add_normal(vertices[1][1])
		st.add_vertex(vertices[1][1])
		st.add_normal(vertices[1][0])
		st.add_vertex(vertices[1][0])
		var f = freq+1
		var c = 2
		for i in range(1, freq):
			for j in range(i+1):
				#Ensin ylöspäin osoittavat kolmiot
				#c+=1
				#st.add_color(colors[randi() % colors.size()])
				#print("index: "+str(c)+", "+str(i)+", "+str(j)+" = "+str(i*freq+j))
				st.add_normal(vertices[i][j])
				st.add_vertex(vertices[i][j])
				#c+=2
				#print("index: "+str(c)+", "+str(i)+", "+str(j)+" = "+str((i+1)*freq+j+1))
				st.add_normal(vertices[i+1][j+1])
				st.add_vertex(vertices[i+1][j+1])
				#c-=1
				#print("index: "+str(c)+", "+str(i)+", "+str(j)+" = "+str((i+1)*freq+j))
				st.add_normal(vertices[i+1][j])
				st.add_vertex(vertices[i+1][j])
				#Sitten alaspäin osoittavat kolmiot
			for j in range(i):
				#st.add_color(colors[randi() % colors.size()])
				st.add_normal(vertices[i][j])
				st.add_vertex(vertices[i][j])
				st.add_normal(vertices[i][j+1])
				st.add_vertex(vertices[i][j+1])
				st.add_normal(vertices[i+1][j+1])
				st.add_vertex(vertices[i+1][j+1])
		#st.generate_normals()
	
	func meshify_flat():
		
		#Use average normal
		var normal = (top+right+left)/3
		
		
		st.add_color(Color.white)
#		st.add_normal(vertices[0][0])
		st.add_normal(normal)
		st.add_vertex(vertices[0][0])
#		st.add_normal(vertices[1][1])
		st.add_vertex(vertices[1][1])
#		st.add_normal(vertices[1][0])
		st.add_vertex(vertices[1][0])
		var f = freq+1
		var c = 2
		for i in range(1, freq):
			#Ensin ylöspäin osoittavat kolmiot
			for j in range(i+1):
				#c+=1
				#st.add_color(colors[randi() % colors.size()])
				#print("index: "+str(c)+", "+str(i)+", "+str(j)+" = "+str(i*freq+j))
				st.add_vertex(vertices[i][j])
				#c+=2
				#print("index: "+str(c)+", "+str(i)+", "+str(j)+" = "+str((i+1)*freq+j+1))
				st.add_vertex(vertices[i+1][j+1])
				#c-=1
				#print("index: "+str(c)+", "+str(i)+", "+str(j)+" = "+str((i+1)*freq+j))
				st.add_vertex(vertices[i+1][j])
			#Sitten alaspäin osoittavat kolmiot
			for j in range(i):
				#st.add_color(colors[randi() % colors.size()])
#				st.add_normal(vertices[i][j])
				st.add_vertex(vertices[i][j])
#				st.add_normal(vertices[i][j+1])
				st.add_vertex(vertices[i][j+1])
#				st.add_normal(vertices[i+1][j+1])
				st.add_vertex(vertices[i+1][j+1])
	
	func get_st():
		calculate_vertices()
		return(st)

	
	func _init(surface_tool, v0, v1, v2, frequence=1):
		top = v0
		right = v1
		left = v2
		freq = frequence
		st = surface_tool
		randomize ( )
		
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
		meshify()
	
