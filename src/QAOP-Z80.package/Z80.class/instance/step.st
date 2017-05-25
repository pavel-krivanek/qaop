execution
step

	| v c |
	
	R := R+1.
	c := env m1: PC ir: (IR | (R & 16r7F)).
	PC := (PC+1) char.
	time := time + 4.
	
	c caseOf: { 
		[ 16r08 ] -> [ self ex_af ].
		[ 16r10 ] -> [ | d | 
			time := time + 1. 
			v := PC. 
			d := env mem: v. 
			v := v + 1.
			time := time + 3.
			((B := (B - 1) & 16rFF ) ~= 0) ifTrue: [
				time := time + 5. MP := (v := v + d)  ].
			PC := v char.
			 ].	
		[ 16r18 ] -> [ 
			MP := PC := ( PC + 1 + (env mem: PC) byte ) char.
			time := time + 8. ].
		[ 16r09 ] -> [ HL := self add16: HL with: (B << 8 | C) ].
		[ 16r19 ] -> [ HL := self add16: HL with: (D << 8 | E) ].
		
 } 