instructions
daa

	| h d |
	
	h := Fr bitXor: (Fa bitXor: (Fb bitXor: (Fb >> 8))) & FH.
	d := 0.
	((A | Ff & 16r100) > 16r99) ifTrue: [ d := 16r160 ].
	((A & 16rF | h) > 9) ifTrue: [ d := d + 6 ].
	
	Fa := A | 16r100. "parity"
	((Fb & 16r200) = 0) 
		ifTrue: [ A := A + (Fb := d) ]
		ifFalse: [ A := A - d. Fb := d bitInvert32 ].
	Ff := (Fr := (A := A & 16rFF)) | (d & 16r100).
	