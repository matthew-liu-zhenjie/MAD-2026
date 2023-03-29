`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2023 14:46:57
// Design Name: 
// Module Name: Draw
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


module Draw(
    input clock,
    input [6:0] x_val, y_val,
    input [6:0] conv_x, 
    input [5:0] conv_y,
    input full_click,
    input [2:0] colour,
    output reg [15:0] oled_data = 0
    );
    parameter x_offset = 38; //20 for 30 bit width
    parameter y_offset = 17; //17 for 30 bit width
    /*
    canvas size = x-30 by y-30
    start_x = (96-12-30)/2 + 12 = 38
    end_x = 68
    start_y = 17
    end_y = 47 
    */
    
    parameter border_colour = 16'h9BC0;
    parameter blue = 16'h001F;
    parameter red = 16'hF800;
    parameter green = 16'h07E0;
    parameter white = 16'hFFFF;
    parameter black = 16'h0000;
    parameter cyan = 16'h07FF;
    parameter magneta = 16'hF81F;
    parameter orange = 16'hFBC0;
    
    reg parity = 0;
    reg [2:0] canvas[32:0][32:0]; //32 by 32 array of size 2 bits per address. (0, white) (1, black) (2, red) (3, blue)
    
    always @(posedge clock) begin
        if (full_click && (conv_x > 38) && (conv_x < 68) && (conv_y > 17) && (conv_y < 47)) begin
            canvas[conv_x - x_offset][conv_y-y_offset] <= colour;
            canvas[conv_x - x_offset][conv_y-y_offset + 1] <= colour;
            canvas[conv_x - x_offset][conv_y-y_offset - 1] <= colour;
            canvas[conv_x - x_offset - 1][conv_y-y_offset+1] <= colour;
            canvas[conv_x - x_offset - 1][conv_y-y_offset-1] <= colour;
            canvas[conv_x - x_offset - 1][conv_y-y_offset] <= colour;
            canvas[conv_x - x_offset + 1][conv_y-y_offset] <= colour;
            canvas[conv_x - x_offset + 1][conv_y-y_offset - 1] <= colour;
            canvas[conv_x - x_offset + 1][conv_y-y_offset + 1] <= colour;
        end
        if ((x_val >37) && (x_val < 69) && (y_val > 16) && (y_val < 48))begin
            if (canvas[x_val-x_offset][y_val-y_offset] == 3'b000) begin
                oled_data <= white;
            end
            else if (canvas[x_val-x_offset][y_val-y_offset] == 3'b001) begin
                oled_data <= black;
            end
            else if (canvas[x_val-x_offset][y_val-y_offset] == 3'b010) begin
                oled_data <= red;
            end
            else if (canvas[x_val-x_offset][y_val-y_offset] == 3'b011) begin
                oled_data <= blue;
            end
            else if (canvas[x_val-x_offset][y_val-y_offset] == 3'b100) begin
                oled_data <= green;
            end
            else if (canvas[x_val-x_offset][y_val-y_offset] == 3'b101) begin
                oled_data <= cyan;
            end
            else if (canvas[x_val-x_offset][y_val-y_offset] == 3'b110) begin
                oled_data <= magneta;
            end
            else if (canvas[x_val-x_offset][y_val-y_offset] == 3'b111) begin
                oled_data <= orange;
            end
            
        end
        else if ((y_val > 11) && (y_val < 17)) begin //canvas starts at y = 17
            if ((x_val > 32) && (x_val < 74)) begin 
                oled_data <= border_colour; //top of canvas frame
            end
            else begin
                oled_data <= white;
            end
        end
        else if ((y_val > 16) && (y_val < 48)) begin //canvas frame
            if((x_val > 32) && (x_val < 38)) begin //
                oled_data <= border_colour;
            end
            else if ((x_val > 68) && (x_val < 74)) begin
                oled_data <= border_colour; //middle portions
            end
            else begin
                oled_data <= white;
            end
        end
        else if ((y_val > 47) && (y_val < 53)) begin
            if ((x_val > 32) && (x_val < 74)) begin 
                oled_data <= border_colour; //bottom of canvas frame
            end
            else begin
                oled_data <= white;
            end
        end
        else begin
            oled_data <= white;
        end
    end
    
endmodule
