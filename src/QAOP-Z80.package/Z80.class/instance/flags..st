accessing structure variables
flags: f

	| tempF |
	Fr := f bitInvert & FZ.
	tempF := f | (f << 8).
	Ff := tempF.
	Fa := 16rFF & (Fb := tempF & 16r80 bitInvert | ((tempF&FP)<<5))