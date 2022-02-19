`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:47:56 02/17/2022 
// Design Name: 
// Module Name:    async_fifo 
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
module async_fifo
#(parameter addr_size=4, data_size=8)
(
input wclk,winc,wrst,
input rclk,rinc,rrst,
input [data_size-1:0] w_data,
output rempty,wfull,
output reg[data_size-1:0] r_data
);
// declare wires and connections

wire [addr_size-1:0] waddr,raddr;
wire [addr_size:0] wptr,rptr;
reg [addr_size:0] w_sync,r_sync;
reg [data_size-1:0]mem [2**addr_size-1:0];
reg [addr_size:0] r_sync_temp;
reg [addr_size:0] w_sync_temp;

// dual port memory

always @(posedge rclk)
begin
if(rinc&(~rempty))
r_data<=mem[raddr];
end

always @(posedge wclk)
begin
if(winc&(~wfull))
mem[waddr]<=w_data;
end

// create synchronizers

always @ (posedge wclk)
begin
if(!wrst)
begin
r_sync_temp<=0;
r_sync<=0;
end
else
begin
r_sync_temp<=rptr;
r_sync<=r_sync_temp;
end
end

always @(posedge rclk)
begin
if(!rrst)
begin
w_sync_temp<=0;
w_sync<=0;
end
else
begin
w_sync_temp<=wptr;
w_sync<=w_sync_temp;
end
end
// check full and empty logic

empty_r emp(.rclk(rclk),.rrst(rrst),.rinc(rinc),.w_sync(w_sync),.rempty(rempty),
.rptr(rptr),.raddr(raddr));
full_w ful(.wclk(wclk),.wrst(wrst),.winc(winc),.r_sync(r_sync),.wfull(wfull),
.wptr(wptr),.waddr(waddr));
endmodule

