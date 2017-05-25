instructions
jr: aBoolean

	| pc d | 
	
	pc := PC.
	d := (env mem: pc) byte.
	time := time + 8.
	MP := PC := (pc + d + 1) char