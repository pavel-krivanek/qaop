stack
push: v

	| sp |
	time := time + 1.
	sp := SP.
	env mem: sp-1 to: (v bitShift: 8). 
	time := time + 3.
	env mem: sp-2 to: (v & 16rFF). 
	time := time + 3.