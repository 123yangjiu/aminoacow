class_name Heap

var arr
var cmp : Callable
var n

func _init(_cmp : Callable) -> void:
	cmp = _cmp
	arr = [0]
	n = 0
	
func empty() -> bool:
	return n == 0
	
func push(x) -> void:
	#print("Pushing...")
	arr.push_back(x)
	n += 1
	var i = n
	while (i > 1):
		if cmp.call(x, arr[i >> 1]):
			#print("Push swap ", i, " ", (i >> 1))
			var t = arr[i >> 1]
			arr[i >> 1] = x
			arr[i] = t
			i >>= 1
		else:
			break
	#print("Done")

func pop():
	#print("Poping ...")
	var R = arr[1]
	arr[1] = arr[n]
	arr.pop_back()
	n -= 1
	var i = 1
	while (i + i <= n):
		var nxt = i + i
		if (nxt < n and not cmp.call(arr[nxt], arr[nxt + 1])):
			nxt += 1
		if (cmp.call(arr[i], arr[nxt])):
			break
		#print("Pop swap ", i, " ", nxt)
		var t = arr[nxt]
		arr[nxt] = arr[i]
		arr[i] = t
		i = nxt
	#print("Done")
	return R
