instructions
doHalt

	| n |
	halted := true.
	n := (time_limit - time + 3) >> 2.
	(n > 0) ifTrue: [ 
		n := env halt: n ir: (IR | R & 16r7F).
		R := R + n.
		time := time + 4 * n. ].