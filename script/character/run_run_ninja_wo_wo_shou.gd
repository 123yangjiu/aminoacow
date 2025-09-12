extends Ninja

var UP = Vector2i(0, -1)
var DOWN = Vector2i(0, 1)
var LEFT = Vector2i(-1, 0)
var RIGHT = Vector2i(1, 0)
var SpeedXMax = 200.0

func dis(x : Vector2i, y : Vector2i):
	return (x.x - y.x) * (x.x - y.x) + (x.y - y.y) * (x.y - y.y)
	
func disR(x : Vector2, y : Vector2):
	return (x.x - y.x) * (x.x - y.x) + (x.y - y.y) * (x.y - y.y)
	
func checkBlockCanStand(P : Vector2i):
	return tileMap.get_cell_source_id(P) == -1 && tileMap.get_cell_source_id(P + DOWN) != -1

func checkBlockEmpty(P : Vector2i):
	#print("Checking Empty ", P, " ", tileMap.get_cell_source_id(P))
	return tileMap.get_cell_source_id(P) == -1

func getSpeed(i, j, fixCollision = false):
	var g = get_gravity().y
	var blockSize = (tileMap.map_to_local(Vector2i(1, 0)) - \
		tileMap.map_to_local(Vector2i(0, 0))).x
	#print("G ", g, " blockSize ", blockSize)
	
	var Vy : float
	var t : float
	var Vx : float
	
	if j < 0:
		# Vy^2 / 2g = -j * blockSize
		if j == 0:
			j = -1
		if fixCollision:
			j -= 0.7 if j < -1 else 1
		Vy = -sqrt(- j * blockSize * 2 * g)
		t = - Vy / g
		Vx = i * blockSize / t
		if fixCollision:
			Vx = (i - sign(i)) * blockSize / t
	elif j > 0:
		# g t^2 / 2 = j * blockSize
		Vy = 0
		t = sqrt(j * blockSize * 2 / g)
		Vx = i * blockSize / t
		if fixCollision:
			Vx = (i - sign(i) * 1.2) * blockSize / t
	return Vector2(Vx, Vy)
		
func checkReachable(P : Vector2i, i, j):
	#print("Checking Reachable ", i, j)
	var speed = getSpeed(i, j)
	#print("Got speed ", speed)
	var g = get_gravity().y
	var blockSize = (tileMap.map_to_local(Vector2i(1, 0)) - \
		tileMap.map_to_local(Vector2i(0, 0))).x
	
	if speed.x > SpeedXMax:
		return false
	
	var sign = 1 if i > 0 else -1
	var prevY = P.y
	var steps = 10
	var pos = tileMap.map_to_local(P)
	for x in range(absi(i) * steps + 1):
		var dy : float
		var t = x * sign * blockSize / speed.x / steps
		dy = speed.y * t + g * t * t / 2.0
		var blk = tileMap.local_to_map(pos + Vector2(t * speed.x, dy))
		if not checkBlockEmpty(blk):
			return false
		
	
	return true

func searchTarget():
	var targetBlock = tileMap.local_to_map(player.position)
	var currentBlock = tileMap.local_to_map(position)
	print("Searching...", targetBlock)
	
	var heap = Heap.new(func(x : Array, y : Array):
		return dis(x[1], targetBlock) < dis(y[1], targetBlock)
		)
	
	#for D in [UP, DOWN, LEFT, RIGHT]:
		#if (checkBlockCanStand(currentBlock + D)):
			#heap.push([D, currentBlock + D])
	heap.push([Vector2i.ZERO, currentBlock])
	var next = Vector2i.ZERO
	var counter = 0
	var visited = []
	while not heap.empty() and counter < 10:
		counter += 1
		var S = heap.pop()
		if (S[1] in visited):
			continue
		visited.push_back(S[1])
		print("Heap POP ", S)
		next = S[0]
		if S[1] == targetBlock:
			break
		
		var bnd = 6
		for i in range(-bnd, bnd + 1):
			for j in range(-bnd, bnd + 1):
				if i == 0 and j == 0:
					continue
				if i == 0: continue
					
				var nxt = S[1] + Vector2i(i, j)
				if checkReachable(S[1], i, j) and checkBlockCanStand(nxt):
					#print("YES !!", S[1], " ", i, " ", j)
					heap.push(
						[
							Vector2i(i, j) if S[0] == Vector2i.ZERO else S[0],
							nxt
						])
	
	print("Next Reach to ", next)
	if next == Vector2i(0, 0):
		return [currentBlock + next, Vector2.ZERO]
		
	var speed = getSpeed(next.x, next.y, true)
	var sign = 1 if next.x > 0 else -1
	if next.y == 0 and checkBlockCanStand(currentBlock + Vector2i(sign, 0)):
		speed = Vector2i(sign, 0) * 100
	return [currentBlock + next, speed]

var counter = 0
var reachTo = TYPE_NIL
func _physics_process(delta: float) -> void:
	if is_on_floor() and (not is_instance_of(reachTo, TYPE_VECTOR2I) or counter > 20):
		var next = searchTarget()
		reachTo = next[0]
		print(reachTo)
		velocity = next[1]
		counter = 0
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
	counter += 1
	
	if is_instance_of(reachTo, TYPE_VECTOR2I):
		print(position, " ", tileMap.map_to_local(reachTo), " ", dis(position, tileMap.map_to_local(reachTo)))
		
	if is_instance_of(reachTo, TYPE_VECTOR2I) \
		and dis(position, tileMap.map_to_local(reachTo)) < 1.2:
		reachTo = TYPE_NIL
	
	if is_instance_of(reachTo, TYPE_VECTOR2I):
		velocity = velocity.move_toward(player.position, 1)
		
