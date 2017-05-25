instructions
f_szh0n0p: r

	"SZ5H3PNC
	xxx0xP0"
	
	Ff :=(Ff & 16rFF bitInvert32) | (Fr := r).
	Fa := r | 16r100.
	Fb := 0.