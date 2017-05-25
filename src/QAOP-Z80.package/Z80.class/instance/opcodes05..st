execution
opcodes05: c
		
	c caseOf: { 
		[ 16rC0 ] -> [ 
			time := time + 1.
			(Fr ~= 0) ifTrue: [ MP := PC := self pop ] ].
} 