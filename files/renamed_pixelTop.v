 

module pixelTop(
    input logic RESET,
    input logic CLK,
    inout [7:0] DATA_BUS, 
    output [3:0] READ
    );

    logic[7:0] DATA;
    wire CONVERT;
    wire ERASE;
    wire EXPOSE;

    assign RAMP = CONVERT ? CLK : 0;
    assign VBN1 = EXPOSE ? CLK : 0;
    assign DATA_BUS = CONVERT ? DATA : 8'bZ;

    always_ff @(posedge CLK or posedge RESET) begin
      if(RESET) begin
         DATA =0;
      end
      if(CONVERT) begin
         DATA +=  1;
      end
      else begin
         DATA = 0;
      end
   end // always @ (posedge clk or reset)

PIXEL_ARRAY array(VBN1, RAMP, CLK, RESET, ERASE, EXPOSE, CONVERT, READ, DATA_BUS);

PIXEL_STATE state(CLK, RESET, ERASE, EXPOSE, READ[3], READ[2], READ[1], READ[0], CONVERT);

endmodule






