instructions
bit: n to: v

	| m |
	
	m := v & (1 <<n).
	Ff := Ff & 16rFF bitInvert32 | (v & F53) | m.
	Fa := (Fr := m) bitInvert32.
	Fb := 0.  