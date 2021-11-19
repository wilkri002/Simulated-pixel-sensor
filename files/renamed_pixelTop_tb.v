//====================================================================
//        Copyright (c) 2021 Carsten Wulff Software, Norway
// ===================================================================
// Created       : wulff at 2021-7-21
// ===================================================================
//  The MIT License (MIT)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//====================================================================


`timescale 1 ns / 1 ps

//====================================================================
// Testbench for pixelSensor
// - clock
// - instanciate pixel
// - State Machine for controlling pixel sensor
// - Model the ADC and ADC
// - Readout of the databus
// - Stuff neded for testbench. Store the output file etc.
//====================================================================
module MUX_4_TO_1(
                  inout[7:0] a,
                  inout[7:0] b,
                  inout[7:0] c,
                  inout[7:0] d,
                  input[3:0] sel,
                  inout[7:0] out);

   assign out = sel[0] ? a : (sel[1] ? b : (sel[3] ? c: d));

endmodule



module test_shit_tb;

   //------------------------------------------------------------
   // Testbench clock
   //------------------------------------------------------------
   logic CLK = 0;
   logic RESET = 0;
   parameter integer clk_period = 500;
   parameter integer sim_end = clk_period*2400;
   always #clk_period CLK=~CLK;

   //------------------------------------------------------------
   // Pixel
   //------------------------------------------------------------
   
   /*logic [7:0] READ_DATA1; //date to read out from 1
   logic [7:0] READ_DATA2; //date to read out from 2
   logic [7:0] READ_DATA3; //date to read out from 3
   logic [7:0] READ_DATA4; //date to read out from 4*/


   //Analog signals
 

   //Digital
   wire [3:0] READ; //enable signal for read of each pixel
   tri[7:0] pixData; //  We need this to be a wire, because we're tristating it

   //Instanciate the pixel
   pixelTop entire_sensor(RESET, CLK, pixData, READ);

   //------------------------------------------------------------
   // DAC and ADC model
   //------------------------------------------------------------
   

   //------------------------------------------------------------
   // Readout from databus
   //------------------------------------------------------------
   logic [7:0] pixelDataOut1;
   logic [7:0] pixelDataOut2;
   logic [7:0] pixelDataOut3;
   logic [7:0] pixelDataOut4;

   always_ff @(posedge CLK or posedge RESET) begin
      if(RESET) begin
         pixelDataOut1 = 0;
         pixelDataOut2 = 0;
         pixelDataOut3 = 0;
         pixelDataOut4 = 0;
      end
      else begin
         if(READ[0])
           pixelDataOut1 <= pixData;
         if(READ[1])
           pixelDataOut2 <= pixData;
         if(READ[2])
           pixelDataOut3 <= pixData;
         if(READ[3])
           pixelDataOut4 <= pixData;
      end
   end

   //------------------------------------------------------------
   // Testbench stuff
   //------------------------------------------------------------
   initial
     begin
        RESET = 1;

        #clk_period  RESET=0;

        $dumpfile("test_shit_tb.vcd");
        $dumpvars(0,test_shit_tb);

        #sim_end
          $stop;

     end

endmodule // test
