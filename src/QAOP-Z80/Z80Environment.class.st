"
Z80 initializeConstants.
env := Z80Environment new.
env z80 startupSetup.

'spectrum.rom' asFileReference readStream binary contents withIndexDo: [ :byte :index | env mem: index-1 value: byte. ].

env z80 executeWithComparison.

"
Class {
	#name : #Z80Environment,
	#superclass : #Object,
	#instVars : [
		'cpu',
		'memory',
		'keyboard',
		'time',
		'timet',
		'interrupted',
		'ctime'
	],
	#category : #'QAOP-Z80'
}

{ #category : #initialization }
Z80Environment >> FRSTART [

	^ -14335
]

{ #category : #initialization }
Z80Environment >> FRTIME [

	^ 69888
]

{ #category : #evaluating }
Z80Environment >> NOCONT [

	^ 99999
]

{ #category : #evaluating }
Z80Environment >> SCRENDT [

	^ 42910 "191*224+126"
]

{ #category : #evaluating }
Z80Environment >> cont1: aTime [

	| t |
	
	t := aTime + cpu time.
	(t < 0 or: [ t > self SCRENDT ]) ifTrue: [ ^ self ].
	(t bitAnd: 7) >= 6 ifTrue: [ ^ self ].
	((t bitAnd: 224) < 126) ifTrue: [ 
		cpu time: cpu time + (6 - t bitAnd: 7) ].
	
]

{ #category : #evaluating }
Z80Environment >> cont: nArg [

	| n s k t |
	
	n := nArg.
	t := ctime.
	(t + n <= 0) ifTrue: [ ^ self ].
	s := self SCRENDT - t.
	(s < 0) ifTrue: [ ^ self ].
	s := s \\ 224.
	(s > 126) 
		ifTrue: [ 
			n := n - (s - 126).
			n <= 0 ifTrue: [ ^ self ].
			t := 6.
			k := 15 ] 
		ifFalse: [ 
			k := s >>> 3.
			s := s bitAnd: 7.
			s = 7 ifTrue: [ 
				s := s - 1.
				n := n - 1.
				n = 0 ifTrue: [ ^ self ] ].
			t := s ].
		s := (s - 1) >> 1.
		k < n ifTrue: [ n := k ].
		cpu time: (t + (6*n)).
]

{ #category : #evaluating }
Z80Environment >> contPort: port [

	| n |
	n := n := cpu time - ctime.
	n > 0 ifTrue: [ self cont: n ].

]

{ #category : #'as yet unclassified' }
Z80Environment >> cpu [

	^ cpu
]

{ #category : #accessing }
Z80Environment >> form [

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

]

{ #category : #evaluating }
Z80Environment >> frame [
	
		cpu time: self FRSTART.
		cpu time_limit: self FRSTART + self FRTIME.
		
		self updateKeyboard.
		self refreshNew.
		
		cpu interrupt: 16rFF.
		cpu execute.

]

{ #category : #evaluating }
Z80Environment >> frames [
	[
		cpu time: self FRSTART.
		cpu time_limit: self FRSTART + self FRTIME.
		
"		self form display.
"		self updateKeyboard.
		self refreshNew.
		
		cpu interrupt: 16rFF.
		cpu execute.
		self interrupted.
	] whileFalse.
]

{ #category : #'as yet unclassified' }
Z80Environment >> halt: n ir: ir [

	^ n
]

{ #category : #evaluating }
Z80Environment >> in: port [

	| v |
	
	self contPort: port.
	
	((port bitAnd: 16r00E0) = 0)
		ifTrue: [ ^ self kemston ].
	
	v := 16rFF.

	((port bitAnd: 16r0001) = 0) ifTrue: [ 
		| e |
		0 to: 7 do: [ :i |
			((port bitAnd: 16r100) << i) = 0 ifTrue: [ 
				v := v bitAnd: (keyboard at: i+1) ] ].
		e := 0.
		v := v bitAnd: 16rbf ]
		ifFalse: [ 
			cpu time >= 0 ifTrue: [ ] ].
		
	^ v.
]

{ #category : #initialization }
Z80Environment >> initialize [

	super initialize.
	
	memory := ByteArray new: 16rFFFF+1.
	cpu := Z80 forEnvironment: self.
	
	memory at: 1 put: 16r04.
	
	keyboard := #(16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF).
	
	self romFile upToEnd withIndexDo: [ :byte :index | self privMem: index-1 value: byte. ].
	
	6144 to: 6912 do: [:i | memory at: i+1 put: 8r70 ]. "white"
	
	ctime := self NOCONT.
	
	cpu startupSetup.
	

]

{ #category : #accessing }
Z80Environment >> interrupted [ 

	^ interrupted
]

{ #category : #accessing }
Z80Environment >> interrupted: aBoolean [

	interrupted := aBoolean
]

{ #category : #evaluating }
Z80Environment >> kemston [

	^ 0
]

{ #category : #'as yet unclassified' }
Z80Environment >> m1: pc ir: ir [

	^ memory at: pc+1.
]

{ #category : #'as yet unclassified' }
Z80Environment >> mem16: addr [

	^ ((memory at: addr+2) << 8) + (memory at: addr+1).
	
]

{ #category : #'as yet unclassified' }
Z80Environment >> mem16: addr value: v [

	addr < 16r4000 ifTrue: [ ^ self ].

	memory at: addr+1 put: (v & 16rFF).
	memory at: addr+2 put: (v >> 8).

]

{ #category : #'as yet unclassified' }
Z80Environment >> mem: addr [

	^ memory at: addr+1.
]

{ #category : #'as yet unclassified' }
Z80Environment >> mem: addr value: v [

	addr < 16r4000 ifTrue: [ ^ self ].

	^ memory at: addr+1 put: v.
]

{ #category : #accessing }
Z80Environment >> memory [ 

	^ memory
]

{ #category : #'as yet unclassified' }
Z80Environment >> out: port value: v [
]

{ #category : #'as yet unclassified' }
Z80Environment >> privMem: addr value: v [

	^ memory at: addr+1 put: v.
]

{ #category : #evaluating }
Z80Environment >> refreshNew [
]

{ #category : #initialization }
Z80Environment >> romFile [

	^ (File named: '48.rom') readStream
]

{ #category : #initialization }
Z80Environment >> updateKeyboard [

	| m |
	
	keyboard := #(16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF).

	m := { -1. -1. -1. -1. -1 }.
   " // .......xxx row
    // ....xxx... column
    // ...x...... caps shift
    // ..x....... symbol shift
    // .x........ caps shift alone
    // x......... symbol shift alone	"
	
"	self pressed: 2r00001001"
]
