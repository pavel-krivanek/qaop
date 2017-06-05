instructions
ldir: i if: aBoolean

	| a v |
	
	v := env mem: (a := HL).
	HL := (a+i) char.
	time := time + 3.
	env mem: (a := self de) value: v.
	self de: (a+i) char.
	time := time + 5.
	
	(Fr ~= 0) ifTrue: [ Fr := 1 ] "keep Z".
	v := v + A.
	Ff := (Ff & F53 bitInvert) | (v & F3) | ( v << 4 & F5).
	
	self bc: (a := (self bc - 1) char).
	v := 0.
	(a ~= 0) ifTrue: [ 
		aBoolean ifTrue: [ 
			time := time + 5.
			MP := (PC := (PC-2) char) + 1 ].
		v := 16r80. ].
	Fa := Fb := v.