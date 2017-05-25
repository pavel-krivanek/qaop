execution
opcodes03: c
	
	c caseOf: { 
		[ 16r27 ] -> [ self daa ].
		[ 16r2F ] -> [ self cpl ].
		[ 16r37 ] -> [ self scf_ccf: 0 ].
		[ 16r3F ] -> [ self scf_ccf: (Ff & 16r100) ].
		[ 16r41 ] -> [ B := C ].
		[ 16r42 ] -> [ B := D ].
		[ 16r43 ] -> [ B := E ].
		[ 16r44 ] -> [ B := HL >>> 8 ].
		[ 16r45 ] -> [ B := HL & 16rFF ].
		[ 16r46 ] -> [ B := env mem: HL. time := time + 3 ].
		[ 16r47 ] -> [ B := A ].
		[ 16r48 ] -> [ C := B ].
		[ 16r4A ] -> [ C := D ].
		[ 16r4B ] -> [ C := E ].
		[ 16r4C ] -> [ C := HL >>> 8 ].
		[ 16r4D ] -> [ C := HL & 16rFF ].
		[ 16r4E ] -> [ C := env mem: HL. time := time + 3 ].
		[ 16r4F ] -> [ C := A ].
		[ 16r50 ] -> [ D := B ].
		[ 16r51 ] -> [ D := C ].
		[ 16r53 ] -> [ D := E ].
		[ 16r54 ] -> [ D := HL >>> 8 ].
		[ 16r55 ] -> [ D := HL & 16rFF ].
		[ 16r56 ] -> [ D := env mem: HL. time := time + 3 ].
		[ 16r57 ] -> [ D := A ].
		[ 16r58 ] -> [ E := B ].
		[ 16r59 ] -> [ E := C ].
		[ 16r5A ] -> [ E := D ].
		[ 16r5C ] -> [ E := HL >>> 8 ].
		[ 16r5D ] -> [ E := HL & 16rFF ].
		[ 16r5E ] -> [ E := env mem: HL. time := time + 3 ].
		[ 16r5F ] -> [ E := A ].
		[ 16r60 ] -> [ HL := (HL & 16rFF) | (B << 8) ].
		[ 16r61 ] -> [ HL := (HL & 16rFF) | (C << 8) ].
		[ 16r62 ] -> [ HL := (HL & 16rFF) | (D << 8) ].
		[ 16r63 ] -> [ HL := (HL & 16rFF) | (E << 8) ].
		[ 16r65 ] -> [ HL := (HL & 16rFF) | (((HL & 16rFF) << 8)) ].
		[ 16r66 ] -> [ HL := (HL & 16rFF) | (((env mem: HL) << 8)). time := time + 3. ].
		[ 16r67 ] -> [ HL := (HL & 16rFF) | (A << 8) ].
		[ 16r68 ] -> [ HL := (HL & 16rFF) | B ].
		[ 16r69 ] -> [ HL := (HL & 16rFF) | C ].
		[ 16r6A ] -> [ HL := (HL & 16rFF) | D ].
		[ 16r6B ] -> [ HL := (HL & 16rFF) | E ].
		[ 16r6C ] -> [ HL := (HL & 16rFF) | (HL >>> 8) ].		
 		[ 16r6E ] -> [ HL := (HL & 16rFF00) | (env mem: HL). time := time + 3. ].
 		[ 16r6F ] -> [ HL := (HL & 16rFF00) | A. time := time + 3. ].
 		[ 16r70 ] -> [ env mem: HL value: B. time := time + 3. ].
 		[ 16r71 ] -> [ env mem: HL value: C. time := time + 3. ].
 		[ 16r72 ] -> [ env mem: HL value: D. time := time + 3. ].
 		[ 16r73 ] -> [ env mem: HL value: E. time := time + 3. ].
 		[ 16r74 ] -> [ env mem: HL value: (HL >>> 8). time := time + 3. ].
 		[ 16r74 ] -> [ env mem: HL value: (HL & 16rFF). time := time + 3. ].
 		[ 16r76 ] -> [ self doHalt ].
 		[ 16r77 ] -> [ env mem: HL value: A. time := time + 3. ].
		[ 16r78 ] -> [ A := B ].
		[ 16r79 ] -> [ A := C ].
		[ 16r7A ] -> [ A := D ].
		[ 16r7B ] -> [ A := E ].
		[ 16r7B ] -> [ A := E ].
		[ 16r7C ] -> [ A := HL >>> 8 ].
		[ 16r7D ] -> [ A := HL & 16rFF ].
		[ 16r7E ] -> [ A := env mem: HL. time := time + 3].

} otherwise: [  ].