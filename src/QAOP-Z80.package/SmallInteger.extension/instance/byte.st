*QAOP-Z80
byte

	^ (self > 128) ifTrue: [ self - 256  ] ifFalse: [ self ]
	
