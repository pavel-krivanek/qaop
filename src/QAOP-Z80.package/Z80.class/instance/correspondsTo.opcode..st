testing
correspondsTo: aStateDictionary opcode: c	

	^ aStateDictionary associations reject: [ :assoc |
		| name |
		name := assoc key asSymbol.
		name = #c 
			ifTrue: [ assoc value = c ] 
			ifFalse: [ (self instVarNamed: name) = assoc value] ]

	