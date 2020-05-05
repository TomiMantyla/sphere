class MeshManipulator: #What should it extend? MeshDataTool?

	var mmesh #Ehkä turha
	var mdt = MeshDataTool.new() #Voitaisiin ehkä välittää viittauksena, eikä luoda uutta


	func _init(mesh0):
		mmesh = mesh0
		mdt.create_from_surface(mmesh, 0)

	func get_neighbours(index):
		var edges = mdt.get_vertex_edges(index)
		var vertices = []
		for e in edges:
			if mdt.get_edge_vertex(e,0)!=index:
				vertices.append(mdt.get_edge_vertex(e, 0))
			if mdt.get_edge_vertex(e,1)!=index:
				vertices.append(mdt.get_edge_vertex(e, 1))
		return vertices
	
	func get_far_neighbours(index):
		var neigh=get_neighbours(index)
		var nneig = []
		for n in neigh:
			nneig += get_neighbours(n)
		neigh.append(index)
		var nni = 0
		while nni < nneig.size():
			if neigh.has(nneig[nni]):
				nneig.remove(nni)
			else:
				nni+=1
		nni = 0
		var values = []
		for nn in nneig:
			if !values.has(nn):
				values.append(nn)
		for v in values:
			nneig.erase(v)
		return nneig
	
	func get_far_far_neighbours(index):
		var neigh=get_far_neighbours(index)
		var nneig = []
		for n in neigh:
			nneig += get_far_neighbours(n)
		neigh.append(index)
		var nni = 0
		while nni < nneig.size():
			if neigh.has(nneig[nni]):
				nneig.remove(nni)
			else:
				nni+=1
		nni = 0
		var values = []
		for nn in nneig:
			if !values.has(nn):
				values.append(nn)
		for v in values:
			nneig.erase(v)
		return nneig
	
	
	func dijkstra(start_index):
		var vcount = mdt.get_vertex_count()
		var dist = []
		dist.resize(vcount)
		var prev = []
		prev.resize(vcount)
		var q = []
		q.resize(vcount)
		for i in range(vcount):
			dist[i] = 9223372036854775807
			q[i] = i 
		dist[start_index] = 0
		while q.size()>0:
			var min_dist = 9223372036854775807
			var u
			for v in q:
				if dist[v]<min_dist:
					min_dist = dist[v]
					u = v
			q.remove(q.find(u))
			
			
			var neighbours = get_neighbours(u)
			for v in neighbours:
				var alt = dist[u] + 1
				if alt<dist[v]:
					dist[v] = alt
					prev[v] = u
		return([dist, prev])
	
	func copy_vertex(v):
		pass
	
	
	func combine_vertices(v, u):
		pass
		
	func proximity_indexer(separation): #Combines close by vertexes and reindexes mesh
		var arrays = mmesh.surface_get_arrays(0)
		var vertices = arrays[ArrayMesh.ARRAY_VERTEX]
		var vdup = []
		vdup.resize(vertices.size())
		var indices = arrays[ArrayMesh.ARRAY_INDEX]
		var normals = arrays[ArrayMesh.ARRAY_NORMAL]
		var colors = arrays[ArrayMesh.ARRAY_COLOR]
		var vcount = vertices.size()
		var ss = separation*separation
		
		var v = 0
		while v<vertices.size():
			var u = v+1
			while u<vertices.size():
			#for u in range (v+1, vertices.size()):
				if (vertices[v]-vertices[u]).length_squared()<ss:
					vertices[u] = vertices[v]
#					vertices.remove(u)
#					for i in range(indices.size()):
#						if indices[i]>u:
#							indices[i]-=1
							#print(indices[i])
					#vcount-=1
					#print(str(v)+ ", " +str(u))
					if indices!=null:
						var i = 0
						while i<indices.size():
						#for i in range(indices.size()):
							if indices[i] == u:
								var tri_i = i-i%3
								if indices[tri_i] == v || indices[tri_i+1] == v || indices[tri_i+2] == v:
									print(tri_i)
									indices.remove(tri_i)
									indices.remove(tri_i+1)
									indices.remove(tri_i+2)
									i = tri_i-1
								else:
									indices[i] = v
							i+=1
							#print(i)
#					u-=1
				u+=1
			v+=1
		for v in range(vertices.size()-1, 0, -1):
			var orphan = true
			for i in range(indices.size()):
				if indices[i] == v:
					orphan = false
					break
			if orphan:
				vertices.remove(v)
				normals.remove(v)
				colors.remove(v)
				#print(v)
				for i in range(indices.size()):
					if indices[i]>=v:
						indices[i]-=1
		
		
		#print("ulos!")
		#print(vertices)
		#print(indices.size())
		var arr_mesh = ArrayMesh.new()
		arrays = []
		arrays.resize(ArrayMesh.ARRAY_MAX)
		arrays[ArrayMesh.ARRAY_VERTEX] = vertices
		arrays[ArrayMesh.ARRAY_NORMAL] = normals
		arrays[ArrayMesh.ARRAY_INDEX] = indices
		arrays[ArrayMesh.ARRAY_COLOR] = colors
		arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
		mmesh = arr_mesh
		mdt.create_from_surface(mmesh, 0)
		return mmesh
