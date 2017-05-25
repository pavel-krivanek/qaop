accessing structure variables
flags: f

	| tempF |
	Fr := f bitInvert32 & FZ.
	tempF := f << 8.
	Ff := tempF.
	Fa := 16rFF & (Fb := f & 16r80 bitInvert32 | ((f&FP)<<5))