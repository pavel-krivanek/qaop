accessing
form

	| a y7_y6 y2_y0 y5_y3 addr f video |
	
	video :=  memory copyFrom: 16r4000 to: 16r57FF.
	f := Form extent: 256@192.

	a := 1.
	0 to: 191 do: [ :y |
		0 to: 31 do: [ :x |
			y7_y6 := y >> 6.
			y2_y0 := y bitAnd: 2r111.
			y5_y3 := (y >> 3) bitAnd: 2r111.
			addr := (x + (y7_y6*2048) + (y2_y0*256) + (y5_y3*32)).
			f bits byteAt: (a) put: (video at: addr + 1) .  
			a := a + 1
			 ]
		 ].

	^ f
