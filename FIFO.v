`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:14:54 02/13/2022 
// Design Name: 
// Module Name:    FIFO 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module FIFO 
#(parameter data_width =32,parameter addr_width=4)
(input clk,//CLK
input rd_en,//enable for reading
input wr_en,//enable for writing
input [data_width-1:0] data_in, //input data
input reset ,//reset 
output reg [data_width-1:0] data_out ,
output reg empty,
output reg full,
output reg [addr_width-1:0] data_counter//To count how many data slots full in FIFO
);
//memory 
reg [data_width-1:0] memory [2**addr_width-1:0];//array 2_D to implement FIFO memory  
//pointer
reg [addr_width-1:0] rd_counter;
reg [addr_width-1:0] wr_counter;
//if needed or you can increase it or decrease it using + / - 
reg add;//signal to increase counters 
reg sub;//signal to decrease counters

//***********Implementaion here ***********//
initial
begin
data_counter=0;
rd_counter=0;
wr_counter=0;
end
always @(posedge clk)
begin
     if(reset)
	  begin
	       rd_counter=0;
			 wr_counter=0;
			 full=0;
			 empty=1;
	  end
	  else if(rd_en)
	  begin
	       data_out=memory[rd_counter];
			 rd_counter=rd_counter+1;
			 data_counter=data_counter-1;
			 if(data_counter==0)
			 begin
			 empty=1'b1;
	       full=0;
			 end
			 else
			 begin
			 full=1'b0;
			 empty=0;
			 end
		end
	  else if((wr_en)&&(data_counter<(2**addr_width)))
	  begin
	       memory[wr_counter]=data_in;
			 wr_counter=wr_counter+1;
			 data_counter=data_counter+1;
			 if(data_counter==0)
			 begin
	       full=1'b1;
			 empty=0;
			 end
			 else
			 begin
			 full=1'b0;
			 empty=0;
			 end
			 
	  	end
	
end
endmodule 

module testbench;
 reg clk;
 reg [31:0] data_in;
 reg rd_en;
 reg wr_en;
 reg reset;
 wire [31:0] data_out;
 wire empty;
 wire full;
 wire [3:0] data_counter;
 FIFO dut ( .clk(clk),.rd_en(rd_en),.wr_en(wr_en),.data_in(data_in),
 .reset(reset),.data_out(data_out),.empty(empty),.full(full),.data_counter(data_counter)
 );
 


 initial begin
  clk  = 1'b0;

  data_in  = 32'h0;

  rd_en  = 1'b0;

  wr_en  = 1'b0;

  reset  = 1'b1;

  #20;

  reset  = 1'b0;

  wr_en  = 1'b1;

  data_in  = 32'h0;

  #20;

  data_in  = 32'h1;

  #20;

 data_in  = 32'h2;

  #20;

  data_in  = 32'h3;

  #20;

  data_in  = 32'h4;

  #20;
  
  data_in =  32'h5;
  
  #20;
  
  data_in =  32'h6; 
  
  #20;
  
  data_in =  32'h7;  
  
  #20;
  
  wr_en = 1'b0;

  rd_en = 1'b1;  

 end 

   always #10 clk = ~clk;    

endmodule 