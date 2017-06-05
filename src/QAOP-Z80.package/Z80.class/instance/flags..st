accessing structure variables
flags: f

	| tempF |
	Fr := f bitInvert & FZ.
	tempF := f | (f << 8).
	Ff := tempF.
	Fa := 16rFF & (Fb := f & 16r80 bitInvert | ((f&FP)<<5))