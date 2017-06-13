execution
group_xy: c0

	[
		| xy c |
		xy := (c0 == 16rD0) ifTrue: [ IX ] ifFalse: [ IY ].
		c := env m1: PC ir: (IR | (IR | R & 16r7F)). 
		R := R+1.
		PC := (PC+1) char.
		time := time + 4.
		xy := self opcodesXY01: c xy: xy.
		xy := self opcodesXY02: c xy: xy.
		xy := self opcodesXY03: c xy: xy.
		xy := self opcodesXY04: c xy: xy.
		xy := self opcodesXY05: c xy: xy.
		(c0 = 16rDD) ifTrue: [ IX := xy ] ifFalse: [ IY := xy ].
		^ self.
	] repeat.