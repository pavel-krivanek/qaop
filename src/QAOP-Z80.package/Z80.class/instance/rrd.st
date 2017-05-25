instructions
rrd 

	| v | 
	
	v := (env mem: HL) | (A << 8).
	time := time + 7.
	self f_szh0n0p: (A := A & 16rF0 | (v & 16r0F)).
	env mem: HL to: ((v bitShift: 4) & 16rFF).
	MP := HL + 1.
	time := time + 3. 