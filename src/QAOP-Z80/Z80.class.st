Class {
	#name : #Z80,
	#superclass : #Object,
	#instVars : [
		'env',
		'PC',
		'SP',
		'A',
		'B',
		'C',
		'D',
		'E',
		'HL',
		'A_',
		'B_',
		'C_',
		'D_',
		'E_',
		'HL_',
		'IX',
		'IY',
		'IR',
		'R',
		'MP',
		'Ff',
		'Fr',
		'Fa',
		'Fb',
		'Ff_',
		'Fr_',
		'Fa_',
		'Fb_',
		'IFF',
		'IM',
		'halted',
		'time',
		'time_limit',
		'calledOpcodes'
	],
	#classVars : [
		'F3',
		'F5',
		'F53',
		'FC',
		'FH',
		'FN',
		'FP',
		'FS',
		'FZ'
	],
	#category : 'QAOP-Z80'
}

{ #category : #initialization }
Z80 class >> forEnvironment: aZ80Environment [

	^ self new 
		env: aZ80Environment;
		yourself.
]

{ #category : #initialization }
Z80 class >> initializeConstants [

	"self initializeConstants"

	FC := 16r01.
	FN := 16r02.
	FP := 16r04.
	F3 := 16r08.
	FH := 16r10.
	F5 := 16r20.
	FZ := 16r40.
	FS := 16r80.
	F53 := 16r28.
	
]

{ #category : #'accessing registers' }
Z80 >> a [ 
	^ A
]

{ #category : #'accessing registers' }
Z80 >> a: v [

	A = v.
]

{ #category : #instructions }
Z80 >> adc: b [

	A := Fr := (Ff := (Fa := A) + (Fb := b) + ((Ff >>> 8) & FC)) & 16rFF
]

{ #category : #instructions }
Z80 >> adc_hl: b [

	| a r |
	
	r := (a := HL) + b + ((Ff >>> 8) @ FC).
	Ff := r >>> 8.
	Fa := a >>> 8.
	Fb := b >>> 8.
	HL := r := r char.
	Fr := (r >>> 8) | (r << 8).
	MP := a + 1.
	time := time + 7.
]

{ #category : #instructions }
Z80 >> add16: a with: b [

	| r |
	
	r := a + b.
	Ff := (Ff & FS) | ((r >>> 8) & 16r128).
	Fa := Fa & FH bitInvert.
	Fb := (Fb & 16r80) | (((((r bitXor: a) bitXor: b) >>> 8) bitXor: Fr) & FH).
	MP := a+1.
	time := time + 7.
	^ r char
]

{ #category : #instructions }
Z80 >> add: b [

	A := Fr := (Ff := (Fa := A) + (Fb := b)) & 16rFF
]

{ #category : #'accessing registers' }
Z80 >> af [

	^ A << 8 | self flags
]

{ #category : #'accessing registers' }
Z80 >> af: v [

	A := v >>> 8.
	self flags: v &16rFF.
]

{ #category : #instructions }
Z80 >> and: b [

	Fa := (A := Ff := Fr := A & b) bitInvert.
	Fb := 0
]

{ #category : #'accessing registers' }
Z80 >> bc [
	^ B << 8 | C
]

{ #category : #'accessing registers' }
Z80 >> bc: v [

	C := v&16rFF.
	B := v >>> 8.
	
]

{ #category : #instructions }
Z80 >> bit: n to: v [

	| m |
	
	m := v & (1 << n).
	Ff := Ff & 16rFF bitInvert | (v & F53) | m.
	Fa := (Fr := m) bitInvert.
	Fb := 0.  
]

{ #category : #instructions }
Z80 >> call: aBoolean [

	| a | 
	
	a := MP := self imm16.
	aBoolean ifTrue: [ 
		self push: PC.
		PC := a. ].
]

{ #category : #testing }
Z80 >> correspondsTo: aStateDictionary opcode: c [	

	^ aStateDictionary associations reject: [ :assoc |
		| name |
		name := assoc key asSymbol.
		name = #c 
			ifTrue: [ assoc value = c ] 
			ifFalse: [ (self instVarNamed: name) = assoc value] ]

	
]

{ #category : #instructions }
Z80 >> cp: b [

	| r |
	r := (Fa := A) - b.
	Fb := b bitInvert.
	Ff := (r & (F53 bitInvert)) | (b & F53).
	Fr := r & 16rFF.
]

{ #category : #instructions }
Z80 >> cpir: i if: aBoolean [

	| a b v |
	
	v := A - (b := env mem: (a := HL)) & 16rFF.
	MP := MP + 1.
	HL := (a+i) char.
	time := time + 8.
	
	Fr := v & 16r7F | (v >>> 7).
	Fb := (b | 16r80) bitInvert.
	Fa := A & 16r7F.
	
	self bc: (a := (self bc - 1) char).
	(a ~= 0) ifTrue: [
		Fa := Fa | 16r80.
		Fb := Fb | 16r80. 
		(aBoolean and: [v ~= 0]) ifTrue: [ 
			MP := (PC := (PC-2) char) + 1.
			time := time + 5. ] ].
	
	Ff := (Ff & (16rFF bitInvert)) | (v & F53 bitInvert ).
	((((v bitXor: b) bitXor: A) & FH) ~= 0) ifTrue: [ v := v - 1 ].
	Ff := Ff | (v << 4 & 26r20 ) | (v & 8).
]

{ #category : #instructions }
Z80 >> cpl [

	Ff := (Ff & F53 bitInvert) | ((A := A bitXor: 16rFF) & F53).
	Fb := Fb | 16r80 bitInvert.
	Fa := (Fa & FH bitInvert) | (Fr bitInvert & FH). "set H, N"
]

{ #category : #instructions }
Z80 >> daa [

	| h d |

	h := (((Fr bitXor: Fa) bitXor: Fb) bitXor: (Fb >> 8)) & FH.
	d := 0.
	((A | (Ff & 16r100)) > 16r99) ifTrue: [ d := 16r160 ].
	(((A & 16rF) | h) > 9) ifTrue: [ d := d + 6 ].
	
	Fa := A | 16r100. "parity"
	((Fb & 16r200) = 0) 
		ifTrue: [ A := A + (Fb := d) ]
		ifFalse: [ A := A - d. Fb := d bitInvert ].
	Ff := (Fr := (A := A & 16rFF)) | (d & 16r100).
	
]

{ #category : #'accessing registers' }
Z80 >> de [
	^ D << 8 | E
]

{ #category : #'accessing registers' }
Z80 >> de: v [

	E := v&16rFF.
	D := v >>> 8.
	
]

{ #category : #instructions }
Z80 >> dec: v [

	| temp |
	temp := v.
	Ff := Ff & 16r100 | (Fr := temp := (Fa:=v)+(Fb:=-1) & 16rFF).
	^ temp.
]

{ #category : #instructions }
Z80 >> doHalt [

	| n |
	halted := true.
	n := (time_limit - time + 3) >> 2.
	(n > 0) ifTrue: [ 
		n := env halt: n ir: (IR | R & 16r7F).
		R := R + n.
		time := time + 4 * n. ].
]

{ #category : #'accessing registers' }
Z80 >> ei [

	^ IFF&1 ~= 0
]

{ #category : #'accessing registers' }
Z80 >> ei: v [

	IFF := (v>0) ifTrue: [ 3 ] ifFalse: [ 0 ].
]

{ #category : #'accessing registers' }
Z80 >> env: aZ80Environemnt [

	env := aZ80Environemnt.
]

{ #category : #accessing }
Z80 >> ex_af [

	| tmp |
		
	tmp := A_. A_ := A. A := tmp.
	tmp := Ff_. Ff_ := Ff. Ff := tmp.
	tmp := Fr_. Fr_ := Fr. Fr := tmp.
	tmp := Fa_. Fa_ := Fa. Fa := tmp.
	tmp := Fb_. Fb_ := Fb. Fb := tmp.

]

{ #category : #execution }
Z80 >> execute [

	| stepIndex |
	
	stepIndex := 1.
	calledOpcodes := Set new.

	halted ifTrue: [ 
		self doHalt.
		^ self ].
	
	[ 
		self step.
		
		stepIndex := stepIndex + 1.
		
	time_limit - time > 0 ] whileTrue. 
]

{ #category : #execution }
Z80 >> executeWithComparison [

	| stepIndex lines |	
	
	calledOpcodes := Set new.

	halted ifTrue: [ 
		self doHalt.
		^ self ].

	lines := '/home/krivanek/shared/out.txt' asFileReference readStream contents lines allButFirst: 2.
	stepIndex := 1.
	
	[ 
		"((env mem: 23730) = 22527) ifTrue: [ self halt ]."
	"	stepIndex = (648699 - 1) ifTrue: [ self halt. ]."
		stepIndex = (22-1) ifTrue: [ self halt. ].
 ""		self stepWithComparison: (STON fromString: (lines at: stepIndex)).
		stepIndex := stepIndex + 1.
	time_limit - time > 0.
	
	stepIndex ~= 10000 ] whileTrue. 
]

{ #category : #accessing }
Z80 >> exx [

	| tmp |
		
	tmp := B_. B_ := B. B := tmp.
	tmp := C_. C_ := C. C := tmp.
	tmp := D_. D_ := D. D := tmp.
	tmp := E_. E_ := E. E := tmp.
	tmp := HL_. HL_ := HL. HL := tmp.

]

{ #category : #'accessing registers' }
Z80 >> f [
	^ self flags
]

{ #category : #'accessing registers' }
Z80 >> f: v [

	self flags: v
]

{ #category : #instructions }
Z80 >> f_szh0n0p: r [

	"SZ5H3PNC
	xxx0xP0"
	
	Ff :=(Ff & 16rFF bitInvert) | (Fr := r).
	Fa := r | 16r100.
	Fb := 0.
]

{ #category : #'accessing structure variables' }
Z80 >> flags [

	| f a b r ra u |

	f := Ff. a := Fa. b := Fb. r := Fr.
	f := f&(FS|F53) | ((f>>>8)&FC). "S.5.3..C"
	u := b >> 8.
	r=0 ifTrue: [ f := f | FZ ]. ".Z......"
	ra := r bitXor: a.
	f := f | (u & FN).		"......N."
	f := f | (((ra bitXor: b) bitXor: u) & FH).	"...H...."
	((a & 16rFF bitInvert) = 0) 
		ifTrue: [ 
			a := ra & (b bitXor: r).		".....V.."
			b := 5. ]
		ifFalse: [ 
			a := 16r9669*FP.
			b := (r bitXor: (r >>> 4)) & 16rF ].	".....P.."
	^ f | ((a >>> b) & FP)
]

{ #category : #'accessing structure variables' }
Z80 >> flags: f [

	| tempF |
	Fr := f bitInvert & FZ.
	tempF := f | (f << 8).
	Ff := tempF.
	Fa := 16rFF & (Fb := tempF & 16r80 bitInvert | ((tempF&FP)<<5))
]

{ #category : #instructions }
Z80 >> getd: xy [

	| d | 
	d := env mem: PC.
	PC := (PC+1) char.
	time := time + 8.
	^ MP := (xy + (d byte)) char.
]

{ #category : #execution }
Z80 >> group_cb: arg [

	| v c o | 
	c := env m1: PC ir: (IR | (R & 16r7F)).
	R := R + 1.
	PC := (PC + 1) char.
	time := time + 4.
	o := (c >>> 3) & 7.
	
	calledOpcodes add: c.
	
	(c & 16rC7) caseOf: { 
		[ 16r00 ] -> [ B := self shifter: o to: B ].
		[ 16r01 ] -> [ C := self shifter: o to: C ].
		[ 16r02 ] -> [ D := self shifter: o to: D ].
		[ 16r03 ] -> [ E := self shifter: o to: E ].
		[ 16r04 ] -> [ HL := HL & 16rFF | ((self shifter: o to: (HL >>> 8)) << 8) ].
		[ 16r05 ] -> [ HL := HL & 16rFF00 | (self shifter: o to: (HL & 16rFF)) ].
		[ 16r06 ] -> [
			v := self shifter: o to: (env mem: HL). 
			time := time + 4.
			env mem: HL value: v.
			time := time + 3. ].
		[ 16r07 ] -> [ A := self shifter: o to: A ].
		[ 16r40 ] -> [ self bit: o to: B ].
		[ 16r41 ] -> [ self bit: o to: C ].
		[ 16r42 ] -> [ self bit: o to: D ].
		[ 16r43 ] -> [ self bit: o to: E ].
		[ 16r44 ] -> [ self bit: o to: (HL >>> 8) ].
		[ 16r45 ] -> [ self bit: o to: (HL & 16rFF) ].
		[ 16r46 ] -> [ 
			self bit: o to: (env mem: HL).
			Ff := (Ff & F53 bitInvert) | ((MP >>> 8) & F53).
			time := time + 4. ].
		[ 16r47 ] -> [ self bit: o to: A ].
		[ 16r80 ] -> [ B := B & (1 << o) bitInvert ].
		[ 16r81 ] -> [ C := C & (1 << o) bitInvert ].
		[ 16r82 ] -> [ D := D & (1 << o) bitInvert ].
		[ 16r83 ] -> [ E := E & (1 << o) bitInvert ].
		[ 16r84 ] -> [ HL := HL & (16r100 << o) bitInvert ].
		[ 16r85 ] -> [ HL := HL & (1 << o) bitInvert ].
		[ 16r86 ] -> [ 
			v := (env mem: HL) & (1 << o) bitInvert.
			time := time + 4.
			env mem: HL value: v.
			time := time + 3. ].
		[ 16r87 ] -> [ A := A & (1 << o) bitInvert ].
		[ 16rC0 ] -> [ B := B | (1 << o) ].
		[ 16rC1 ] -> [ C := C | (1 << o) ].
		[ 16rC2 ] -> [ D := D | (1 << o) ].
		[ 16rC3 ] -> [ E := E | (1 << o) ].
		[ 16rC4 ] -> [ HL := HL | (16r100 << o) ].
		[ 16rC5 ] -> [ HL := HL | (1 << o) ].
		[ 16rC6 ] -> [ 
			v := (env mem: HL) | (1 << o).
			time := time + 4.
			env mem: HL value: v.
			time := time + 3. ].
		[ 16rC7 ] -> [ A := A | (1 << o) ].
	} otherwise: [  ] 
	
]

{ #category : #execution }
Z80 >> group_ed: opcode [

	| c v |
	c := env m1: PC ir: (IR | (R & 16r7F)).
	R := R + 1.
	PC := (PC + 1) char.
	time := time + 4.
	
	c caseOf: { 
		[ 16r47 ] -> [ self i: A. time := time+1 ].
		[ 16r4F ] -> [ self r: A. time := time+1 ].
		[ 16r57 ] -> [ self ld_a_ir: (IR >>> 8) ].
		[ 16r57 ] -> [ self ld_a_ir: (self r) ].
		[ 16r67 ] -> [ self rrd ].
		[ 16r6F ] -> [ self rld ].
		[ 16r40 ] -> [ self f_szh0n0p: (B := env in: (B << 8 | C)). time := time + 4 ].
		[ 16r48 ] -> [ self f_szh0n0p: (C := env in: (B << 8 | C)). time := time + 4 ].
		[ 16r50 ] -> [ self f_szh0n0p: (D := env in: (B << 8 | C)). time := time + 4 ].
		[ 16r58 ] -> [ self f_szh0n0p: (E := env in: (B << 8 | C)). time := time + 4 ].
		[ 16r60 ] -> [ 
			self f_szh0n0p: (v := env in: (B << 8 | C)). 
			HL := (HL & 16rFF) | (v << 8).
			time := time + 4 ].
		[ 16r68 ] -> [ 
			self f_szh0n0p: (v := env in: (B << 8 | C)). 
			HL := (HL & 16rFF00) | v.
			time := time + 4 ].
		[ 16r70 ] -> [ self f_szh0n0p: (env in: (B << 8 | C)). time := time + 4 ].
		[ 16r78 ] -> [ 
			MP := (v := B << 8 | C)+1.
			self f_szh0n0p: (A := env in: v). 
			time := time + 4 ].
		[ 16r41 ] -> [ env out: (B << 8 | C) value: B. time := time + 4 ].
		[ 16r49 ] -> [ env out: (B << 8 | C) value: C. time := time + 4 ].
		[ 16r51 ] -> [ env out: (B << 8 | C) value: D. time := time + 4 ].
		[ 16r59 ] -> [ env out: (B << 8 | E) value: D. time := time + 4 ].
		[ 16r61 ] -> [ env out: (B << 8 | E) value: (HL >>> 8). time := time + 4 ].
		[ 16r69 ] -> [ env out: (B << 8 | E) value: (HL & 16rFF). time := time + 4 ].
		[ 16r71 ] -> [ env out: (B << 8 | E) value: 0. time := time + 4 ].
		[ 16r79 ] -> [ 
			MP := (v := B << 8 | C)+1.
			env out: v value: A.
			time := time + 4 ].
		[ 16r42 ] -> [ self sbc_hl: (B << 8 | C).].
		[ 16r4A ] -> [ self adc_hl: (B << 8 | C).].
		[ 16r43 ] -> [ 
			MP := (v := self imm16) + 1.
			env mem16: v value: (B << 8 | C).
			time := time + 6].
		[ 16r4B ] -> [ 
			MP := (v := self imm16) + 1.
			v := env mem16: v.
			B := v >>> 8.
			C := v & 16rFF.
			time := time + 6].
		[ 16r52 ] -> [ self sbc_hl: (D << 8 | E).].
		[ 16r5A ] -> [ self adc_hl: (D << 8 | E).].
		[ 16r53 ] -> [ 
			MP := (v := self imm16) + 1.
			env mem16: v value: (D << 8 | E).
			time := time + 6].
		[ 16r5B ] -> [ 
			MP := (v := self imm16) + 1.
			v := env mem16: v.
			D := v >>> 8.
			E := v & 16rFF.
			time := time + 6].
		[ 16r62 ] -> [ self sbc_hl: HL.].
		[ 16r6A ] -> [ self adc_hl: HL.].
		[ 16r63 ] -> [ 
			MP := (v := self imm16) + 1.
			env mem16: v value: HL.
			time := time + 6].
		[ 16r6B ] -> [ 
			MP := (v := self imm16) + 1.
			HL := env mem16: v.
			time := time + 6].
		[ 16r72 ] -> [ self sbc_hl: SP.].
		[ 16r7A ] -> [ self adc_hl: SP.].
		[ 16r73 ] -> [ 
			MP := (v := self imm16) + 1.
			env mem16: v value: SP.
			time := time + 6].
		[ 16r7B ] -> [ 
			MP := (v := self imm16) + 1.
			SP := env mem16: v.
			time := time + 6].
	} otherwise: [  ].
		
	(#(16r44 16r4C 16r54 16r5C 16r64 16r6C 16r74 16r7C) includes: c)   
		ifTrue: [ v:= A. A := 0. self sub: v. ]. 
	(#(16r45 16r4D 16r55 16r5D 16r65 16r6D 16r75 16r7D) includes: c)   
		ifTrue: [ IFF := IFF >> 1. MP := PC := self pop. ]. 		
	(#(16r46 16r4E 16r56 16r5E 16r66 16r6E 16r76 16r7E) includes: c)   
		ifTrue: [ IM := (c >> 3) & 3. ]. 		

	c caseOf: { 
		[ 16rA0 ] -> [ self ldir: 1 if: false ].
		[ 16rA8 ] -> [ self ldir: -1 if: false ].
		[ 16rB0 ] -> [ self ldir: 1 if: true ].
		[ 16rB8 ] -> [ self ldir: -1 if: true ].
		[ 16rA1 ] -> [ self cpir: 1 if: false ].
		[ 16rA9 ] -> [ self cpir: -1 if: false ].
		[ 16rB1 ] -> [ self cpir: 1 if: true ].
		[ 16rB9 ] -> [ self cpir: -1 if: true ].
	} otherwise: [  ].
	
	(#(16rA2 16rA3 16rAA 16rAB 16rB2 16rB3 16rBA 16rBB) includes: c)   
		ifTrue: [ self inir_otir: c ]. 		

]

{ #category : #execution }
Z80 >> group_xy: c0 [

	[
		| xy c |
		xy := (c0 = 16rD0) ifTrue: [ IX ] ifFalse: [ IY ].
		c := env m1: PC ir: (IR | (IR | R & 16r7F)). 
		R := R+1.
		PC := (PC+1) char.
		time := time + 4.
		xy := self opcodesXY01: c xy: xy.
		xy := self opcodesXY02: c xy: xy.
		xy := self opcodesXY03: c xy: xy.
		xy := self opcodesXY04: c xy: xy.
		xy := self opcodesXY05: c xy: xy.
		xy := self opcodesXY06: c xy: xy.
		(c0 = 16rDD) ifTrue: [ IX := xy ] ifFalse: [ IY := xy ].
		^ self.
	] repeat.
]

{ #category : #execution }
Z80 >> group_xy_cb: xy [

	| pc a c v o | 

	pc := PC.
	a := MP := (xy + (env mem: pc) byte) char.
	time := time + 3.
	c := env mem: (pc+1) char.
	PC := (pc+2) char.
	time := time + 5.
	v := env mem: a.
	time := time + 4.
	o := (c >>> 3) & 7.
	
	(c & 16rC0) caseOf: { 
		[ 16r00 ] -> [ self shifter: o to: v ].
		[ 16r40 ] -> [ self bit: o to: v. Ff := (Ff & F53 bitInvert) | ((a >>8) & F53)  ].
		[ 16r80 ] -> [ v := v & (1 << o) bitInvert  ].
		[ 16rC0 ] -> [ v := v | (1 << o)].
	} otherwise: [  ].
	
	env mem: a value: v.
	time := time + 3.

	(c & 16r07) caseOf: { 
		[ 0 ] -> [ B := v ].
		[ 1 ] -> [ C := v ].
		[ 2 ] -> [ D := v ].
		[ 3 ] -> [ E := v ].
		[ 4 ] -> [ HL := (HL & 16r00FF) | (v<<8) ].
		[ 5 ] -> [ HL := (HL & 16rFF00) | v ].
		[ 7 ] -> [ A := v ].
	} otherwise: [ ].

	^ xy
	
]

{ #category : #'accessing registers' }
Z80 >> hl [

	^ HL
]

{ #category : #'accessing registers' }
Z80 >> hl: v [

	HL := v
]

{ #category : #'accessing registers' }
Z80 >> i [

	^ IR >>> 8
]

{ #category : #'accessing registers' }
Z80 >> i: v [

	IR := (IR & 16rFF) | (v<<8)
]

{ #category : #'accessing registers' }
Z80 >> iff [

	^ IFF
]

{ #category : #'accessing registers' }
Z80 >> iff: v [

	IFF := v
]

{ #category : #'accessing registers' }
Z80 >> im [

	| v |
	
	v := IM.
	^ (v = 0) ifTrue: [ v ] ifFalse: [ v - 1 ].
	
]

{ #category : #'accessing registers' }
Z80 >> im: v [

	IM := v+1 & 3
]

{ #category : #instructions }
Z80 >> imm16 [

	| v |
	
	v := env mem16: PC.
	PC := (PC+2) char.
	time := time + 6.
	^ v
]

{ #category : #instructions }
Z80 >> imm8 [

	| v |
	
	v := env mem: PC.
	PC := (PC+1) char.
	time := time + 3.
	^ v
]

{ #category : #instructions }
Z80 >> inc: v [

	| temp |
	temp := v.
	Ff := Ff & 16r100 | (Fr := temp := (Fa := temp)+(Fb:=1) & 16rFF).
	^ temp.
]

{ #category : #instructions }
Z80 >> inir_otir: op [

	"op: 101rd01o"
	
	| bc hl d v x |
	
	hl := (HL + (d := (((op & 8) = 0) ifTrue: [1] ifFalse: [-1])) ) char.
	bc :=  (B << 8) | C.
	time := time + 1.
	((op & 1) = 0) 
		ifTrue: [ 
			v := env in: bc.
			time := time + 4.
			MP := bc + d.
			bc := (bc - 256) char.
			env mem: HL value: v.
			time := time + 3.
			d := d + bc ]
		ifFalse: [ 
			v := env mem: HL.
			time := time + 3.
			bc := (bc - 256) char.
			MP := bc + d.
			env out: bc value: v.
			time := time + 4.
			d := hl ].
		
		d := (d & 16rFF) + v.
		HL := hl.
		B := (bc := bc >> 8).
		((op > 16rB0) and: [ bc > 0 ]) ifTrue: [ 
			time := time + 5.
			PC := (PC - 2) char ].
		x := (d & 7) bitXor: bc.
		Ff := bc | (d := d & 16r0100).
		Fa := (Fr := bc) bitXor: 16r80.
		x := 16r4B3480 >> (((x bitXor: x) >>> 4) & 15).
		Fb := ((x bitXor: bc) & 16r80) | (d >>> 4) | ((v & 16r80) << 2).
	
]

{ #category : #'as yet unclassified' }
Z80 >> interrupt: bus [

	((IFF & 1) = 0) ifTrue: [ ^ false ].
	
	IFF := 0.
	halted := false.
	time := time + 6.
	self push: PC. 
	IM caseOf: { 
		[ 0 ] -> [ ((bus | 16r38) = 16rFF) ifTrue: [ PC := bus - 199 ] ].
		[ 1 ] -> [ ((bus | 16r38) = 16rFF) ifTrue: [ PC := bus - 199 ] ].
		[ 2 ] -> [ PC := 16r38 ].
		[ 3 ] -> [ 
			PC := env mem16: ((IR & 16rFF00) | bus) ].
			time := time + 6.
	} otherwise: [  ].
	MP := PC.
	^ true
]

{ #category : #'accessing registers' }
Z80 >> ix [

	^ IX
]

{ #category : #'accessing registers' }
Z80 >> ix: v [

	IX := v
]

{ #category : #'accessing registers' }
Z80 >> iy [

	^ IY
]

{ #category : #'accessing registers' }
Z80 >> iy: v [

	IY := v
]

{ #category : #instructions }
Z80 >> jp: aBoolean [

	| a | 
	
	a := MP := self imm16.
	aBoolean ifTrue: [ PC := a ].
]

{ #category : #instructions }
Z80 >> jr [

	| pc d | 
	
	pc := PC.
	d := (env mem: pc) byte.
	time := time + 8.
	MP := PC := (pc + d + 1) char
]

{ #category : #instructions }
Z80 >> ld_a_ir: v [ 

	Ff := (Ff & 16rFF bitInvert) | (A := v).
	Fr := (v = 0) ifTrue: [ 0 ] ifFalse: [ 1 ].
	Fa := Fb := (IFF << 6) & 16r80.
	time := time + 1.
]

{ #category : #instructions }
Z80 >> ldir: i if: aBoolean [

	| a v |
	v := env mem: (a := HL).
	HL := (a+i) char.
	time := time + 3.
	env mem: (a := self de) value: v.
	self de: (a+i) char.
	time := time + 5.
	
	(Fr ~= 0) ifTrue: [ Fr := 1 ] "keep Z".
	v := v + A.
	Ff := (Ff & F53 bitInvert) | (v & F3) | ( v << 4 & F5).
	
	self bc: (a := (self bc - 1) char).
	v := 0.
	(a ~= 0) ifTrue: [ 
		aBoolean ifTrue: [ 
			time := time + 5.
			MP := (PC := (PC-2) char) + 1 ].
		v := 16r80. ].
	Fa := Fb := v.
]

{ #category : #'as yet unclassified' }
Z80 >> nmi [

	IFF := IFF & 2.
	halted := false.
	self push: PC.
	time := time + 4.
	PC := 16r66
]

{ #category : #execution }
Z80 >> opcodes01: c [
	
	| v |
	
	c caseOf: { 
		[ 16r08 ] -> [ self ex_af ].
		[ 16r10 ] -> [ | d | 
			time := time + 1. 
			v := PC. 
			d := (env mem: v) byte. 
			v := v + 1.
			time := time + 3.
			((B := (B - 1) & 16rFF ) ~= 0) ifTrue: [
				time := time + 5. MP := (v := v + d)  ].
			PC := v char.
			 ].	
		[ 16r18 ] -> [ 
			MP := PC := ( PC + 1 + (env mem: PC) byte ) char.
			time := time + 8. ].
		[ 16r09 ] -> [ HL := self add16: HL with: (B << 8 | C) ].
		[ 16r19 ] -> [  HL := self add16: HL with: (D << 8 | E) ].
		[ 16r29 ] -> [ HL := self add16: HL with: HL ].
		[ 16r39 ] -> [ HL := self add16: HL with: SP ].
		[ 16r01 ] -> [ 
			v := self imm16.
			B := v >>> 8.
			C := v & 16rFF. ].
		[ 16r11 ] -> [ 
			v := self imm16.
			D := v >>> 8.
			E := v & 16rFF ].
		[ 16r21 ] -> [ 	HL := self imm16. ].
		[ 16r23 ] -> [ 	HL := (HL+1) char. time := time + 2. ].
		[ 16r2B ] -> [ 	HL := (HL-1) char. time := time + 2. ].
		[ 16r31 ] -> [ 	SP := self imm16 ].
		[ 16r33 ] -> [ 	SP := (SP+1) char. time := time + 2. ].
		[ 16r3B ] -> [ 	SP := (SP-1) char. time := time + 2. ].
		[ 16r03 ] -> [ 
			C := C+1.
			C = 265 ifTrue: [ B := (B+1) & 16rFF. C := 0].
			time := time + 2.].
		[ 16r13 ] -> [ 
			E := E+1.
			E = 265 ifTrue: [ D := (D+1) & 16rFF. E := 0].
			time := time + 2.].
		[ 16r0B ] -> [ 
			C := C - 1.
			C < 0 ifTrue: [B := (B-1) & (C := 16rFF). 
			time := time + 2]].
		[ 16r1B ] -> [ 
			E := E - 1.
			E < 0 ifTrue: [D := (D-1) & (E := 16rFF). 
			time := time + 2]].
		[ 16r02 ] -> [ 
			MP := (v := (B << 8) | C) + 1 & 16rFF | (A<<8).
			env  mem: v value: A.
			time := time + 3.].
		[ 16r0A ] -> [ 
			MP := (v := (B << 8) | C) + 1.
			A := env mem: v.
			time := time + 3.].
		[ 16r12 ] -> [ 
			MP := (v := (D << 8) | E) + 1 & 16rFF | (A<<8).
			env  mem: v value: A.
			time := time + 3.].
		[ 16r1A ] -> [ 
			MP := (v := (D << 8) | E) + 1.
			A := env mem: v.
			time := time + 3.].
		[ 16r22 ] -> [ 
			MP := (v := self imm16)+1.
			env mem16: v value: HL.
			time := time + 6 ].
		[ 16r2A ] -> [ 
			MP := (v := self imm16)+1.
			HL := env mem16: v.
			time := time + 6 ].
		[ 16r32 ] -> [ 
			MP := (v := self imm16)+1 & 16rFF | (A << 8).
			env mem: v value: A.
			time := time + 3 ].
		[ 16r3A ] -> [ 
			MP := (v := self imm16)+1.
			A := env mem: v.
			time := time + 3 ].
		[ 16r04 ] -> [ B := self inc: B. ].
		[ 16r05 ] -> [ B := self dec: B. ].
		[ 16r06 ] -> [ B := self imm8. ].
		[ 16r0C ] -> [ C := self inc: C. ].
		[ 16r0D ] -> [ C := self dec: C. ].
		[ 16r0E ] -> [ C := self imm8 ].
		[ 16r14 ] -> [ D := self inc: D. ].
		[ 16r15 ] -> [ D := self dec: D. ].
		[ 16r16 ] -> [ D := self imm8 ].
		[ 16r1C ] -> [ E := self inc: E. ].
		[ 16r1D ] -> [ E := self dec: E. ].
		[ 16r1E ] -> [ E := self imm8 ].
 } otherwise: [  ].
]

{ #category : #execution }
Z80 >> opcodes02: c [
	
	| v |
	
	c caseOf: { 
		[ 16r24 ] -> [ 
			HL := HL & 16rFF | ((self inc: (HL >>> 8)) << 8) ].
		[ 16r25 ] -> [ 
			HL := HL & 16rFF | ((self dec: (HL >>> 8)) << 8) ].
		[ 16r26 ] -> [ 
			HL := HL & 16rFF | (self imm8 << 8) ].
		[ 16r2C ] -> [ 
			HL := HL & 16rFF00 | (self inc: (HL & 16rFF)) ].
		[ 16r2D ] -> [ 
			HL := HL & 16rFF00 | (self dec: (HL & 16rFF)) ].
		[ 16r2E ] -> [ 
			HL := HL & 16rFF00 | self imm8 ].
		[ 16r34 ] -> [ 
			v := self inc: (env mem: HL).
			time := time + 4.
			env mem: HL value: v.
			time := time + 3].
		[ 16r35 ] -> [ 
			v := self dec: (env mem: HL).
			time := time + 4.
			env mem: HL value: v.
			time := time + 3].
		[ 16r36 ] -> [
			env mem: HL value: self imm8.
			time := time + 3].
		[ 16r3C ] -> [ A := self inc: A. ].
		[ 16r3D ] -> [ A := self dec: A. ].
		[ 16r3E ] -> [ A := self imm8 ].
		[ 16r20 ] -> [ 
			(Fr ~= 0) ifTrue: [ self jr ] ifFalse: [ self imm8 ]].
		[ 16r28 ] -> [ 
			(Fr = 0) ifTrue: [ self jr ] ifFalse: [ self imm8 ]].
		[ 16r30 ] -> [ 
			((Ff & 16r100) = 0) ifTrue: [ self jr ] ifFalse: [ self imm8 ]].
		[ 16r38 ] -> [ 
			((Ff & 16r100) ~= 0) ifTrue: [ self jr ] ifFalse: [ self imm8 ]].
		[ 16r07 ] -> [ 
			self rot: ((A * 16r101) asJavaSignedInteger >>> 7)].
		[ 16r0F ] -> [
			self rot: ((A * 16r80800000) asJavaSignedInteger >> 24)].
		[ 16r17 ] -> [ 
			self rot: ((A << 1) | ((Ff >>> 8) & 1))].
		[ 16r1F ] -> [ 
			self rot: ((A * 16r201) | ((Ff & 16r100) >>> 1))].
		
 } otherwise: [  ].
]

{ #category : #execution }
Z80 >> opcodes03: c [
	
	c caseOf: { 
		[ 16r27 ] -> [ self daa ].
		[ 16r2F ] -> [ self cpl ].
		[ 16r37 ] -> [ self scf_ccf: 0 ].
		[ 16r3F ] -> [ self scf_ccf: (Ff & 16r100) ].
		[ 16r41 ] -> [ B := C ].
		[ 16r42 ] -> [ B := D ].
		[ 16r43 ] -> [ B := E ].
		[ 16r44 ] -> [ B := HL >>> 8 ].
		[ 16r45 ] -> [ B := HL & 16rFF ].
		[ 16r46 ] -> [ B := env mem: HL. time := time + 3 ].
		[ 16r47 ] -> [ B := A ].
		[ 16r48 ] -> [ C := B ].
		[ 16r4A ] -> [ C := D ].
		[ 16r4B ] -> [ C := E ].
		[ 16r4C ] -> [ C := HL >>> 8 ].
		[ 16r4D ] -> [ C := HL & 16rFF ].
		[ 16r4E ] -> [ C := env mem: HL. time := time + 3 ].
		[ 16r4F ] -> [ C := A ].
		[ 16r50 ] -> [ D := B ].
		[ 16r51 ] -> [ D := C ].
		[ 16r53 ] -> [ D := E ].
		[ 16r54 ] -> [ D := HL >>> 8 ].
		[ 16r55 ] -> [ D := HL & 16rFF ].
		[ 16r56 ] -> [ D := env mem: HL. time := time + 3 ].
		[ 16r57 ] -> [ D := A ].
		[ 16r58 ] -> [ E := B ].
		[ 16r59 ] -> [ E := C ].
		[ 16r5A ] -> [ E := D ].
		[ 16r5C ] -> [ E := HL >>> 8 ].
		[ 16r5D ] -> [ E := HL & 16rFF ].
		[ 16r5E ] -> [ E := env mem: HL. time := time + 3 ].
		[ 16r5F ] -> [ E := A ].
		[ 16r60 ] -> [ HL := (HL & 16rFF) | (B << 8) ].
		[ 16r61 ] -> [ HL := (HL & 16rFF) | (C << 8) ].
		[ 16r62 ] -> [ HL := (HL & 16rFF) | (D << 8) ].
		[ 16r63 ] -> [ HL := (HL & 16rFF) | (E << 8) ].
		[ 16r65 ] -> [ HL := (HL & 16rFF) | (((HL & 16rFF) << 8)) ].
		[ 16r66 ] -> [ HL := (HL & 16rFF) | (((env mem: HL) << 8)). time := time + 3. ].
		[ 16r67 ] -> [ HL := (HL & 16rFF) | (A << 8) ].
		[ 16r68 ] -> [ HL := (HL & 16rFF00) | B ].
		[ 16r69 ] -> [ HL := (HL & 16rFF00) | C ].
		[ 16r6A ] -> [ HL := (HL & 16rFF00) | D ].
		[ 16r6B ] -> [ HL := (HL & 16rFF00) | E ].
		[ 16r6C ] -> [ HL := (HL & 16rFF00) | (HL >>> 8) ].		
 		[ 16r6E ] -> [ HL := (HL & 16rFF00) | (env mem: HL). time := time + 3. ].
 		[ 16r6F ] -> [ HL := (HL & 16rFF00) | A. time := time + 3. ].
 		[ 16r70 ] -> [ env mem: HL value: B. time := time + 3. ].
 		[ 16r71 ] -> [ env mem: HL value: C. time := time + 3. ].
 		[ 16r72 ] -> [ env mem: HL value: D. time := time + 3. ].
 		[ 16r73 ] -> [ env mem: HL value: E. time := time + 3. ].
 		[ 16r74 ] -> [ env mem: HL value: (HL >>> 8). time := time + 3. ].
 		[ 16r74 ] -> [ env mem: HL value: (HL & 16rFF). time := time + 3. ].
 		[ 16r76 ] -> [ self doHalt ].
 		[ 16r77 ] -> [ env mem: HL value: A. time := time + 3. ].
		[ 16r78 ] -> [ A := B ].
		[ 16r79 ] -> [ A := C ].
		[ 16r7A ] -> [ A := D ].
		[ 16r7B ] -> [ A := E ].
		[ 16r7B ] -> [ A := E ].
		[ 16r7C ] -> [ A := HL >>> 8 ].
		[ 16r7D ] -> [ A := HL & 16rFF ].
		[ 16r7E ] -> [ A := env mem: HL. time := time + 3].

} otherwise: [  ].
]

{ #category : #execution }
Z80 >> opcodes04: c [
		
	c caseOf: { 
		[ 16rA7 ] -> [ Fa := (Ff := Fr := A) bitInvert. Fb := 0. ].
		[ 16rAF ] -> [ A := Ff := Fr := Fb := 0. Fa := 16r100. ].
		[ 16r80 ] -> [ self add: B ].
		[ 16r81 ] -> [ self add: C ].
		[ 16r82 ] -> [ self add: D ].
		[ 16r83 ] -> [ self add: E ].
		[ 16r84 ] -> [ self add: (HL >>> 8) ].
		[ 16r85 ] -> [ self add: (HL & 16rFF) ].
		[ 16r86 ] -> [ self add: (env mem: HL). time := time + 3 ].
		[ 16r87 ] -> [ self add: A ].
		[ 16r88 ] -> [ self adc: B ].
		[ 16r89 ] -> [ self adc: C ].
		[ 16r8A ] -> [ self adc: D ].
		[ 16r8B ] -> [ self adc: E ].
		[ 16r8C ] -> [ self adc: (HL >>> 8) ].
		[ 16r8D ] -> [ self adc: (HL & 16rFF) ].
		[ 16r8E ] -> [ self adc: (env mem: HL). time := time + 3 ].
		[ 16r8F ] -> [ self adc: A ].
		[ 16r90 ] -> [ self sub: B ].
		[ 16r91 ] -> [ self sub: C ].
		[ 16r92 ] -> [ self sub: D ].
		[ 16r93 ] -> [ self sub: E ].
		[ 16r94 ] -> [ self sub: (HL >>> 8) ].
		[ 16r95 ] -> [ self sub: (HL & 16rFF) ].
		[ 16r96 ] -> [ self sub: (env mem: HL). time := time + 3 ].
		[ 16r97 ] -> [ self sub: A ].
		[ 16r98 ] -> [ self sbc: B ].
		[ 16r99 ] -> [ self sbc: C ].
		[ 16r9A ] -> [ self sbc: D ].
		[ 16r9B ] -> [ self sbc: E ].
		[ 16r9C ] -> [ self sbc: (HL >>> 8) ].
		[ 16r9D ] -> [ self sbc: (HL & 16rFF) ].
		[ 16r9E ] -> [ self sbc: (env mem: HL). time := time + 3 ].
		[ 16r9F ] -> [ self sbc: A ].
		[ 16rA0 ] -> [ self and: B ].
		[ 16rA1 ] -> [ self and: C ].
		[ 16rA2 ] -> [ self and: D ].
		[ 16rA3 ] -> [ self and: E ].
		[ 16rA4 ] -> [ self and: (HL >>> 8) ].
		[ 16rA5 ] -> [ self and: (HL & 16rFF) ].
		[ 16rA6 ] -> [ self and: (env mem: HL). time := time + 3 ].
		[ 16rA8 ] -> [ self xor: B ].
		[ 16rA9 ] -> [ self xor: C ].
		[ 16rAA ] -> [ self xor: D ].
		[ 16rAB ] -> [ self xor: E ].
		[ 16rAC ] -> [ self xor: (HL >>> 8) ].
		[ 16rAD ] -> [ self xor: (HL & 16rFF) ].
		[ 16rAE ] -> [ self xor: (env mem: HL). time := time + 3 ].
		[ 16rB0 ] -> [ self or: B ].
		[ 16rB1 ] -> [ self or: C ].
		[ 16rB2 ] -> [ self or: D ].
		[ 16rB3 ] -> [ self or: E ].
		[ 16rB4 ] -> [ self or: (HL >>> 8) ].
		[ 16rB5 ] -> [ self or: (HL & 16rFF) ].
		[ 16rB6 ] -> [ self or: (env mem: HL). time := time + 3 ].
		[ 16rB7 ] -> [ self or: A ].
		[ 16rB8 ] -> [ self cp: B ].
		[ 16rB9 ] -> [ self cp: C ].
		[ 16rBA ] -> [ self cp: D ].
		[ 16rBB ] -> [ self cp: E ].
		[ 16rBC ] -> [ self cp: (HL >>> 8) ].
		[ 16rBD ] -> [ self cp: (HL & 16rFF) ].
		[ 16rBE ] -> [ self cp: (env mem: HL). time := time + 3 ].
		[ 16rBF ] -> [ self cp: A ].
		[ 16rDD ] -> [ self group_xy: c ].
		[ 16rFD ] -> [ self group_xy: c ].
		[ 16rCB ] -> [ self group_cb: c ].
		[ 16rED ] -> [ self group_ed: c ].
} otherwise: [  ].
]

{ #category : #execution }
Z80 >> opcodes05: c [
		
	| v | 
	
	c caseOf: { 
		[ 16rC0 ] -> [ 
			time := time + 1.
			(Fr ~= 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rC2 ] -> [ self jp: (Fr ~= 0 ) ].
		[ 16rC4 ] -> [ self call: (Fr ~= 0 ) ].
		[ 16rC8 ] -> [ 
			time := time + 1.
			(Fr = 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rCA ] -> [ self jp: (Fr = 0 ) ].
		[ 16rCC ] -> [ self call: (Fr = 0 ) ].
		[ 16rD0 ] -> [ 
			time := time + 1.
			((Ff & 16r100) = 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rD2 ] -> [ self jp: ((Ff & 16r100) = 0) ].
		[ 16rD4 ] -> [ self call: ((Ff & 16r100) = 0) ].
		[ 16rD8 ] -> [ 
			time := time + 1.
			((Ff & 16r100) ~= 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rDA ] -> [ self jp: ((Ff & 16r100) ~= 0) ].
		[ 16rDC ] -> [ self call: ((Ff & 16r100) ~= 0) ].
		[ 16rE0 ] -> [ 
			time := time + 1.
			((self flags & FP) = 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rE2 ] -> [ self jp: ((self flags & FP) = 0) ].
		[ 16rE4 ] -> [ self call: ((self flags & FP) = 0) ].
		[ 16rE8 ] -> [ 
			time := time + 1.
			((self flags & FP) ~= 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rEA ] -> [ self jp: ((self flags & FP) ~= 0) ].
		[ 16rEC ] -> [ self call: ((self flags & FP) ~= 0) ].

		[ 16rF0 ] -> [ 
			time := time + 1.
			((Ff & FS) = 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rF2 ] -> [ self jp: ((Ff & FS) = 0) ].
		[ 16rF4 ] -> [ self call: ((Ff & FS) = 0) ].
		[ 16rF8 ] -> [ 
			time := time + 1.
			((Ff & FS) ~= 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rFA ] -> [ self jp: ((Ff & FS) ~= 0) ].
		[ 16rFC ] -> [ self call: ((Ff & FS) ~= 0) ].
		[ 16rC1 ] -> [ 
			v := self pop.
			B := v >>> 8.
			C := v & 16rFF ].
		[ 16rC5 ] -> [ self push: ((B << 8) | C) ].
		[ 16rD1 ] -> [ 
			v := self pop.
			D := v >>> 8.
			E := v & 16rFF ].
		[ 16rD5 ] -> [ self push: ((D << 8) | E) ].
		[ 16rE1 ] -> [ HL := self pop. ].
		[ 16rE5 ] -> [ self push: HL ].
		[ 16rF1 ] -> [ self af: (self pop) ].
		[ 16rF5 ] -> [ self push: ((A << 8) | self flags) ].
		[ 16rC3 ] -> [ MP := PC := self imm16 ].
		[ 16rC6 ] -> [ self add: self imm8 ].
		[ 16rCE ] -> [ self adc: self imm8 ].
		[ 16rD6 ] -> [ self sub: self imm8 ].
		[ 16rDE ] -> [ self sbc: self imm8 ].
		[ 16rE6 ] -> [ self and: self imm8 ].
		[ 16rEE ] -> [ self xor: self imm8 ].
		[ 16rF6 ] -> [ self or: self imm8 ].
		[ 16rFE ] -> [ self cp: self imm8 ].
		[ 16rC9 ] -> [ MP := PC := self pop ].
		[ 16rCD ] -> [ v := self imm16. self push: PC. MP := PC := v ].
		[ 16rD3 ] -> [ 
			env out: (v := (self imm8 | (A<<8))) value: A.
			MP := ((v+1) & 16rFF) | (v&16rFF00). 
			time := time + 4. ].
		[ 16rDB ] -> [ 
			MP := (v := (self imm8 | (A<<8)))+1.
			A := env in: v.
			time := time + 4. ].
		[ 16rD9 ] -> [ self exx ].
		[ 16rE3 ] -> [
			v := self pop. 
			self push: HL.
			MP := HL := v.
			time := time + 2.].
		[ 16rE9 ] -> [ PC := HL ].
		[ 16rEB ] -> [ 
			v := HL.
			HL := (D << 8) | E.
			D := v >>> 8.
			E := v & 16rFF ].		
		[ 16rF3 ] -> [ IFF := 0 ].
		[ 16rFB ] -> [ IFF := 3 ].
		[ 16rF9 ] -> [ SP := HL. time := time + 2. ].
	

} otherwise: [  ].
]

{ #category : #execution }
Z80 >> opcodes06: c [
	
	c caseOf: { 
		[ 16rC7 ] -> [ self push: PC. PC := c-199 ].
		[ 16rCF ] -> [ self push: PC. PC := c-199 ].
		[ 16rD7 ] -> [ self push: PC. PC := c-199 ].
		[ 16rDF ] -> [ self push: PC. PC := c-199 ].
		[ 16rE7 ] -> [ self push: PC. PC := c-199 ].
		[ 16rEF ] -> [ self push: PC. PC := c-199 ].
		[ 16rF7 ] -> [ self push: PC. PC := c-199 ].
		[ 16rFF ] -> [ self push: PC. PC := c-199 ].
	} otherwise: [  ].
]

{ #category : #execution }
Z80 >> opcodesXY01: c xy: aXY [
	
	| v xy |

	xy := aXY.
	
	c caseOf: { 
		[ 16r08 ] -> [ self ex_af ].
		[ 16r10 ] -> [ 
			time := time + 1.
			((B := B - 1 & 16rFF) ~= 0) ifTrue: [ self jr ] ifFalse: [ self imm8 ]].
		[ 16r18 ] -> [ self jr ].
		[ 16r09 ] -> [ xy := self add16: xy with: B<<8 | C ].
		[ 16r19 ] -> [ xy := self add16: xy with: D<<8 | E ].
		[ 16r29 ] -> [ xy := self add16: xy with: xy ].
		[ 16r39 ] -> [ xy := self add16: xy with: SP ].
		[ 16r01 ] -> [ self bc: self imm16 ].
		[ 16r03 ] -> [ self bc: (self bc + 1) char. time := time + 2].
		[ 16r0B ] -> [ self bc: (self bc - 1) char. time := time + 2].
		[ 16r11 ] -> [ self de: self imm16 ].
		[ 16r13 ] -> [ self de: (self de + 1) char. time := time + 2].
		[ 16r1B ] -> [ self de: (self de - 1) char. time := time + 2].
		[ 16r21 ] -> [ xy := self imm16 ].
		[ 16r23 ] -> [ xy := (xy + 1) char. time := time + 2].
		[ 16r2B ] -> [ xy := (xy - 1) char. time := time + 2].
		[ 16r31 ] -> [ SP := self imm16 ].
		[ 16r33 ] -> [ SP := (SP + 1) char. time := time + 2].
		[ 16r3B ] -> [ SP := (SP - 1) char. time := time + 2].
		[ 16r38 ] -> [ SP := (SP - 1) char. time := time + 2].
		[ 16r02 ] -> [ 
			MP := (v := self bc) + 1 & 16rFF | (A << 8).
			env mem: v value: A. 
			time := time + 3].
		[ 16r0A ] -> [ 
			MP := (v := self bc) + 1.
			A := env mem: v. 
			time := time + 3].
		[ 16r12 ] -> [ 
			MP := (v := self de) + 1 & 16rFF | (A << 8).
			env mem: v value: A. 
			time := time + 3].
		[ 16r1A ] -> [ 
			MP := (v := self de) + 1.
			A := env mem: v. 
			time := time + 3].
		[ 16r22 ] -> [ 
			MP := (v := self imm16) + 1.
			env mem16: v value: xy.
			time := time + 6].
		[ 16r2A ] -> [ 
			MP := (v := self imm16) + 1.
			xy := env mem16: v.
			time := time + 6].
		[ 16r32 ] -> [ 
			MP := (v := self imm16) + 1 & 16rFF | (A << 8).
			xy := env mem16: v value: A.
			time := time + 3].
		[ 16r3A ] -> [ 
			MP := (v := self imm16) + 1.
			A := env mem16: v.
			time := time + 3].
		[ 16r04 ] -> [ B := self inc: B ].
		[ 16r05 ] -> [ B := self dec: B ].
		[ 16r06 ] -> [ B := self imm8 ].
		[ 16r0C ] -> [ C := self inc: C ].
		[ 16r0D ] -> [ C := self dec: C ].
		[ 16r0E ] -> [ C := self imm8 ].
		[ 16r14 ] -> [ D := self inc: D ].
		[ 16r15 ] -> [ D := self dec: D ].
		[ 16r16 ] -> [ D := self imm8 ].
		[ 16r1C ] -> [ E := self inc: E ].
		[ 16r1D ] -> [ E := self dec: E ].
		[ 16r1E ] -> [ E := self imm8 ].
		[ 16r24 ] -> [ xy := xy & 16rFF | ((self inc: (xy >>> 8)) << 8) ].
		[ 16r25 ] -> [ xy := xy & 16rFF | ((self dec: (xy >>> 8)) << 8) ].
		[ 16r26 ] -> [ xy := xy & 16rFF | ((self imm8) << 8) ].
		[ 16r2C ] -> [ xy := xy & 16rFF00 | (self inc: (xy & 16rFF)) ].
		[ 16r2D ] -> [ xy := xy & 16rFF00 | (self dec: (xy & 16rFF)) ].
		[ 16r2E ] -> [ xy := xy & 16rFF00 | (self imm8) ].

 } otherwise: [  ].

	^ xy
]

{ #category : #execution }
Z80 >> opcodesXY02: c xy: aXY [
	
	| v xy |

	xy := aXY.
	
	c caseOf: { 
		[ 16r34 ] -> [ 
			| a | 
			v := self inc: (env mem: (a := self getd: xy)).
			time := time + 4.
			env mem: a value: v.
			time := time + 3. ].
		[ 16r35 ] -> [ 
			| a | 
			v := self dec: (env mem: (a := self getd: xy)).
			time := time + 4.
			env mem: a value: v.
			time := time + 3. ].
		[ 16r36 ] -> [ 
			| a | 
			a := (xy + (env mem: PC) char).
			time := time + 3.
			v := (env mem: (PC + 1)) char.
			env mem: a value: v.
			PC := (PC + 2) char.
			time := time + 3. ].
		[ 16r3C ] -> [ A := self inc: A ].
		[ 16r3D ] -> [ A := self dec: A ].
		[ 16r3E ] -> [ A := self imm8 ].
		[ 16r20 ] -> [ (Fr ~= 0) ifTrue: [ self jr ] ifFalse: [ self imm8 ] ].
		[ 16r28 ] -> [ (Fr = 0) ifTrue: [ self jr ] ifFalse: [ self imm8 ] ].
		[ 16r30 ] -> [ ((Ff & 16r100) = 0) ifTrue: [ self jr ] ifFalse: [ self imm8 ] ].
		[ 16r38 ] -> [ ((Ff & 16r100) ~= 0) ifTrue: [ self jr ] ifFalse: [ self imm8 ] ].
		[ 16r07 ] -> [ self rot: ((A * 16r101) >>> 8) ].
		[ 16r0F ] -> [ self rot: ((A * 16r80800000) >> 28) ].
		[ 16r1F ] -> [ self rot: ((A * 16r201 | (Ff & 16r100)) >>> 1) ].
		[ 16r27 ] -> [ self daa ].
		[ 16r2F ] -> [ self cpl ].
		[ 16r37 ] -> [ self scf_ccf: 0 ].
		[ 16r3F ] -> [ self scf_ccf: (Ff & 16r100) ].
		[ 16r41 ] -> [ B := C ].
		[ 16r42 ] -> [ B := D ].
		[ 16r43 ] -> [ B := E ].
		[ 16r44 ] -> [ B := xy >>> 8 ].
		[ 16r45 ] -> [ B := xy & 16rFF ].
		[ 16r46 ] -> [ B := env mem: (self getd: xy). time := time + 3 ].
		[ 16r47 ] -> [ B := A ].
		[ 16r48 ] -> [ C := B ].
		[ 16r4A ] -> [ C := D ].
		[ 16r4B ] -> [ C := E ].
		[ 16r4C ] -> [ C := xy >>> 8 ].
		[ 16r4D ] -> [ C := xy & 16rFF ].
		[ 16r4E ] -> [ C := env mem: (self getd: xy). time := time + 3 ].
		[ 16r4F ] -> [ C := A ].
		[ 16r50 ] -> [ D := B ].
		[ 16r51 ] -> [ D := C ].
		[ 16r53 ] -> [ D := E ].
		[ 16r54 ] -> [ D := xy >>> 8 ].
		[ 16r55 ] -> [ D := xy & 16rFF ].
		[ 16r56 ] -> [ D := env mem: (self getd: xy). time := time + 3 ].
		[ 16r57 ] -> [ D := A ].
		[ 16r58 ] -> [ E := B ].
		[ 16r59 ] -> [ E := C ].
		[ 16r5A ] -> [ E := D ].
		[ 16r5C ] -> [ E := xy >>> 8 ].
		[ 16r5D ] -> [ E := xy & 16rFF ].
		[ 16r5E ] -> [ E := env mem: (self getd: xy). time := time + 3 ].
		[ 16r5F ] -> [ E := A ].

 } otherwise: [  ].

	^ xy
]

{ #category : #execution }
Z80 >> opcodesXY03: c xy: aXY [
	
	| v xy |

	xy := aXY.
	
	c caseOf: { 
		[ 16r60 ] -> [ xy := (xy & 16rFF) | (B << 8) ].
		[ 16r61 ] -> [ xy := (xy & 16rFF) | (C << 8) ].
		[ 16r62 ] -> [ xy := (xy & 16rFF) | (D << 8) ].
		[ 16r63 ] -> [ xy := (xy & 16rFF) | (E << 8) ].
		[ 16r65 ] -> [ xy := (xy & 16rFF) | ((xy&16rFF) << 8) ].
		[ 16r66 ] -> [ 
			HL := (HL & 16rFF) | ((env mem: (self getd: xy)) << 8).
			time := time + 3. ].
		[ 16r67 ] -> [ xy := (xy & 16rFF) | (A << 8) ].
		[ 16r68 ] -> [ xy := (xy & 16rFF00) | B ].
		[ 16r69 ] -> [ xy := (xy & 16rFF00) | C ].
		[ 16r6A ] -> [ xy := (xy & 16rFF00) | D ].
		[ 16r6B ] -> [ xy := (xy & 16rFF00) | E ].
		[ 16r6C ] -> [ xy := (xy & 16rFF00) | (xy >>> 8) ].
		[ 16r6E ] -> [ 
			HL := (HL & 16rFF00) | ((env mem: (self getd: xy))).
			time := time + 3. ].
		[ 16r6F ] -> [ xy := (xy & 16rFF00) | A ].
		[ 16r70 ] -> [ env mem: (self getd: xy) value: B. time := time + 3 ].
		[ 16r71 ] -> [ env mem: (self getd: xy) value: C. time := time + 3 ].
		[ 16r72 ] -> [ env mem: (self getd: xy) value: D. time := time + 3 ].
		[ 16r73 ] -> [ env mem: (self getd: xy) value: E. time := time + 3 ].
		[ 16r74 ] -> [ env mem: (self getd: xy) value: (HL >>> 8). time := time + 3 ].
		[ 16r75 ] -> [ env mem: (self getd: xy) value: (HL & 16rFF). time := time + 3 ].
		[ 16r76 ] -> [ self doHalt ].
		[ 16r77 ] -> [ env mem: (self getd: xy) value: A. time := time + 3 ].
		[ 16r78 ] -> [ A := B ].
		[ 16r79 ] -> [ A := C ].
		[ 16r7A ] -> [ A := D ].
		[ 16r7B ] -> [ A := E ].
		[ 16r7C ] -> [ A := xy >>> 8 ].
		[ 16r7D ] -> [ A := xy & 16rFF ].
		[ 16r7E ] -> [ env mem: (self getd: xy). time := time + 3 ].
		[ 16r80 ] -> [ self add: B ].
		[ 16r81 ] -> [ self add: C ].
		[ 16r82 ] -> [ self add: D ].
		[ 16r83 ] -> [ self add: E ].
		[ 16r84 ] -> [ self add: (xy >>> 8) ].
		[ 16r85 ] -> [ self add: (xy & 16rFF) ].
		[ 16r86 ] -> [ self add: (env mem: (self getd: xy)). time := time + 3 ].
		[ 16r87 ] -> [ self add: A ].
		[ 16r88 ] -> [ self adc: B ].
		[ 16r89 ] -> [ self adc: C ].
		[ 16r8A ] -> [ self adc: D ].
		[ 16r8B ] -> [ self adc: E ].
		[ 16r8C ] -> [ self adc: (xy >>> 8) ].
		[ 16r8D ] -> [ self adc: (xy & 16rFF) ].
		[ 16r8E ] -> [ self adc: (env mem: (self getd: xy)). time := time + 3 ].
		[ 16r8F ] -> [ self adc: A ].
		[ 16r90 ] -> [ self sub: B ].
		[ 16r91 ] -> [ self sub: C ].
		[ 16r92 ] -> [ self sub: D ].
		[ 16r93 ] -> [ self sub: E ].
		[ 16r94 ] -> [ self sub: (xy >>> 8) ].
		[ 16r95 ] -> [ self sub: (xy & 16rFF) ].
		[ 16r96 ] -> [ self sub: (env mem: (self getd: xy)). time := time + 3 ].
		[ 16r97 ] -> [ self sub: A ].
		[ 16r98 ] -> [ self sbc: B ].
		[ 16r99 ] -> [ self sbc: C ].
		[ 16r9A ] -> [ self sbc: D ].
		[ 16r9B ] -> [ self sbc: E ].
		[ 16r9C ] -> [ self sbc: (xy >>> 8) ].
		[ 16r9D ] -> [ self sbc: (xy & 16rFF) ].
		[ 16r9E ] -> [ self sbc: (env mem: (self getd: xy)). time := time + 3 ].
		[ 16r9F ] -> [ self sbc: A ].
	
 } otherwise: [  ].

	^ xy
]

{ #category : #execution }
Z80 >> opcodesXY04: c xy: aXY [
	
	| v xy |

	xy := aXY.
	
	c caseOf: { 
		[ 16rA0 ] -> [ self and: B ].
		[ 16rA1 ] -> [ self and: C ].
		[ 16rA2 ] -> [ self and: D ].
		[ 16rA3 ] -> [ self and: E ].
		[ 16rA4 ] -> [ self and: (xy >>> 8) ].
		[ 16rA5 ] -> [ self and: (xy & 16rFF) ].
		[ 16rA6 ] -> [ self and: (env mem: (self getd: xy)). time := time + 3 ].
		[ 16rA7 ] -> [ self and: A ].
		[ 16rA8 ] -> [ self xor: B ].
		[ 16rA9 ] -> [ self xor: C ].
		[ 16rAA ] -> [ self xor: D ].
		[ 16rAB ] -> [ self xor: E ].
		[ 16rAC ] -> [ self xor: (xy >>> 8) ].
		[ 16rAD ] -> [ self xor: (xy & 16rFF) ].
		[ 16rAE ] -> [ self xor: (env mem: (self getd: xy)). time := time + 3 ].
		[ 16rAF ] -> [ self xor: A ].
		[ 16rB0 ] -> [ self or: B ].
		[ 16rB1 ] -> [ self or: C ].
		[ 16rB2 ] -> [ self or: D ].
		[ 16rB3 ] -> [ self or: E ].
		[ 16rB4 ] -> [ self or: (xy >>> 8) ].
		[ 16rB5 ] -> [ self or: (xy & 16rFF) ].
		[ 16rB6 ] -> [ self or: (env mem: (self getd: xy)). time := time + 3 ].
		[ 16rB7 ] -> [ self or: A ].
		[ 16rB8 ] -> [ self cp: B ].
		[ 16rB9 ] -> [ self cp: C ].
		[ 16rBA ] -> [ self cp: D ].
		[ 16rBB ] -> [ self cp: E ].
		[ 16rBC ] -> [ self cp: (xy >>> 8) ].
		[ 16rBD ] -> [ self cp: (xy & 16rFF) ].
		[ 16rBE ] -> [ self cp: (env mem: (self getd: xy)). time := time + 3 ].
		[ 16rBF ] -> [ self cp: A ].
 } otherwise: [  ].

	^ xy
]

{ #category : #execution }
Z80 >> opcodesXY05: c xy: aXY [
	
	|  xy c0 |

	xy := aXY.
	
	c caseOf: { 
		[ 16rDD ] -> [ c0 := c ].
		[ 16rFD ] -> [ c0 := c ].
		[ 16rCB ] -> [ xy := self group_xy_cb: xy ].
		[ 16rED ] -> [ xy := self group_ed: xy ].
		[ 16rC0 ] -> [ time := time + 1. (Fr ~= 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rC2 ] -> [ self jp: (Fr ~= 0)].
		[ 16rC4 ] -> [ self call: (Fr ~= 0)].
		[ 16rC8 ] -> [ time := time + 1. (Fr == 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rCA ] -> [ self jp: (Fr == 0)].
		[ 16rCC ] -> [ self call: (Fr == 0)].
		[ 16rD0 ] -> [ time := time + 1. ((Ff & 16r100) = 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rD2 ] -> [ self jp: ((Ff & 16r100) = 0)].
		[ 16rD4 ] -> [ self call: ((Ff & 16r100) = 0)].
		[ 16rD8 ] -> [ time := time + 1. ((Ff & 16r100) ~= 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rDA ] -> [ self jp: ((Ff & 16r100) ~= 0)].
		[ 16rDC ] -> [ self call: ((Ff & 16r100) ~= 0)].
		[ 16rE0 ] -> [ time := time + 1. ((self flags & FP) = 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rE2 ] -> [ self jp: ((self flags & FP) = 0)].
		[ 16rE4 ] -> [ self call: ((self flags & FP) = 0)].
		[ 16rE8 ] -> [ time := time + 1. ((self flags & FP) ~= 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rEA ] -> [ self jp: ((self flags & FP) ~= 0)].
		[ 16rEC ] -> [ self call: ((self flags & FP) ~= 0)].
		[ 16rF0 ] -> [ time := time + 1. ((Ff & FS) = 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rF2 ] -> [ self jp: ((Ff & FS) = 0)].
		[ 16rF4 ] -> [ self call: ((Ff & FS) = 0)].
		[ 16rF8 ] -> [ time := time + 1. ((Ff & FS) ~= 0) ifTrue: [ MP := PC := self pop ] ].
		[ 16rFA ] -> [ self jp: ((Ff & FS) ~= 0)].
		[ 16rFC ] -> [ self call: ((Ff & FS) ~= 0)].
		[ 16rC1 ] -> [ self bc: self pop ].
		[ 16rC5 ] -> [ self push: self bc ].
		[ 16rD1 ] -> [ self de: self pop ].
		[ 16rD5 ] -> [ self push: self de ].
		[ 16rE1 ] -> [ xy := self pop ].
		[ 16rE5 ] -> [ self push: xy ].
		[ 16rF1 ] -> [ self af: self pop ].
		[ 16rF5 ] -> [ self push: ((A << 8) | self flags) ].
		[ 16rC3 ] -> [ MP := PC := self imm16 ].
		[ 16rC6 ] -> [ self add: self imm8 ].
		[ 16rCE ] -> [ self adc: self imm8 ].
		[ 16rD6 ] -> [ self sub: self imm8 ].
		[ 16rDE ] -> [ self sbc: self imm8 ].
		[ 16rE6 ] -> [ self and: self imm8 ].
		[ 16rEE ] -> [ self xor: self imm8 ].
		[ 16rF6 ] -> [ self or: self imm8 ].
		[ 16rFE ] -> [ self cp: self imm8 ].

	
 } otherwise: [  ].

	^ xy
]

{ #category : #execution }
Z80 >> opcodesXY06: c xy: aXY [
	
	| v xy |

	xy := aXY.
	
	c caseOf: { 
		[ 16rC9 ] -> [ MP := PC := self pop ].
		[ 16rCD ] -> [ self call: true ].
		[ 16rD3 ] -> [ 
			env out: (v := self imm8) | (A<<8) value: A.
			MP := ((v+1) & 16rFF) | (v&16rFF00). 
			time := time + 4. ].
		[ 16rD8 ] -> [ 
			MP := (v := (self imm8 | (A<<8)))+1.
			A := env in: v.
			time := time + 4. ].
		[ 16rD9 ] -> [ self exx ].
		[ 16rE3 ] -> [
			v := self pop. 
			self push: xy.
			MP := xy := v.
			time := time + 2.].
		[ 16rE9 ] -> [ PC := xy ].
		[ 16rEB ] -> [ 
			v := HL.
			HL := (D << 8) | E.
			D := v >>> 8.
			E := v & 16rFF ].		
		[ 16rF3 ] -> [ IFF := 0 ].
		[ 16rFB ] -> [ IFF := 3 ].
		[ 16rF9 ] -> [ SP := xy. time := time + 2. ].

		[ 16rC7 ] -> [ self push: PC. PC := c-199 ].
		[ 16rCF ] -> [ self push: PC. PC := c-199 ].
		[ 16rD7 ] -> [ self push: PC. PC := c-199 ].
		[ 16rDF ] -> [ self push: PC. PC := c-199 ].
		[ 16rE7 ] -> [ self push: PC. PC := c-199 ].
		[ 16rEF ] -> [ self push: PC. PC := c-199 ].
		[ 16rF7 ] -> [ self push: PC. PC := c-199 ].
		[ 16rFF ] -> [ self push: PC. PC := c-199 ].

	
 } otherwise: [  ].

	^ xy
]

{ #category : #instructions }
Z80 >> or: b [

	Fa := (A := Ff := Fr := A | b) | 16r100.
	Fb := 0
]

{ #category : #'accessing registers' }
Z80 >> pc [

	^ PC
]

{ #category : #'accessing registers' }
Z80 >> pc: v [

	PC := v
]

{ #category : #removing }
Z80 >> pop [

	| sp v |

	sp := SP.
	v := env mem16: (sp).
	SP := (sp + 2) char.
	time := time + 6.
	^ v
]

{ #category : #adding }
Z80 >> push: v [

	| sp |
	
	time := time + 1.
	sp := SP.
	env mem: (sp-1) char value: (v >>> 8). 
	time := time + 3.
	SP := (sp-2) char.
	env mem: SP value: (v & 16rFF). 
	time := time + 3.
]

{ #category : #'accessing structure variables' }
Z80 >> r [

	^ R & 16r7F | (IR & 16r80)
]

{ #category : #'accessing registers' }
Z80 >> r: v [

	R := v.
	IR := IR & 16rFF00 | (v&16r80)
]

{ #category : #execution }
Z80 >> reset [

	halted := false.
	PC := SP := A := B := C := D := E := HL := A_ := B_ := C_ := D_
		:= E_ := HL_ := IX := IY := IR := R := MP := Ff := Fr := Fa 
		:= Fb := Ff_ := Fr_ := Fa_ := Fb_ := IFF 
		:= 0. 
"	PC := IFF := IM := 0."
	self af: (SP := 16rFFFF).
	
	time := 0.
	time_limit := 100.
]

{ #category : #instructions }
Z80 >> rld [ 

	| v | 
	
	v := ((env mem: HL) << 4) | (A & 16r0F).
	time := time + 7.
	self f_szh0n0p: (A := A & 16rF0 | (v >>> 8)).
	env mem: HL value: (v & 16rFF).
	MP := HL + 1.
	time := time + 3. 
]

{ #category : #instructions }
Z80 >> rot: a [

	Ff := Ff & 16rD7 | (a & 16r128).
	Fb := Fb & 16r80.
	Fa := Fa & FH bitInvert | (Fr & FH). "reset H, N"
	A := a & 16rFF.
	
	
]

{ #category : #instructions }
Z80 >> rrd [ 

	| v | 
	
	v := (env mem: HL) | (A << 8).
	time := time + 7.
	self f_szh0n0p: (A := A & 16rF0 | (v & 16r0F)).
	env mem: HL value: ((v >>> 4) & 16rFF).
	MP := HL + 1.
	time := time + 3. 
]

{ #category : #instructions }
Z80 >> sbc: b [

	Fb := b bitInvert.
	A := Fr := (Ff := (Fa := A) - b - ( (Ff >>> 8) & FC )) & 16rFF
]

{ #category : #instructions }
Z80 >> sbc_hl: b [

	| a r |
	
	r := (a := HL) - b - ((Ff >>> 8) & FC).
	Ff := r >>> 8.
	Fa := a >>> 8.
	Fb := (b >>> 8) bitInvert.
	HL := r := r char.
	Fr := (r >>> 8) | (r << 8).
	MP := a + 1.
	time := time + 7.
]

{ #category : #instructions }
Z80 >> scf_ccf: x [

	"may be wrong. see http://scratchpad.wikia.com/wiki/Z80"
	 
	Fa := Fa & FH bitInvert.
	Fb := Fb & 16r80 | (((x >>> 4) bitXor: Fr) & FH).
	Ff := (16r100 bitXor: x) | (Ff & FS) | (A & F53).
]

{ #category : #instructions }
Z80 >> shifter: o to: anInt [

	| v | 
	v := anInt.
	(o & 7) caseOf: { 
		[ 0 ] -> [ v := (v * 16r101) asJavaSignedInteger >>> 7  ].
		[ 1 ] -> [ v := (v * 16r80800000) asJavaSignedInteger >> 24  ].
		[ 2 ] -> [ v := v << 1 | ((Ff >>> 8) & 1) ].
		[ 3 ] -> [ v := (v * 16r201 | (Ff & 16r100)) >>> 1 ].
		[ 4 ] -> [ v := v << 1 ].
		[ 5 ] -> [ v := (v >>> 1) | (v & 16r80) | (v<<8) ].
		[ 6 ] -> [ v := v << 1 | 1 ].
		[ 7 ] -> [ v := (v * 16r201) >>> 1 ].
	}. 
	Fa := 16r100 | (Fr := v := 16rFF & (Ff := v)).
	Fb := 0.
	^ v
]

{ #category : #'accessing registers' }
Z80 >> sp [

	^ SP
]

{ #category : #'accessing registers' }
Z80 >> sp: v [

	SP := v
]

{ #category : #execution }
Z80 >> startupSetup [

	halted := false.
	PC := SP := A := B := C := D := E := HL := A_ := B_ := C_ := D_
		:= E_ := HL_ := IX := IY := IR := R := MP := Ff := Fr := Fa 
		:= Fb := Ff_ := Fr_ := Fa_ := Fb_ := IFF := SP := IM
		:= 0. 
	
	time := 0.
	time_limit := 100.
]

{ #category : #execution }
Z80 >> step [

	| c |
	
	R := R+1.
	c := env m1: PC ir: (IR | (R & 16r7F)).
	PC := (PC+1) char.
	time := time + 4.
		
	self opcodes01: c.
	self opcodes02: c.
	self opcodes03: c.
	self opcodes04: c.
	self opcodes05: c.
	self opcodes06: c.
 
]

{ #category : #execution }
Z80 >> stepWithComparison: aStateDictionary [

	| c |
	
	R := R+1.
	c := env m1: PC ir: (IR | (R & 16r7F)).
	PC := (PC+1) char.
	time := time + 4.
	
	self assert: (self correspondsTo: aStateDictionary opcode: c	) isEmpty.
	
	self opcodes01: c.
	self opcodes02: c.
	self opcodes03: c.
	self opcodes04: c.
	self opcodes05: c.
	self opcodes06: c.
 
]

{ #category : #instructions }
Z80 >> sub: b [

	Fb := b bitInvert.
	A := Fr := (Ff := (Fa := A) - b) & 16rFF
]

{ #category : #accessing }
Z80 >> time [
	^ time
]

{ #category : #accessing }
Z80 >> time: anObject [
	^ time := anObject
]

{ #category : #accessing }
Z80 >> time_limit [
	^ time_limit
]

{ #category : #accessing }
Z80 >> time_limit: anObject [
	time_limit := anObject
]

{ #category : #instructions }
Z80 >> xor: b [

	Fa := (A := Ff := Fr := A bitXor: b) | 16r100.
	Fb := 0
]
