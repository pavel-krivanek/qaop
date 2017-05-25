execution
reset

	halted := false.
	PC := SP := A := B := C := D := E := HL := A_ := B_ := C_ := D_
		:= E_ := HL_ := IX := IY := IR := R := MP := Ff := Fr := Fa 
		:= Fb := Ff_ := Fr_ := Fa_ := Fb_ := IFF 
		:= 0. 
"	PC := IFF := IM := 0."
	self af: (SP := 16rFFFF).