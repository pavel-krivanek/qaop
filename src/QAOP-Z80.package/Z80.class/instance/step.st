execution
step

	| c |
	
	R := R+1.
	c := env m1: PC ir: (IR | (R & 16r7F)).
	PC := (PC+1) char.
	time := time + 4.
	
	self opcodes01: c.
	self opcodes02: c.
 