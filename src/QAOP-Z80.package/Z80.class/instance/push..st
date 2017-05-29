adding
push: v

	| sp |
	time := time + 1.
	sp := SP.
	env mem: (sp-1) char value: (v >>> 8). 
	time := time + 3.
	SP := (sp-2) char
	env mem: SP value: (v & 16rFF). 
	time := time + 3.