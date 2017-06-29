removing
pop

	| sp v |

	sp := SP.
	v := env mem16: (sp).
	SP := (sp + 2) char.
	time := time + 6.
	^ v