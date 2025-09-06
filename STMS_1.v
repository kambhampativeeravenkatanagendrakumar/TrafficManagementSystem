`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.09.2025 19:41:52
// Design Name: 
// Module Name: STMS_1
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


module STMS_1(
input clk,rst,alert1,alert2,emrg,
       input sensor_north,sensor_east,sensor_south,sensor_west, //sensors for vehicle detection
       output reg[2:0] NS,NW,EW,EN,SN,SE,WE,WS, //directions
       output reg ambulance,police, // alerts if in case anything happens
       output reg[4:0] count //counter for timing
);

parameter red=3'b001,yellow=3'b010,green=3'b100; //traffic lights
parameter sec30=30,sec10=10,sec5=5; //timings to turn green,yellow lights

parameter s0=0,s1=1,s2=2,s3=3,s4=4,s5=5,s6=6,s7=7; //required states
reg[2:0] ps; //present state

always @(posedge clk or posedge rst)
begin
     if(rst == 1)
        begin
             ps<=s0;
             count<=1;
        end
     
     else
        case(ps)
        s0 : if(sensor_north) begin
                if(count<30) begin ps<=s0;count<=count+1; end    /* s0 for NS, NW. It allows vehicles for 30sec (GREEN) */
                else begin ps<=s1;count<=1; end
                end
             else begin ps<=s2; count<=1; end
             
        s1 : if(count<5) begin ps<=s1; count<=count+1; end      /* s1 for NS, NW. It allows vehicles for 5sec (YELLOW) */
             else begin ps<=s2; count<=1; end
 
        s2 : if(sensor_east) begin
                if(count<30) begin ps<=s2;count<=count+1; end    /* s2 for EW, EN. It allows vehicles for 30sec (GREEN) */
                else begin ps<=s3;count<=1; end
                end
             else begin ps<=s4; count<=1; end
             
        s3 : if(count<5) begin ps<=s3; count<=count+1; end      /* s3 for EW, EN. It allows vehicles for 5sec (YELLOW) */
             else begin ps<=s4; count<=1; end
             
        s4 : if(sensor_south) begin
                if(count<30) begin ps<=s4;count<=count+1; end    /* s4 for SN, SE. It allows vehicles for 30sec (GREEN) */
                else begin ps<=s5;count<=1; end
                end
             else begin ps<=s6; count<=1; end
             
        s5 : if(count<5) begin ps<=s5; count<=count+1; end      /* s5 for SN, SE. It allows vehicles for 5sec (YELLOW) */
             else begin ps<=s6; count<=1; end
             
        s6 : if(sensor_north) begin
                if(count<30) begin ps<=s6;count<=count+1; end    /* s6 for WE, WS. It allows vehicles for 30sec (GREEN) */
                else begin ps<=s7;count<=1; end
                end
             else begin ps<=s0; count<=1; end
             
        s7 : if(count<5) begin ps<=s7; count<=count+1; end      /* s7 for WE, WS. It allows vehicles for 5sec (YELLOW) */
             else begin ps<=s0; count<=1; end
             
        default : begin ps<=s0; count<=1; end
        endcase
end

always @(ps or emrg)
begin
     if(emrg)
       begin NS=red;NW=red;EW=red;EN=red;SN=red;SE=red;WE=red;WS=red; end //emrg is for amublance, protocals etc.,
     else
       case(ps)
                    s0  :   begin NS=green;NW=green;EW=red;EN=red;SN=red;SE=red;WE=red;WS=red; end //turn green state for North
                    s1  :   begin NS=yellow;NW=yellow;EW=red;EN=red;SN=red;SE=red;WE=red;WS=red; end //trun yellow state for North
                    s2  :   begin NS=red;NW=red;EW=green;EN=green;SN=red;SE=red;WE=red;WS=red; end //turn green state for East
                    s3  :   begin NS=red;NW=red;EW=yellow;EN=yellow;SN=red;SE=red;WE=red;WS=red; end //turn yellow state for East
                    s4  :   begin NS=red;NW=red;EW=red;EN=red;SN=green;SE=green;WE=red;WS=red; end //turn green state for South
                    s5  :   begin NS=red;NW=red;EW=red;EN=red;SN=yellow;SE=yellow;WE=red;WS=red; end //turn yellow state for South
                    s6  :   begin NS=red;NW=red;EW=red;EN=red;SN=red;SE=red;WE=green;WS=green; end //turn green state for West
                    s7  :   begin NS=red;NW=red;EW=red;EN=red;SN=red;SE=red;WE=yellow;WS=yellow; end //turn yellow state for West
               default  :   begin NS=green;NW=green;EW=red;EN=red;SN=red;SE=red;WE=red;WS=red; end
               endcase
end

always @(posedge clk or posedge alert1 or posedge alert2)
begin
     if(alert1 | alert2) /* incase of any accidents 1) alert1 for divider collosions, 2) alert2 for vehicle colisions */
        begin ambulance<=1; police<=1; end
     else
        begin ambulance<=0; police<=0; end 
end

endmodule
