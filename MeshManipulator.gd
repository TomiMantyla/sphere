class MeshManipulator: #What should it extend? MeshDataTool?

	var mmesh 
	var mdt = MeshDataTool.new()


	func _init(mesh0):
		mmesh = mesh0
		mdt.create_from_surface(mmesh, 0)

	func get_neighbours(index):
	#Finds and returns neighbours of given vertex
		var edges = mdt.get_vertex_edges(index)
		var vertices = []
		for e in edges:
			if mdt.get_edge_vertex(e,0)!=index:
				vertices.append(mdt.get_edge_vertex(e, 0))
			if mdt.get_edge_vertex(e,1)!=index:
				vertices.append(mdt.get_edge_vertex(e, 1))
		return vertices
	
	func get_far_neighbours(index):
	#Finds neighbours of neighbours of vertex,
	#or vertices two steps away.
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
		var indices = arrays[ArrayMesh.ARRAY_INDEX]
		var normals = arrays[ArrayMesh.ARRAY_NORMAL]
		var colors = arrays[ArrayMesh.ARRAY_COLOR]
		#var vcount = vertices.size()
		var ss = separation*separation
		
		var v = 0
		while v<vertices.size():
			var u = v+1
			while u<vertices.size():
				if (vertices[v]-vertices[u]).length_squared()<ss:
					vertices[u] = vertices[v]
					if indices!=null:
						var i = 0
						while i<indices.size():
							if indices[i] == u:
								var tri_i = i-i%3
								if indices[tri_i] == v || indices[tri_i+1] == v || indices[tri_i+2] == v:
									indices.remove(tri_i)
									indices.remove(tri_i+1)
									indices.remove(tri_i+2)
									i = tri_i-1
								else:
									indices[i] = v
							i+=1
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
				for i in range(indices.size()):
					if indices[i]>=v:
						indices[i]-=1
						
		arrays.clear()
		arrays.resize(ArrayMesh.ARRAY_MAX)
		arrays[ArrayMesh.ARRAY_VERTEX] = vertices
		arrays[ArrayMesh.ARRAY_NORMAL] = normals
		arrays[ArrayMesh.ARRAY_INDEX] = indices
		arrays[ArrayMesh.ARRAY_COLOR] = colors
		mmesh.surface_remove(0)
		mmesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
		mdt.create_from_surface(mmesh, 0)
		return mmesh

	func deindex():
		var arrays = mmesh.surface_get_arrays(0)
		var vertices = arrays[ArrayMesh.ARRAY_VERTEX]
		var indices = arrays[ArrayMesh.ARRAY_INDEX]
		var normals = arrays[ArrayMesh.ARRAY_NORMAL]
		var colors = arrays[ArrayMesh.ARRAY_COLOR]
		var niver = PoolVector3Array()
		var ninor = PoolVector3Array()
		var nicol = PoolColorArray()
		niver.resize(indices.size())
		ninor.resize(indices.size())
		nicol.resize(indices.size())
		for i in range(indices.size()):
			niver[i] = vertices[indices[i]]
			ninor[i] = normals[indices[i]]
			nicol[i] = colors[indices[i]]
		arrays.clear()
		arrays.resize(ArrayMesh.ARRAY_MAX)
		arrays[ArrayMesh.ARRAY_VERTEX] = niver
		arrays[ArrayMesh.ARRAY_NORMAL] = ninor
		arrays[ArrayMesh.ARRAY_INDEX] = null
		arrays[ArrayMesh.ARRAY_COLOR] = nicol
		mmesh.surface_remove(0)
		mmesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
		mdt.create_from_surface(mmesh, 0)
		return(mmesh)
