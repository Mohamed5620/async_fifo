`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:05:15 02/17/2022 
// Design Name: 
// Module Name:    empty_r 
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
module empty_r
#(parameter addr_size=4)
(
input rclk,rrst,rinc,
input [addr_size:0] w_sync,
output reg rempty,
output reg [addr_size:0] rptr,
output  [addr_size-1:0] raddr
);
reg [addr_size:0] rbin;
wire [addr_size:0] rbnext,rgnext;

assign raddr=rbin[addr_size-1:0];
assign rbnext=rbin+(rinc&(~rempty));
assign rgnext=(rbnext>>1)^(rbnext);
assign empty_val=(rgnext==w_sync);
always @(posedge rclk)
begin
if(!rrst)
begin
rbin<=0;
rptr<=0;
end
else
begin
rbin<=rbnext;
rptr<=rgnext;
end
end
always @(posedge rclk)
begin
if(!rrst)
rempty<=1;
else 
rempty<=empty_val;
end

endmodule
