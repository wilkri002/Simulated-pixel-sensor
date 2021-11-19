

module m41 (
  input [7:0] a, 
  input [7:0] b, 
  input [7:0] c, 
  input [7:0] d, 
  input s0, s1, s2, s3,
  output [7:0] out
  ); 

 assign out = s0 ? a : 8'bz;
 assign out = s1 ? b : 8'bz;
 assign out = s2 ? c : 8'bz;
 assign out = s3 ? d : 8'bz;

endmodule




module PIXEL_ARRAY(
  input logic      VBN1,
  input logic      RAMP,
  input logic      CLK,
  input logic      RESET,
  input logic      ERASE,
  input logic      EXPOSE,
  input logic      CONVERT,
  input wire [3:0] READ,
  inout wire [7:0] DATA 
  );

  parameter real    dv_pixel1 = 0.01;  //Set the expected photodiode current (0-1)
  parameter real    dv_pixel2 = 0.5;  //Set the expected photodiode current (0-1)
  parameter real    dv_pixel3 = 0.6;  //Set the expected photodiode current (0-1)
  parameter real    dv_pixel4 = 0.01;  //Set the expected photodiode current (0-1)

  wire [7:0] sensor_wire1;
  wire [7:0] sensor_wire2;
  wire [7:0] sensor_wire3;
  wire [7:0] sensor_wire4;

  m41 mux(sensor_wire1, sensor_wire2, sensor_wire3, sensor_wire4, READ[0], READ[1], READ[2], READ[3], DATA);

  assign sensor_wire1 = CONVERT ? DATA : 8'bz;
  assign sensor_wire2 = CONVERT ? DATA : 8'bz;
  assign sensor_wire3 = CONVERT ? DATA : 8'bz;
  assign sensor_wire4 = CONVERT ? DATA : 8'bz;

  PIXEL_SENSOR #(.dv_pixel(dv_pixel1)) ps1(VBN1, RAMP, RESET, ERASE, EXPOSE, READ[0], sensor_wire1);
  PIXEL_SENSOR #(.dv_pixel(dv_pixel2)) ps2(VBN1, RAMP, RESET, ERASE, EXPOSE, READ[1], sensor_wire2);
  PIXEL_SENSOR #(.dv_pixel(dv_pixel3)) ps3(VBN1, RAMP, RESET, ERASE, EXPOSE, READ[2], sensor_wire3);
  PIXEL_SENSOR #(.dv_pixel(dv_pixel4)) ps4(VBN1, RAMP, RESET, ERASE, EXPOSE, READ[3], sensor_wire4);


endmodule // re_control