stack
push: v

	| sp |
	time := time + 1.
	sp := SP.
	env mem: sp-1 value: (v >>> 8). 
	time := time + 3.
	env mem: sp-2 value: (v & 16rFF). 
	time := time + 3.