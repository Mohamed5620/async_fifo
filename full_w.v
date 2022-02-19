`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:23:37 02/17/2022 
// Design Name: 
// Module Name:    full_w 
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
module full_w
#(parameter addr_size=4)
(
input wclk,wrst,winc,
input [addr_size:0] r_sync,
output reg wfull,
output reg [addr_size:0] wptr,
output [addr_size-1:0] waddr
);

reg [addr_size:0] wbin;
wire [addr_size:0] wbnext,wgnext;

assign waddr=wbin[addr_size-1:0];
assign wbnext=wbin+(winc&(~wfull));
assign wgnext=(wbnext>>1)^(wbnext);
assign full_val=(wgnext=={~r_sync[addr_size:addr_size-1],r_sync[addr_size-2:0]});
always @(posedge wclk)
begin
if(!wrst)
begin
wbin<=0;
wptr<=0;
end
else
begin
wbin<=wbnext;
wptr<=wgnext;
end
end

always @(posedge wclk)
begin
if(!wrst)
wfull<=0;
else 
wfull<=full_val;
end

endmodule
