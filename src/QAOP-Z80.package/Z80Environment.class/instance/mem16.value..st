as yet unclassified
mem16: addr value: v

	addr < 16r4000 ifTrue: [ ^ self ].

	memory at: addr+1 put: (v & 16rFF).
	memory at: addr+2 put: (v >> 8).
