[Documentation](VGA-Controller-using-VHDL.pdf)

A VGA Display Driver implemented on an FPGA board, written in VHDL, compliant to the tight time constraints required by the VGA standard.

Supports multiple views, such as an image loader and viewer, a triangle and a TV screensaver style square bouncer. Yes. It does hit the corner.

Images have to be processed using the Python script provided, to create a file with the image pixel data which can be parsed and loaded into a ROM memory to be run on the board.