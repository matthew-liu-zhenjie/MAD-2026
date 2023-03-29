`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2023 14:37:09
// Design Name: 
// Module Name: SelectColor
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


module SelectColor(
    input clock,
    input [6:0] x_val, y_val,
    input [6:0] conv_x, 
    input [5:0] conv_y,
    input full_click,
    output reg [2:0] color = 0,
    output reg [15:0] oled_data = 0
    );
    always @(posedge clock) begin
        if (conv_x < 12 && conv_x >= 0) begin
            if (conv_y < 8 && conv_y > 0 && full_click) begin
                color <= 3'b000; //white
            end
            else if (conv_y < 16 && conv_y > 8 && full_click) begin
                color <= 3'b001; //black
            end
            else if (conv_y < 24 && conv_y > 16 && full_click) begin
                color <= 3'b010; //red
            end
            else if (conv_y < 32 && conv_y > 24 && full_click) begin
                color <= 3'b011; //blue
            end
            else if (conv_y < 40 && conv_y > 32 && full_click) begin
                color <= 3'b100; //green
            end
            else if (conv_y < 48 && conv_y > 40 && full_click) begin
                color <= 3'b101; //cyan
            end
            else if (conv_y < 56 && conv_y > 48 && full_click) begin
                color <= 3'b110; //magneta
            end
            else if (conv_y < 64 && conv_y > 56 && full_click) begin
                color <= 3'b111; //orange
            end
        end
        
        if (y_val < 8 && y_val > 0 && x_val < 12 && x_val > 0) begin
            oled_data <= 16'hFFFF; //white
        end
        else if (y_val < 16 && y_val > 8 && x_val < 12 && x_val > 0) begin
            oled_data <= 16'h0000; //black
        end
        else if (y_val < 24 && y_val > 16 && x_val < 12 && x_val > 0) begin
            oled_data <= 16'hF800; //red
        end
        else if (y_val < 32 && y_val > 24 && x_val < 12 && x_val > 0) begin
            oled_data <= 16'h001F; //blue
        end
        else if (y_val < 40 && y_val > 32 && x_val < 12 && x_val > 0) begin
            oled_data <= 16'h07E0; //green
        end
        else if (y_val < 48 && y_val > 40 && x_val < 12 && x_val > 0) begin
            oled_data <= 16'h07FF; //cyan
        end
        else if (y_val < 56 && y_val > 48 && x_val < 12 && x_val > 0) begin
            oled_data <= 16'hF81F; //magneta
        end
        else if (y_val < 64 && y_val > 56 && x_val < 12 && x_val > 0) begin
            oled_data <= 16'hFBC0; //orange
        end
        else if (x_val < 12 && x_val > 0) begin
            oled_data <= 16'hA514; //off-white for everything else
        end
        else begin
            oled_data <= 16'hFFFF;
        end
        
    end
endmodule   
