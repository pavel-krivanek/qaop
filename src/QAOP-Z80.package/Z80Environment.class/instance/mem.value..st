as yet unclassified
mem: addr value: v

	addr < 16r4000 ifTrue: [ ^ self ].

	^ memory at: addr+1 put: v.