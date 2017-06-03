Z80 initializeConstants.
env := Z80Environment new.
env z80 startupSetup.

'spectrum.rom' asFileReference readStream binary contents withIndexDo: [ :byte :index | env mem: index-1 value: byte. ].

env z80 executeWithComparison.
