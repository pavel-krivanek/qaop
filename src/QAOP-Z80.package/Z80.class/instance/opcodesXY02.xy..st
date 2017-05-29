execution
opcodesXY02: c xy: aXY
	
	| v xy |

	xy := aXY.
	
	c caseOf: { 
		[ 16r34 ] -> [ 
			| a | 
			v := self inc: (env mem: (a := self getd: xy)).
			time := time + 4.
			env mem: a value: v.
			time := time + 3. ].
		[ 16r35 ] -> [ 
			| a | 
			v := self dec: (env mem: (a := self getd: xy)).
			time := time + 4.
			env mem: a value: v.
			time := time + 3. ].
		[ 16r36 ] -> [ 
			| a | 
			a := (xy + (env mem: PC) char).
			time := time + 3.
			v := (env mem: (PC + 1)) char.
			env mem: a value: v.
			PC := (PC + 2) char.
			time := time + 3. ].

 } otherwise: [  ].

	^ xy