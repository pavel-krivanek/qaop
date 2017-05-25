instructions
rld 

	| v | 
	
	v := ((env mem: HL) << 4) | (A & 16r0F).
	time := time + 7.
	self f_szh0n0p: (A := A & 16rF0 | (v bitShift: 8)).
	env mem: HL to: (v & 16rFF).
	MP := HL + 1.
	time := time + 3. 