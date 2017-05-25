accessing registers
r: v

	R := v.
	IR := IR & 16rFF00 | (v&16r80)