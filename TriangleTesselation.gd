extends MeshInstance

# Member variables
export var side_length = 1.0
export(int) var freq = 1
export(Vector3) var start_point = Vector3(0,0,0)

var vertices = PoolVector3Array()

const hcoff = 0.86602540378


func vertex_at(vec):
	var x_coord=vec.x
	var y_coord=vec.y
	#var f = freq+1
	#var i = 0
	#for y in range(y_coord):
	#	i += f
	#	f -= 1
	#print("for-luuppi: "+str(i))
	#var i = (freq+1)*y_coord-(y_coord-1)*y_coord/2+x_coord
	return(y_coord*((freq+1)*y_coord-(y_coord-1))/2+x_coord)

func get_row(index):
	var f=freq+1
	var i = index
	while i >= f:
		i -= f
		f -= 1
	return(freq+1-f)

func get_column(index):
	var f = freq+1
	var i = index
	while i >= f:
		i -= f
		f -= 1
	return(i)
		
func get_xy(index):
	var f=freq+1
	var i = index
	while i >= f:
		i -= f
		f -= 1
	return(Vector2(i,freq+1-f))
	
func up_neighbours(index):
	#print("up_neighbours")
	var left = null
	var upper = null
	#if index+1<vertices.size():
	if index+1<vertices.size() && get_row(index) == get_row(index+1):
		#left = vertices[index+1]
		left = index+1
		print(get_xy(index)+Vector2.DOWN)
		#upper = vertices[vertex_at(get_xy(index)+Vector2.DOWN)] #Yeah, DOWN, really
		upper = vertex_at(get_xy(index)+Vector2.DOWN) #Yeah, DOWN, really
	return([left, upper])

func _ready():
	
	#print(vertex_at(0,2))
	
	var top = Vector3(0.5*side_length, hcoff*side_length, 0.0)
	var adj = Vector3(side_length, 0.0, 0.0)
	
	var t_top = top/freq
	var t_adj = adj/freq
	
	var f = freq+1
	print(freq)
	
	vertices.resize(f*(f+1)/2)
	#vertices.resize(freq*freq)
	#print(vertices.size())

	var i = 0
	for fv in range(f):
		for fh in range(f-fv):
			vertices[i]=(fh*t_adj + fv*t_top)
			i+=1
	#print(vertices)
	for i in range(f*(f+1)/2):
		print(str(i)+" : "+str(get_xy(i)))
		print("Neighbours: "+str(i)+" : "+str(up_neighbours(i)))
