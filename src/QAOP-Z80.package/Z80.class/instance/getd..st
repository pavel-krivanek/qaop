instructions
getd: xy

	| d | 
	d := env mem: PC.
	PC := (PC+1) char.
	time := time + 8.
	^ MP := (xy + (d bitAnd: 16rFF)) bitAnd: 16rFF.