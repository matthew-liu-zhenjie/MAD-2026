`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2023 12:25:16
// Design Name: 
// Module Name: VHpaint
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


module VHpaint(
    input CLOCK,
    input [6:0] sw,
    inout PS2Clk,PS2Data, //Mouse
    output cs,sdin,sclk,d_cn,resn,vccen,pmoden
    );
    wire frame_begin,sending_pixels,sample_pixel;
    wire [12:0] pixel_index;
    reg [15:0] oled_data;
    wire [15:0] outlines;
    wire [15:0] blocks;
    wire clk_1hz;
    
    //MouseStuff
    wire [11:0] x_input;
    wire [11:0] y_input;
    wire click; //click input from mouse
    wire full_click; //debounced click input
    wire [6:0] x_val;
    wire [6:0] y_val;
    wire [6:0] conv_x;
    wire [5:0] conv_y;
    wire [15:0] mousePos;
    
    wire oledClk;
    wire debounceClk;
    //96*64 display
    
    wire [15:0] palette;
    wire [15:0] cursor;
    wire [15:0] painting;
    wire [2:0] colour;
    //declare clocks
    clocks clock(.CLOCK(CLOCK),.clk_625mhz(oledClk),.clk_1hz(clk_1hz));
    ThousandHz debounce_clk(CLOCK, debounceClk);
    
    //Declare OLED
    Oled_Display od0 (oledClk, ,frame_begin, 
                sending_pixels, sample_pixel, pixel_index, oled_data, 
                cs, sdin, sclk, d_cn, resn, vccen, pmoden);
    
    //Connect Mouse inputs
    MouseCtl Mouse (CLOCK,,x_input,y_input,,click,,,,,,,,,PS2Clk, PS2Data);    
    debouncer(click, debounceClk, full_click);
    convertXY xy_conv(pixel_index, x_val, y_val);
    
    //States: 00 black 01 red 10 green 11 blue 1xx white
    assign conv_x = x_input/10;
    assign conv_y = y_input/10;
    //
    SelectColor(oledClk, x_val, y_val, conv_x, conv_y, full_click, colour, palette);
    Draw(oledClk, x_val, y_val, conv_x, conv_y, full_click, colour, painting);
    altMouseDisplay(CLOCK, x_val, y_val, conv_x, conv_y, cursor);
    /*
        input clock,
        input [6:0] x_val, y_val,
        input [6:0] conv_x, 
        input [5:0] conv_y,
        output reg [15:0] oled_data = 0
    );
    */
    always @(posedge oledClk) begin
        oled_data <= palette & cursor & painting & 16'hFFFF;
    end
endmodule
