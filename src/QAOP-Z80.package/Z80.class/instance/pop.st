stack
pop

	| sp v |
	
	sp := SP.
	v := env mem16: (sp).
	SP := sp + 2.
	time := 6.
	^ v