instructions
imm16

	| v |
	
	v := env mem16: PC.
	PC := (PC+2) char.
	time := time + 6.
	^ v