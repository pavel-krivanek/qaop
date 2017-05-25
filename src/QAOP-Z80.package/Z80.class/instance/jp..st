instructions
jp: aBoolean

	| a | 
	
	a := MP := self imm16.
	aBoolean ifTrue: [ PC := a ].