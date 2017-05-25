instructions
inir_otir: op

	"op: 101rd01o"
	
	| bc hl d v x |
	
	hl := (HL + (d := (((op & 8) = 0) ifTrue: [1] ifFalse: [-1])) ) char.
	bc :=  (B << 8) | C.
	time := time + 1.
	((op & 1) = 0) 
		ifTrue: [ 
			v := env in: bc.
			time := time + 4.
			MP := bc + d.
			bc := (bc - 256) char.
			env mem: HL to: v.
			time := time + 3.
			d := d + bc ]
		ifFalse: [ 
			v := env mem: HL.
			time := time + 3.
			bc := (bc - 256) char.
			MP := bc + d.
			env out: bc value: v.
			time := time + 4.
			d := hl ].
		
		d := (d & 16rFF) + v.
		HL := hl.
		B := (bc := bc >> 8).
		((op > 16rB0) and: [ bc > 0 ]) ifTrue: [ 
			time := time + 5.
			PC := (PC - 2) char ].
		x := (d & 7) bitXor: bc.
		Ff := bc | (d := d & 16r0100).
		Fa := (Fr := bc) bitXor: 16r80.
		x := 16r4B3480 >> (((x bitXor: x) bitShift: 4) & 15).
		Fb := ((x bitXor: bc) & 16r80) | (d bitShift: 4) | ((v & 16r80) << 2).
	