`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.09.2025 19:51:56
// Design Name: 
// Module Name: STMS_1_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module STMS_1_tb();
    reg clk, rst, alert1, alert2, emrg;
    reg sensor_north, sensor_east, sensor_south, sensor_west;
    wire[2:0] NS,NW,EW,EN,SN,SE,WE,WS;
    wire ambulance,police;
    wire[4:0] count;
    
    STMS_1 DUT (.clk(clk), .rst(rst), .alert1(alert1), .alert2(alert2), .emrg(emrg),
                        .sensor_north(sensor_north), .sensor_east(sensor_east), .sensor_south(sensor_south), .sensor_west(sensor_west),
                        .NS(NS), .NW(NW), .EW(EW), .EN(EN), .SN(SN), .SE(SE), .WE(WE), .WS(WS),
                        .ambulance(ambulance), .police(police), .count(count)
                        );
           
   always #5 clk=~clk;
   initial begin
        clk=0; rst=0; alert1=0; alert2=0; emrg=0;
        sensor_north=1; sensor_east=1; sensor_south=1; sensor_west=1;
        
        #2000; emrg=1;
        #30; emrg=0;
        #50; rst=1;
        #10; rst=0;
        #1000; sensor_north=0; sensor_east=0;
        #1000; sensor_north=1; sensor_east=1; sensor_south=0;
        #1000; sensor_south=0;
        #50; alert1=1;
        #50; alert1=0;
   end

endmodule
