execution
stepWithComparison: aStateDictionary

	| c |
	
	R := R+1.
	c := env m1: PC ir: (IR | (R & 16r7F)).
	PC := (PC+1) char.
	time := time + 4.
	
	calledOpcodes add: c.

	self assert: (self correspondsTo: aStateDictionary opcode: c	) isEmpty.
	
	self opcodes01: c.
	self opcodes02: c.
	self opcodes03: c.
	self opcodes04: c.
	self opcodes05: c.
	self opcodes06: c.
 