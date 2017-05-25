instructions
cpir: i if: aBoolean

	| a b v |
	
	v := A - (b := env mem: (a := HL)) & 16rFF.
	MP := MP + 1.
	HL := (a+i) char.
	time := time + 8.
	
	Fr := v & 16r7F | (v >>> 7).
	Fb := (b | 16r80) bitInvert32.
	Fa := A & 16r7F.
	
	self bc: (a := (self bc - 1) char).
	(a ~= 0) ifTrue: [
		Fa := Fa | 16r80.
		Fb := Fb | 16r80. 
		(aBoolean and: [v ~= 0]) ifTrue: [ 
			MP := (PC := (PC-2) char) + 1.
			time := time + 5. ] ].
	
	Ff := (Ff & (16rFF bitInvert32)) | (v & F53 bitInvert32 ).
	((((v bitXor: b) bitXor: A) & FH) ~= 0) ifTrue: [ v := v - 1 ].
	Ff := Ff | (v << 4 & 26r20 ) | (v & 8).