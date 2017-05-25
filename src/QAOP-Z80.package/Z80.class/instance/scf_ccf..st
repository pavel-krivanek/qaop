instructions
scf_ccf: x

	"may be wrong. see http://scratchpad.wikia.com/wiki/Z80"
	 
	Fa := Fa & FH bitInvert32.
	Fb := Fb & 16r80 | ((x bitShift: 4) bitXor: Fr) & FH.
	Ff := (16r100 bitXor: x) | (Ff & FS) | (A & F53).