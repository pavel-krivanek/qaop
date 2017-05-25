instructions
call: aBoolean

	| a | 
	
	a := MP := self imm16.
	aBoolean ifTrue: [ 
		self push: PC.
		PC := a. ].