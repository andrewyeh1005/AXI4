# AXI4
Feel free to edit or make any changes.

## Description

This is a simple demo of AXI4.
![plot](https://github.com/andrewyeh1005/AXI4/tree/main/assets/blockdiagram.png)

More information can be found at:
* [AXI SPEC](http://www.gstitt.ece.ufl.edu/courses/fall15/eel4720_5721/labs/refs/AXI4_specification.pdf)

## Support
* AXI channel signals
  * AxADDR
  * AxLEN
  * AxSIZE
  * AxBURST (only INCR mode)
  * AxVALID
  * AxREADY
  * xDATA
  * xSTRB
  * xLAST
  * xVALID
  * xREADY
  * xRESP   (only response OKAY)

* AXI auto generator
  * Generate specified master/slave port 

* Master/slave wrapper connect to AXI

## Quick Start
### AXI example
* [simple AXI](https://github.com/andrewyeh1005/AXI4/tree/main/src)

**Note: Make sure to install python 3.x version in your environment
### Make your own AXI
If no arugment is specified, it will generate AXI with one slave ports and one master ports.
```text
cd script
python axi_generator.py --master 3 --slave 2 
```
