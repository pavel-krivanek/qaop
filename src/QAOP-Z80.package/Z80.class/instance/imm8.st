instructions
imm8

	| v |
	
	v := env mem: PC.
	PC := (PC+1) char.
	time := time + 3.
	^ v